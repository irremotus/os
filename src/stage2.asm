org 0x7e00
bits 16
jmp main

%include "printstr.asm"
%include "printhex.asm"
msg db "Stage 2", 13, 10, 0

main:
	cli
	mov si, msg
	call Print
	xor ax, ax
	mov ax, 0xABCD
	call PrintHex4
	hlt
