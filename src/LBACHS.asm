; Converts FAT12 cluster number in ax to LBA
; result is in ax
ClusterLBA:
	sub ax, 0x2
	xor cx, cx
	mov cl, BYTE [bpbSectorsPerCluster]
	mul cx
	ret

; Converts linear block address (LBA) in ax to cylinder head sector (CHS)
; ax is input: sector to read
; absolute[Sector|Head|Track] are output
LBACHS:
	absoluteSector db 0
	absoluteHead db 0
	absoluteTrack db 0
	xor dx, dx
	div WORD [bpbSectorsPerTrack]
	inc dl
	mov BYTE [absoluteSector], dl

	xor dx, dx
	div WORD [bpbHeadsPerCylinder]
	mov BYTE [absoluteHead], dl

	mov BYTE [absoluteTrack], al
	ret
