; Initialization
	lis $4
	.word 4
	lis $5
	.word -1
	add $3, $5, $0

top:
	beq $2, $0, 4
	mult $2, $4
	mflo $5
	add $5, $1, $5
	lw $3, -4($5)

; Exit to the O/S
	jr $31
