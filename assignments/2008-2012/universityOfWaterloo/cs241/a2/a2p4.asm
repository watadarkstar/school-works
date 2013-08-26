; Initialization
	lis $4
	.word 4
	lis $10
	.word 1
	add $5, $1, $0
	lw $3, 0($1)
	add $9, $0, $0

top:
	beq $9, $2, 7 
	lw $8, 4($5)
	slt $6, $3, $8
	add $5, $5, $4
	add $9, $9, $10
	beq $6, $0, 1
	add $3, $8, $0
	beq $0, $0, top

; Exit to the O/S
	jr $31
