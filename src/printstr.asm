; ## Print function ##
; prints DS:SI 0 term
Print:
	pusha
.start:
	lodsb 		; load the next character
	or al, al 	; check if it's zero
	jz PrintDone 	; if it's zero, return
	mov ah, 0xe 	; select print type
	int 0x10 	; execute the BIOS interrupt
	jmp .start 	; do it again until we finish
PrintDone:
	popa
	ret
