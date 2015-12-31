; Read sectors from cylinder 1, head 0, hard drive 0
; al: number of sectors
; cl: sector number
; ch: low byte of cylinder number
; dh: head number
; ES:BX: where to read to
ReadSectors:
	mov ah, 0x02
	mov dl, 128 ; drive number, 128 means hard drive 0
	int 0x13
	mov si, reading
	call Print
	jc ReadSectors

	mov si, readdone
	call Print

	ret
