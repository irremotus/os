org 0x0
bits 16
jmp main

; Print null terminated string in DS:SI
Print:
	lodsb
	or al, al
	jz PrintDone
	mov ah, 0eh
	int 0x10
	jmp Print
PrintDone:
	ret

main:
	cli
	push cs
	pop ds

	mov si, msg

msg db "Stage 2", 13, 10, 0
