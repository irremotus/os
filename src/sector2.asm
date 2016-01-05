org 0x7e00
%include "printstr.asm"

msg_sector2 db "This is sector 2"

mov si, msg_sector2
call Print

cli
hlt
