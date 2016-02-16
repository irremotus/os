; Read sectors from hard drive
; al: number of sectors
; cl: sector number (starts at 1)
; ch: low byte of cylinder (track) number (starts at 0)
; dh: head number (starts at 0)
; ES:BX: where to read to
msg_read_error db "Disk Error", 13, 10, 0
read_error:
	mov si, msg_read_error
	call Print
	cli
	hlt
	
ReadSectors:
	pusha
.reset:
	xor ah, ah ; select 'drive reset'
	int 0x13 ; execute the BIOS interrupt
	jc .reset ; keep trying to reset drive until it works
	mov ah, 0x2 ; select 'read sector'
	int 0x13 ; execute the BIOS interrupt
	jnc .end ; if it worked, return
	jmp read_error ; if it didn't work, print a message and halt
.end:
	popa
	ret

