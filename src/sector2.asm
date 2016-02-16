org 0x7e00

jmp doprint

%include "printstr.asm"

msg_sector2 db "This is sector 2", 13, 10, 0

doprint:
	mov si, msg_sector2
	call Print

cli
hlt
