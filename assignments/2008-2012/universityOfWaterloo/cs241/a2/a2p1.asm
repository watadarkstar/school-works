; Initialization
	add $3, $1, $0	;put the number from register 1 to register 3

; check max
	slt $4, $1, $2	;compare the number $1 and $2, then place result in $4
	beq $4, $0, 1	;check if $4 is true or not
	add $3, $2, $0	;if true, put the number from register 2 to register 3

; Exit to the O/S
	jr $31
