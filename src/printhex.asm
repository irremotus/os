; ## Print hex function ##
; prints the 4 hex characters represented by the bytes in AX
PrintHex4:
	pusha
	mov cx, 4
.start:
	xor bx, bx
	mov bl, ah
	shl ax, 4
	shr bl, 4
	and bl, 0x0F
	add bl, 48
	cmp bl, 57
	jng .print
.letter:
	add bl, 65-58
.print:
	push ax
	mov al, bl
	mov ah, 0xe
	int 0x10
	pop ax
.done:
	dec cx
	test cx, cx
	jz .end
	jmp .start
.end:
	popa
	ret
.halt:
	hlt
