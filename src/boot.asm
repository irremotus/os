org 0x7c00
bits 16

start:
	jmp loader



; ########### OEM Parameters ############
bpbOEM:			DB "My OS   "
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 512
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "
; #######################################


ImageName db "STAGE2  SYS", 0
msg db "Test", 13, 10, 0
reading db "Reading", 13, 10, 0
readdone db "Read done", 13, 10, 0
msg_failure "Failed to load second stage loader: file does not exist.", 13, 10, 0

%include "printstr.asm"
%include "ReadSectors.asm"
%include "LBACHS.asm"

FAILURE:
	mov si, msg_failure
	call Print
	cli
	hlt

loader:
	; set DS and ES to 0
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov si, msg
	call Print

; reset disk
.reset:
	mov ah, 0
	mov dl, 0
	int 0x13
	jc .reset

;	; set ES to 0x1000
;	mov ax, 0x1000
;	mov es, ax
;	xor bx, bx
;	; read 1 sector starting at sector 2 to 0x1000:0
;	mov al, 1
;	mov cl, 2
;	call ReadSectors
;
;	jmp 0x1000:0x0


; load root directory
	; Find start of root entry
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT]
	add ax, [bpbReservedSectors]
	mov cx, ax

	; Find number of sectors in root entry
	mov ax, 0x0020
	mul WORD [bpbRootEntries]
	div WORD [bpbBytesPerSector]

	; Load root entry
	mov bx, 0x200
	call ReadSectors

	; Find stage2
	mov cx, [bpbRootEntries]
	mov di, 0x200
.LOOP:
	push cx
	mov cx, 11
	mov si, ImageName
	push di
	repe cmpsb ; compare strings
	pop di
	je load_fat
	pop cx
	add di, 32
	loop .LOOP
	jmp FAILURE

load_fat:
	mov dx, [di + 26] ; first cluster
	xor ax, ax
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT] ; ax is number of sectors in FAT

	mov cx, WORD [bpbReservedSectors] ; location of FAT
	mov bx, 0x200

	call ReadSectors




times 510 - ($-$$) db 0

dw 0xAA55
