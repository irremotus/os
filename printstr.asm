; ## Print function ##
; prints DS:SI 0 term
Print:
	lodsb
	or al, al
	jz PrintDone
	mov ah, 0eh
	int 10h
	jmp Print
PrintDone:
	ret
