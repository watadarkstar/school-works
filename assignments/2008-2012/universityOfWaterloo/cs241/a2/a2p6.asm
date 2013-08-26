; Initialization
	lis $10
	.word 10
	lis $5
	.word 0xffff000c
	lis $4
	.word 0x30
	lis $8
	.word 0x2d
	lis $9
	.word 4 
	lis $11
	.word 0x00000000
	lis $12
	.word 1
	add $13, $0, $0

 

; check if positive or negative
	bne $1, $0, 5
	sw $4, 0($5)
	beq $0, $0, return
	bne $1, $20, 2
	sw $20, 0($5)
	beq $0, $0, return
	slt $6, $0, $1	
	bne $6, $0, 2	;print "-" if negative
	sw $8, 0($5)
	sub $1, $0, $1	;find the absolute value if negative

positive: 
	beq $1, $0, top 
	divu $1, $10
	mfhi $3
	mflo $1
	add $3, $4, $3
	sw $3, 0($11)
	add $11, $11, $9
	add $13, $13, $12

	beq $0, $0, positive	

top:
	beq $13, $0, return
	lw $3, -4($11)
	sw $3, 0($5)
	sub $11, $11, $9
	sub $13, $13, $12
	beq $0, $0, top
	
return: ; print newline + Exit to the O/S
	lis $7
	.word 0x0a
	sw $7, 0($5)
	jr $31 
