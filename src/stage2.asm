org 0x0
bits 16
jmp main

%include "printstr.asm"
msg db "Stage 2", 13, 10, 0

main:
	cli
	push cs
	pop ds

	mov si, msg
	call Print
	hlt
