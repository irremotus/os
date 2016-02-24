org 0x7c00 ; this is where BIOS puts us
bits 16 ; 16 bit real mode

start:
	jmp loader ; skip the OEM parameter block and go straight to the loader

; NOTE:  we won't actually use these values; they will be overwritten by the mkfs.fat formatter
; Just keep the labels so we can access these values at runtime
; ########### OEM Parameters ############
bpbOEM:			DB "KevEvIOS" ; name our OS in the disk image; we will keep this ; 8
bpbBytesPerSector:  	DW 512 ; 2
bpbSectorsPerCluster: 	DB 1 ; 1
bpbReservedSectors: 	DW 1 ; 2
bpbNumberOfFATs: 	DB 2 ; 1
bpbRootEntries: 	DW 512 ; 2
bpbTotalSectors: 	DW 512 ; 2
bpbMedia: 	        DB 0xF8 ; 1
bpbSectorsPerFAT: 	DW 9 ; 2
bpbSectorsPerTrack: 	DW 1 ; 2
bpbHeadsPerCylinder: 	DW 1 ; 2
bpbHiddenSectors: 	DD 0 ; 4 these need to be 4 bytes
bpbTotalSectorsBig:     DD 0 ; 4 these need to be 4 bytes
bsDriveNumber: 	        DB 0 ; 1
bsUnused: 	        DB 0 ; 1
bsExtBootSignature: 	DB 0x29 ; 1
bsSerialNumber:	        DD 0xa0a1a2a3 ; 4
bsVolumeLabel: 	        DB "MOS FLOPPY " ; 11
bsFileSystem: 	        DB "FAT12   " ; 8
; #######################################

; Constant strings and values
ImageName db "STAGE2  SYS", 0 ; name of stage 2 loader
msg_test db "Test", 13, 10, 0
msg_fail db "Failure", 13, 10, 0
msg_done_reading db "Done reading", 13, 10, 0
cluster dw 0
dataStart dw 0
BOOT_DRIVE db 0

; Include the files we need with basic functions like printing
%include "printstr.asm"
%include "ReadSectors.asm"
%include "LBACHS.asm"

; Something went horribly wrong, so stop
FAILURE:
	mov si, msg_fail	; Move address of msg_fail string into si
	call Print		; Call Print function from "printstr.asm"
	cli			; Clear interrupt flag
	hlt			; Stop inst execution and plat processor in halt state

; The main loader
loader:
    	mov [BOOT_DRIVE], dl 	; get the drive we will boot from -- BIOS gives us this
				; move register dl into memory location pointed to by
				; BOOT_DRIVE, [BOOT_DRIVE] == *BOOT_DRIVE

	xor ax, ax
	mov ds, ax		; set DS and ES to 0 (Data and Extra Segment registers)
				; these cannot be set directly
	mov es, ax

	mov bp, 0x7a00 		; put the stack out of the way, the stack grows downwards
	mov sp, bp     		; sp = bp, the stack is empty

	mov si, msg_test
	call Print

; load root directory

	; Find number of sectors in root entry
	mov ax, 0x0020
	mul WORD [bpbRootEntries]
	div WORD [bpbBytesPerSector] ; number of sectors is in al
	push ax ; store this on the stack
	;mov ax, 0x1

	; Find start of root entry (numFats * sectorsPerFat + numReservedSectors + 1) = root dir sector number
	xor ax, ax
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT]
	add ax, [bpbReservedSectors]
	;inc ax ; sector to read is in al ; don't do this because it's zero indexed
	call LBACHS
	;mov cx, 0x1

	pop ax ; get back number of sectors to read

	; Load root entry
	mov dl, [BOOT_DRIVE]
	mov bx, 0x7e00
	call ReadSectors
	mov si, msg_done_reading
	call Print
	;jmp 0x0:0x7e00
	;mov si, msg_test
	;call Print


;	; Find stage2
	mov cx, [bpbRootEntries]
	mov di, 0x7e00
.LOOP:
	push cx
	mov cx, 11
	mov si, ImageName
	push di
	repe cmpsb ; compare strings
	pop di
	je load_fat
	pop cx
	add di, 32 ; next 32 byte entry
	loop .LOOP
	jmp FAILURE ; no more entries, we didn't find it

load_fat:
	mov si, msg_test
	call Print

	xor dx, dx
	mov dx, [di + 26] ; first cluster
	mov [cluster], dx

	; Find number of sectors in root entry
	mov ax, 0x0020 ; 32 byte entries
	mul WORD [bpbRootEntries]
	div WORD [bpbBytesPerSector]
	mov [dataStart], ax ; location of the data (not done yet)

	xor ax, ax
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT] ; ax is number of sectors in FAT
	add [dataStart], ax

	mov ax, WORD [bpbReservedSectors] ; location of FAT
	add [dataStart], ax
	; location of data is done

	xor ax, ax
	mov ax, [cluster]
	call ClusterLBA ; convert cluster to linear address
	add ax, [dataStart]
	call LBACHS ; convert linear address to CHS
	; read the sectors
	mov al, BYTE [bpbSectorsPerCluster]
	mov bx, 0x7e00
	mov dl, [BOOT_DRIVE]
	mov al, 1
	mov cl, 0x29
	mov ch, 0
	mov dh, 0
	call ReadSectors
	mov si, msg_done_reading
	call Print
	;hlt
	jmp 0x0:0x7e00



times 446 - ($-$$) db 0 ; we only have 446 bytes to work with, so we don't clobber the partition table
times 510 - 446 db 0 ; these zeros get overwritten by the partition table from mkfs.fat

dw 0xAA55
