CHSLBA:
	sub ax, 0x2
	xor cx, cx
	mov cl, BYTE [pbpSectorsPerCluster]
	mul cx
	ret

; ax is input: sector to read
LBACHS:
	xor dx, dx
	div WORD [bpbSectorsPerTrack]
	inc dl
	mov BYTE [absoluteSector], dl

	xor dx, dx
	div WORD [bpbHeadsPerCylinder]
	mov BYTE [absoluteHead], dl

	mov BYTE [absoluteTrack], al
	ret
