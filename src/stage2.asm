org 0x7e00
bits 16
jmp main

%include "printstr.asm"
msg db "Stage 2", 13, 10, 0

main:
	cli
	mov si, msg
	call Print
	hlt
