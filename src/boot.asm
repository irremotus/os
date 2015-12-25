org 0x7c00

bits 16

start:
	cli
	hlt

times 510 - ($-$$) db 0

dw 0xAA55
