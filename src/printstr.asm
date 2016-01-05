; ## Print function ##
; prints DS:SI 0 term
Print:
	lodsb
	or al, al
	jz PrintDone
	mov ah, 0xe
	int 0x10
	jmp Print
PrintDone:
	ret

; ## Print function ##
; prints DS:SI 0 term
PrintR:
	mov al, '{'
	mov ah, 0xe
	int 0x10
PrintRloop:
	lodsb
	or al, al
	jz PrintRDone
	mov ah, 0xe
	int 0x10
	jmp PrintRloop
PrintRDone:
	mov al, '}'
	mov ah, 0xe
	int 0x10
	ret

; ## Print function ##
; prints 11 chars at dx
Print11:
	push ecx
	push eax

	mov ecx, 32 ; 11
Print11loop:
	mov al, BYTE [edx]
	dec edx
	mov ah, 0xe
	int 0x10
	loop Print11loop

	mov al, 13
	mov ah, 0xe
	int 0x10
	mov al, 10
	mov ah, 0xe
	int 0x10
	pop eax
	pop ecx
	ret

