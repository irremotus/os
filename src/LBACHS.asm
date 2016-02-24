; Converts FAT12 cluster number in ax to LBA
; result is in ax

result dw 0

ClusterLBA:
	pusha
	sub ax, 0x2
	xor cx, cx
	mov cl, BYTE [bpbSectorsPerCluster]
	mul cx
	mov [result], ax
	popa
	mov ax, [result]
	ret

; Converts linear block address (LBA) in ax to cylinder head sector (CHS)
; ax is input: sector to read
; absolute[Sector|Head|Track] are output

absoluteSector db 0
absoluteHead db 0
absoluteTrack db 0

LBACHS:
	pusha
	xor dx, dx
	div WORD [bpbSectorsPerTrack]
	inc dl
	mov BYTE [absoluteSector], dl

	xor dx, dx
	div WORD [bpbHeadsPerCylinder]
	mov BYTE [absoluteHead], dl

	mov BYTE [absoluteTrack], al

	popa

	mov BYTE cl, [absoluteSector]
	mov BYTE ch, [absoluteTrack]
	mov BYTE dh, [absoluteHead]

	ret
