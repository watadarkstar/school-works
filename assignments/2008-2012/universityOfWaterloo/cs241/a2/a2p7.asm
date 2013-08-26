; a2p7.asm

	sw $31, -4($30)
	lis $31
	.word 4
	sub $30, $30, $31
	lis $11
	.word 1
	add $5, $1, $5
	
loop:
	beq $2, $0, final
	lw $1, 0($5)
	add $5, $5, $31
	lis $3
	.word print
	sub $2, $2, $11
	jalr $3
	lis $31
	.word 4
	beq $0, $0, loop
	
final:
	add $30, $30, $31
	lw $31, -4($30)
	jr $31

