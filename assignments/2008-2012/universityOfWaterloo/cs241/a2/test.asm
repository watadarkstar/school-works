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


print:

; Save the registers used
	sw $31, -4($30)
	lis $31
	.word -4
	add $30, $30, $31

	sw $1, -4($30)
	add $30, $30, $31

	sw $2, -4($30)
	add $30, $30, $31

	sw $3, -4($30)
	add $30, $30, $31

	sw $4, -4($30)
	add $30, $30, $31
	
	sw $5, -4($30)
	add $30, $30, $31

	sw $6, -4($30)
	add $30, $30, $31

	sw $7, -4($30)
	add $30, $30, $31

	sw $8, -4($30)
	add $30, $30, $31

	sw $9, -4($30)
	add $30, $30, $31

	sw $10, -4($30)
	add $30, $30, $31

	sw $11, -4($30)
	add $30, $30, $31

	sw $12, -4($30)
	add $30, $30, $31

	sw $13, -4($30)
	add $30, $30, $31

	sw $14, -4($30)
	add $30, $30, $31

	sw $15, -4($30)
	add $30, $30, $31
	
	sw $16, -4($30)
	add $30, $30, $31

	sw $17, -4($30)
	add $30, $30, $31

	sw $18, -4($30)
	add $30, $30, $31

	sw $19, -4($30)
	add $30, $30, $31

	sw $20, -4($30)
	add $30, $30, $31

	sw $21, -4($30)
	add $30, $30, $31

	sw $22, -4($30)
	add $30, $30, $31

	sw $23, -4($30)
	add $30, $30, $31

	sw $24, -4($30)
	add $30, $30, $31

	sw $25, -4($30)
	add $30, $30, $31

	sw $26, -4($30)
	add $30, $30, $31
	
	sw $27, -4($30)
	add $30, $30, $31

	sw $28, -4($30)
	add $30, $30, $31

	sw $29, -4($30)
	add $30, $30, $31


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
	beq $13, $0, printline
	lw $3, -4($11)
	sw $3, 0($5)
	sub $11, $11, $9
	sub $13, $13, $12
	beq $0, $0, top

printline:
	lis $7
	.word 0x0a
	sw $7, 0($5)
	beq $0, $0, return

return: ; restore resgister + Exit to the O/S
	lis $31
	.word -4
	sub $30, $30, $31
	lw $29, -4($30)
	sub $30, $30, $31
	lw $28, -4($30)
	sub $30, $30, $31
	lw $27, -4($30)
	sub $30, $30, $31
	lw $26, -4($30)
	sub $30, $30, $31
	lw $25, -4($30)
	sub $30, $30, $31
	lw $24, -4($30)
	sub $30, $30, $31
	lw $23, -4($30)
	sub $30, $30, $31
	lw $22, -4($30)
	sub $30, $30, $31
	lw $21, -4($30)
	sub $30, $30, $31
	lw $20, -4($30)
	sub $30, $30, $31
	lw $19, -4($30)
	sub $30, $30, $31
	lw $18, -4($30)
	sub $30, $30, $31
	lw $17, -4($30)
	sub $30, $30, $31
	lw $16, -4($30)
	sub $30, $30, $31
	lw $15, -4($30)
	sub $30, $30, $31
 	lw $14, -4($30)
	sub $30, $30, $31
	lw $13, -4($30)
	sub $30, $30, $31
	lw $12, -4($30)
	sub $30, $30, $31
	lw $11, -4($30)
	sub $30, $30, $31
	lw $10, -4($30)
	sub $30, $30, $31
	lw $9, -4($30)
	sub $30, $30, $31
	lw $8, -4($30)
	sub $30, $30, $31
	lw $7, -4($30)
	sub $30, $30, $31
	lw $6, -4($30)
	sub $30, $30, $31
	lw $5, -4($30)
	sub $30, $30, $31
	lw $4, -4($30)
	sub $30, $30, $31
	lw $3, -4($30)
	sub $30, $30, $31
	lw $2, -4($30)
	sub $30, $30, $31
	lw $1, -4($30)
	sub $30, $30, $31
	lw $31, -4($30)
	
	jr $31
	


