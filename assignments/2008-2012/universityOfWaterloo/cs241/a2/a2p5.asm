; Initialization
	lis $3
	.word 0xffff000c
	lis $10
	.word -1
	lis $4
	.word 4
	add $5, $1, $0
	lis $6
	.word 0x40
	lis $9
	.word 0x20

top:
	beq $2, $0, 11
	lw $7, 0($5)

	bne $7, $0, 4
	sw $9, 0($3)
	add $2, $10, $2
	add $5, $5, $4
	beq $0, $0, top

	add $5, $5, $4
	add $8, $6, $7
	sw $8, 0($3)
	add $2, $10, $2
	beq $0, $0, top

; Exit to the O/S
	jr $31
