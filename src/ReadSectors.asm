; Read sectors from hard drive
; al: number of sectors
; cl: sector number (starts at 1)
; ch: low byte of cylinder (track) number (starts at 1)
; dh: head number (starts at 0)
; ES:BX: where to read to
msg_read_error db "disk error", 13, 10, 0
read_error:
	mov si, msg_read_error
	call Print
	cli
	hlt
	ret
	
ReadSectors:
	;mov cx, 3
	;push cx
;.loop:
	;mov dl, al
	;push dx
	mov ah, 0x02
	;mov dl, 128 ; drive number, 128 means hard drive 0
	int 0x13
	;mov si, reading
	;call Print
	;jc ReadSectors
	jc read_error
	;pop dx
	cmp al, dl
	jne read_error
	;jne .read_error_check
	;mov si, readdone
	;call Print
	ret
;.read_error_check:
;	pop cx
;	loop .loop
;	jmp read_error
