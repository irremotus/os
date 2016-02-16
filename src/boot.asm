org 0x7c00 ; this is where BIOS puts us
bits 16 ; 16 bit real mode

start:
	jmp 0x0000:loader ; skip the OEM parameter block and go straight to the loader



; ########### OEM Parameters ############
bpbOEM:			DB "KevEvIOS"
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	DB 2
bpbRootEntries: 	DW 512
bpbTotalSectors: 	DW 512
bpbMedia: 	        DB 0xF8
bpbSectorsPerFAT: 	DW 9
bpbSectorsPerTrack: 	DW 512
bpbHeadsPerCylinder: 	DW 1
bpbHiddenSectors: 	DW 0
bpbTotalSectorsBig:     DW 0
bsDriveNumber: 	        DB 0
bsUnused: 	        DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "
; #######################################

; Constant strings and values
ImageName db "STAGE2  SYS", 0 ; name of stage 2 loader
msg_test db "Test", 13, 10, 0
msg_fail db "Failure", 13, 10, 0
msg_done_reading db "Done reading", 13, 10, 0
cluster db 0
dataStart dw 0
BOOT_DRIVE db 0

; Include the files we need with basic functions like printing
%include "printstr.asm"
%include "ReadSectors.asm"
%include "LBACHS.asm"

; Something went horribly wrong, so stop
FAILURE:
	mov si, msg_fail
	call Print
	cli
	hlt

; The main loader
loader:
	mov [BOOT_DRIVE], dl ; get the drive we will boot from -- BIOS gives us this
	; set DS and ES to 0 (Data and Extra Segment registers)
	; these cannot be set directly
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov bp, 0x7a00 ; put the stack out of the way
	mov sp, bp

	mov si, msg_test
	call Print

; load root directory
	; Find start of root entry
	xor ax, ax
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT]
	add ax, [bpbReservedSectors]
	mov cx, ax ; sector to read is in cl

	; Find number of sectors in root entry
	mov ax, 0x0020
	mul WORD [bpbRootEntries]
	div WORD [bpbBytesPerSector] ; number of sectors is in al

	; Load root entry

	mov ch, 0
	mov dh, 0

	mov ax, 0x7e0
	mov es, ax
	xor bx, bx

	mov dl, [BOOT_DRIVE]
	mov cl, 2
	mov al, 1 ; get rid of this!!!!
	call ReadSectors
	mov si, msg_done_reading
	call Print
	;cli
	;hlt
	jmp 0x7e0:0x0
	mov si, msg_test
	call Print

;	; Find stage2
;	xor ecx, ecx
;	;mov cx, [bpbRootEntries]
;	mov cx, 10
;	mov di, 0x200
;.LOOP:
;	push cx
;	push di
;	xor edx, edx
;	mov si, di
;	call Print11
;	mov cx, 11
;	mov si, ImageName
;	;call Print
;	push di
;	repe cmpsb ; compare strings
;	pop di
;	je load_fat
;	pop di
;	pop cx
;	add di, 32
;	loop .LOOP
;	jmp FAILURE

;load_fat:
;	mov ax, [di + 26] ; first cluster
;	mov [cluster], ax
;
;	; Find number of sectors in root entry
;	mov ax, 0x0020
;	mul WORD [bpbRootEntries]
;	div WORD [bpbBytesPerSector]
;	mov [dataStart], ax ; location of the data (not done yet)
;
;	xor ax, ax
;	mov al, [bpbNumberOfFATs]
;	mul WORD [bpbSectorsPerFAT] ; ax is number of sectors in FAT
;	add [dataStart], ax
;
;	mov ax, WORD [bpbReservedSectors] ; location of FAT
;	add [dataStart], ax
;	; location of data is done
;
;	mov ax, [cluster]
;	call ClusterLBA ; convert cluster to linear address
;	call LBACHS ; convert linear address to CHS
;	; read the sectors
;	mov ch, BYTE [absoluteTrack]
;	mov cl, BYTE [absoluteSector]
;	mov dh, BYTE [absoluteHead]
;	mov al, BYTE [bpbSectorsPerCluster]
;	mov bx, 0x200
;	call ReadSectors




times 510 - ($-$$) db 0

dw 0xAA55
