; a2p8.asm

	sw $31, -4($30)
	lis $31
	.word 4
	sub $30, $30, $31
	lis $11
	.word 1
	add $5, $1, $5
	add $3, $0, $11
	lis $12
	.word 12
	add $12, $0, $0
	lis $22
	.word 3

loop:
	beq $2, $21, return
	lis $20
	.word helper
	lw $1, 0($5)
	add $5, $5, $12
	add $21, $21, $22
	jalr $20
	lis $31
	.word 4
	beq $0, $0, loop

return:
	add $30, $30, $31
	lw $31, -4($30)
	jr $31

helper:
	lis $3
	.word savereg1
	sw $1, 0($3)
	lis $3
	.word savereg2
	sw $2, 0($3)

haveleftright:
	add $3, $0, $0
	lis $11
	.word -1
	lis $4
	.word 4
	add $5, $1, $0

left:
	lw $6, 4($5)
	beq $6, $11, right
	sub $3, $3, $11
	beq $0, $0, final

right:
	lw $6, 8($5)
	beq $6, $11, final
	sub $3, $3, $11
	beq $0, $0, final

final:
	lis $1
	.word savereg1
	lw $1, 0($1)
	lis $2
	.word savereg2
	lw $2, 0($2)
	jr $31

savereg1: .word 0
savereg2: .word 0
