# Andre Z. Ho
# andrewzh

.include "hw4_helpers.asm"

.text

##########################################
#  Part #1 Functions
##########################################
initBoard:
	li $t0, 0
	li $t1, 0x45       # E
	li $t2, 0xffff0000 # start
	li $t3, 0xffff007f # end
	
	sll $t4, $a1, 4    # shifting by 4
	or $t4, $t4, $a0   # or the result
	
	sll $t4, $t4, 8
	or $t5, $t4, $t1
	
	
	sll $t4, $a2, 4    # shifting by 4
	or $t4, $t4, $a0   # or the result
	
	sll $t4, $t4, 8
	or $t6, $t4, $t1

createLoop1:
	li $t9, 8
	beq $t0, $t9, inter1
	
	
	bge $t2, $t3, done
	sh $t6, 0($t2)     # store the E
	addi $t2, $t2, 2
	
	bge $t2, $t3, done
	sh $t5, 0($t2)     # store the E
	addi $t2, $t2, 2
	
	addi $t0, $t0, 2
	
	j createLoop1
	
createLoop2:
	li $t9, 8
	beq $t0, $t9, inter2
	bge $t2, $t3, done
	sh $t5, 0($t2)     # store the E
	addi $t2, $t2, 2
	
	bge $t2, $t3, done
	sh $t6, 0($t2)     # store the E
	addi $t2, $t2, 2
	
	addi $t0, $t0, 2

	j createLoop2
	
inter1:
	li $t0, 0
	j createLoop2
	
inter2:
	li $t0, 0
	j createLoop1

done: 
	jr $ra






setSquare:
	blt $a0, $zero, error  #testing for row
	li $t0, 7
	bgt $a0, $t0, error
	
	blt $a1, $zero, error # testing for column
	li $t0, 7
	bgt $a1, $t0, error
	
	lw $t0, 0($sp)   #the fg
	li $t1, 0xF
	bgt $t0, $t1, error
	
	li $t0, 1		#testing for player
	beq $a3, $t0, white
	li $t0, 2
	beq $a3, $t0, black
	
	j error

white:
	li $t9, 0xF
	j start

black:
	li $t9, 0x0
	j start
	
start:
	li $t0, 8          # length of row
	mul $t1, $a0, $t0  # getting row value
	li $t0, 2          # mem per piece
	mul $t1, $t1, $t0  # mul the row by 2
	
	mul $t2, $a1, $t0 # getting column
	
	add $t3, $t1, $t2  # adding the row and column value
	
	li $t0, 0xffff0000 # getting address
	add $t0, $t0, $t3  # adding total to address
	
	lh $t5, 0($t0)     # geting value stored at address
	
	sra $t5, $t5, 12   # shifting values to remove previous ascii and fg
	sll $t5, $t5, 12
	
	li $t8, 0x45
	beq $a2, $t8, fgUse # checking for E
	
	sll $t9, $t9, 8
	or $t6, $t9, $a2
	or $t5, $t5, $t6
	
	sh $t5, 0($t0)
	
	li $v0, 0
	jr $ra

fgUse:
	lw $t7, 0($sp)
	sll $t7, $t7, 8
	or $t6, $t7, $a2
	or $t5, $t5, $t6
	
	sh $t5, 0($t0)
	
	li $v0, 0
	
	jr $ra
	
error:
	li $v0, -1
	jr $ra


initPieces:
	# insert code here
	
	li $a0, 0
	li $a1, 0
	li $a2, 0x52
	li $a3, 2
	addi $sp, $sp, -8
	li $t1, 0x0
	sw $t1, 0($sp)
	sw $ra, 4($sp)
	
	j startplace
whiteOption:
	li $t0, 7
	beq $a0, $t0, whiteOption2
	li $t0, 6
	beq $a0, $t0, done1
	
	li $a0, 7
	li $a1, 0
	li $a2, 0x52
	li $a3, 1
	li $t1, 0xF
	sw $t1, 0($sp)
	
	j startplace
whiteOption2:
	li $a0, 6
	li $a1, 0
	li $a2, 0x50
	
	j pLoop
changeup:
	li $a0, 1
	li $a1, 0
	li $a2, 0x50
	
	j pLoop

startplace:
	jal setSquare    # castle
	
	li $a1, 1
	li $a2, 0x048
	jal setSquare    # horse
	
	li $a1, 2
	li $a2, 0x042
	jal setSquare    # bishop
	
	li $a1, 3
	li $a2, 0x051
	jal setSquare	 # Queen
	
	li $a1, 4
	li $a2, 0x4B
	jal setSquare	 # King
	
	li $a1, 5
	li $a2, 0x042
	jal setSquare    # bishop
	
	li $a1, 6
	li $a2, 0x048
	jal setSquare    # horse
	
	li $a1, 7
	li $a2, 0x52
	jal setSquare    # horse
	
	beq $a0, $zero, changeup
	
pLoop:
	li $t0, 8
	beq $a1, $t0, whiteOption
	jal setSquare
	addi $a1, $a1, 1
	
	j pLoop
	
done1:
	
	lw $t1, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

mapChessMove:
	# insert code here
	
	li $t0, 0x38			# character number
	bgt $a1, $t0, done2
	li $t0, 0x31
	blt $a1, $t0, done2
	
	li $t0, 0x38			# 
	sub $t0, $t0, $a1
	sll $t0, $t0, 8
	
	li $t1, 0x41 			# character letter
	blt $a0, $t1, done2
	li $t1, 0x48
	bgt $a0, $t1, done2
	
	addi $t1,$a0, -0x41
	
	or $t2, $t0, $t1
	
	move $v0, $t2
	jr $ra

done2:
	li $v0, 0xFFFF
	jr $ra

loadGame:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp) # file name`
	sw $s0, 8($sp) # player 1
	sw $s1, 12($sp) # player 2
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	
	li $s1, 0
	li $s2, 0
	
	li $a1, 0 # sets thingy 1
	li $a2, 0 # sets thingy 2 aka mode
	
	li $v0, 13 # calls to open file
	syscall
	
	blt $v0, $zero, failed #checks to see if fail
	
	move $a0, $v0 # moves descriptor to $a0
	
	
	move $a1, $sp # move buffer to a1
	move $s0, $a0 # move the descriptor to s0 for saving
	
loadLoop:
	move $a0, $s0 # move descriptor into a0,
	addi $sp, $sp, -5 # add to stack
	move $a1, $sp # move buffer to a1
	li $a2, 5 # number of words to add

	li $v0, 14
	syscall
	
	blt $v0, $zero, failed
	beqz $v0, loadEnd
	
	lb $s3, 0($sp) # player
	addi $s3, $s3, -0x30
	lb $s4, 1($sp) # peice
	lb $a0, 2($sp) # column char
	lb $a1, 3($sp) # row number
	
	addi $sp, $sp, 5 # add to stack
	
	jal mapChessMove
	
	move $a0, $v0
	sra $a0, $a0, 8
	
	move $a1, $v0
	sll $a1, $a1, 24
	sra $a1, $a1, 24
	
	move $a2, $s4
	move $a3, $s3
	
	li $t0, 0x4
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	jal setSquare
	
	addi $sp, $sp, 4
	
	li $t0, 1
	beq $a3, $t0, counterone
	li $t0, 2
	beq $a3, $t0, countertwo
	
	j loadLoop
	

counterone:
	addi $s1, $s1, 1
	j loadLoop
countertwo:
	addi $s2, $s2, 1
	j loadLoop

failed:
	li $v0, -1
	li $v1, -1
	
	j loadEnd2
	
loadEnd:
	addi $sp, $sp, 5
	move $v0, $s1
	move $v1, $s2
	
	j loadEnd2

loadEnd2:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	lw $s2, 16($sp)
	lw $s3, 20($sp)
	lw $s4, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra

##########################################
#  Part #2 Functions
##########################################

getChessPiece:
	move $t0, $a0
	sra $t0, $t0, 8 # isolating the row
	
	li $t2, 8
	mul $t5, $t0, $t2
	
	move $t1, $a0
	sll $t1, $t1, 24
	sra $t1, $t1, 24 # isolating the column
	
	add $t5, $t5, $t1
	li $t2, 2
	mul $t5, $t5, $t2  # mul by 2 cuz hw
	
	li $t0, 0xFFFF0000 # base addres
	or $t5, $t0, $t5   # or the result
	
	lh $t0, 0($t5)     # loads in the half word containing the colors and data information
	
	move $t1, $t0
	
	sll $t0, $t0, 24
	sra $t0, $t0, 24   # for the word
	
	li $t9, 0x45
	beq $t0, $t9, EmptyP
	
	sra $t1, $t1, 8
	li $t2, 0xF
	and $t2, $t1, $t2
	
	
	li $t3, 0xF
	beq $t2, $t3, white3
	
	li $t2, 0x0
	and $t1, $t1, $t2
	
	li $t3, 0x0
	beq $t1, $t3, blackend
	
	li $v0, 0x45 # replace this line
	li $v1, -1 # replace this line
	jr $ra

EmptyP:
	li $v0, 0x45
	li $v1, -1
	jr $ra
	
white3:
	move $v0, $t0
	li $v1, 1	
	jr $ra

blackend:
	move $v0, $t0
	li $v1, 2
	jr $ra







validBishopMove:
	beq $a0, $a1, moveError # if they're the same
	li $t0, 1
	beq $a2, $t0, startt    # if its 1
	li $t0, 2
	beq $a2, $t0, startt    # if its 2
	
	j moveError
	

startt:
	
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp) # val 1
	sw $a1, 8($sp) # val 2
	sw $a2, 12($sp) # player
	sw $a3, 16($sp)
	sw $s0, 20($sp)
	
	lw $a0, 8($sp)
	jal getChessPiece
	
	beq $v1, $a2, NoVal
	
	lw $t0, 12($sp)
	beq $v1, $t0, moveError
	
	lw, $s0, 4($sp)
	move $t1, $s0
	
loopUpLeft:
	addi $t1, $t1, -0x0101
	
	sll $t2, $t1, 24 # column
	sra $t2, $t2, 24
	blt $t2, $zero, reset1
	
	sra $t2, $t1, 8 # row
	blt $t2, $zero, reset1
	
	lw $t2, 8($sp)
	beq $t1, $t2, match1
	
	j loopUpLeft

reset1:
	move $t1, $s0
	
loopUpRight:
	addi $t1, $t1, -0x0100
	addi $t1, $t1, 0x0001
	
	sll $t2, $t1, 24 # COLUMN
	sra $t2, $t2, 24
	li $t4, 7
	bgt $t2, $t4, reset2
	
	sra $t2, $t1, 8   # ROWS
	blt $t2, $zero, reset2
	
	lw $t2, 8($sp)
	beq $t1, $t2, match2
	
	j loopUpRight

reset2:
	move $t1, $s0

loopDownLeft:
	addi $t1, $t1, -0x0001
	addi $t1, $t1, 0x0100
	
	sll $t2, $t1, 24 # COLUMN
	sra $t2, $t2, 24
	blt $t2, $zero, reset3
	
	sra $t2, $t1, 8   # ROWS
	li $t4, 7
	bgt $t2, $t4, reset3
	
	lw $t2, 8($sp)
	beq $t1, $t2, match3
	
	j loopDownLeft

reset3:
	move $t1, $s0

loopDownRight:
	addi $t1, $t1, 0x0101
	
	sll $t2, $t1, 24
	sra $t2, $t2, 24
	li $t4, 7
	bgt $t2, $t4, NoVal
	
	sra $t2, $t1, 8
	li $t4, 7
	bgt $t2, $t4, NoVal
	
	lw $t2, 8($sp)
	beq $t1, $t2, match4
	
	j loopDownRight

match1:
	addi $s0, $s0, -0x0101
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal
	
	j match1

match2:
	addi $s0, $s0, -0x0100
	addi $s0, $s0, 0x0001
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal
	
	j match2
match3:
	addi $s0, $s0, -0x0001
	addi $s0, $s0, 0x0100
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal
	
	j match3
match4:
	addi $s0, $s0, 0x0101
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal
	
	j match4

tester:
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, claim
	
	li $v0, 0
	li $v1, 0x00
	j done6

claim:
	sh $s0, 0($a3)
	move $v1, $v0
	li $v0, 1
	j done6

NoVal:
	li $v0, -1
	li $v1, 0x00
	j done6
	
moveError:
	li $v0, -2  # replace this line
	li $v1, 0x00
	jr $ra

done6:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $s0, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra




validRookMove:
	beq $a0, $a1, moveError2   # if they're the same
	li $t0, 1
	beq $a2, $t0, startt2   # if its 1
	li $t0, 2
	beq $a2, $t0, startt2    # if its 2
	
	j moveError1

step1:
	li $v0, -1
	li $v1, 0x00
	j done66
	
startt2:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp) # val 1
	sw $a1, 8($sp) # val 2
	sw $a2, 12($sp) # player
	sw $a3, 16($sp)
	sw $s0, 20($sp)
	
	lw $a0, 8($sp)
	jal getChessPiece
	
	beq $v1, $a2, NoVal1
	
	lw $t0, 12($sp)
	beq $v1, $t0, moveError1
	
	lw, $s0, 4($sp)
	move $t1, $s0
	
loopUp:
	addi $t1, $t1, -0x0100
	
	sra $t2, $t1, 8 # row
	blt $t2, $zero, resett1
	
	lw $t2, 8($sp)
	beq $t1, $t2, match11
	
	j loopUp

resett1:
	move $t1, $s0

loopDown:
	addi $t1, $t1, 0x0100
	sra $t2, $t1, 8
	li $t4, 7
	bgt $t2, $t4, resett2
	
	lw $t2, 8($sp)
	beq $t1, $t2, match22
	
	j loopDown

resett2:
	move $t1, $s0

LoopLeft:
	addi $t1, $t1, -0x0001
	
	sll $t2, $t1, 24 # COLUMN
	sra $t2, $t2, 24
	blt $t2, $zero, resett3
	
	lw $t2, 8($sp)
	beq $t1, $t2, match33
	
	j LoopLeft

resett3:
	move $t1, $s0

LoopRight:
	addi $t1, $t1, 0x0001
	
	sll $t2, $t1, 24 # COLUMN
	sra $t2, $t2, 24
	li $t4, 7
	bgt $t2, $t4, NoVal1
	
	lw $t2, 8($sp)
	beq $t1, $t2, match44
	
	j LoopRight
match11:
	addi $s0, $s0, -0x0100
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester1
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal1
	
	j match11

match22:
	addi $s0, $s0, 0x0100
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester1
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal1
	
	j match22
match33:
	addi $s0, $s0, -0x0001
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester1
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal1
	
	j match33
match44:
	addi $s0, $s0, 0x0001
	
	lw $t1, 8($sp)
	beq $t1, $s0, tester1
	
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, NoVal1
	
	j match44

tester1:
	move $a0, $s0
	jal getChessPiece
	
	li $t3, 0x45
	bne $v0, $t3, claim1
	
	li $v0, 0
	li $v1, 0x00
	j done66

claim1:
	sh $s0, 0($a3)
	move $v1, $v0
	li $v0, 1
	j done66

NoVal1:
	li $v0, -1
	li $v1, 0x00
	j done66

moveError1:
	li $v0, -2  # replace this line
	li $v1, 0x00
	jr $ra
	
moveError2:
	li $v0, -1
	li $v1, 0x00
	jr $ra


done66:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	lw $s0, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra	

perform_move:
	lw $t0, 0($sp)
	
	addi $sp, $sp, -28
	sw $ra, 0($sp)		# return addres
	sw $a0, 4($sp)		# player number
	sw $a1, 8($sp)		# from
	sw $a2, 12($sp)		# to
	sw $a3, 16($sp)		# byte fg
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	
	move $s1, $t0
	
	sll $t0, $a1, 24	#column
	sra $t0, $t0, 24
	blt $t0, $zero, inputError
	li $t1, 7
	bgt $t0, $t1, inputError
	
	sra $t0, $a1, 8		# row
	blt $t0, $zero, inputError
	li $t1, 7
	bgt $t0, $t1, inputError
	
	move $a0, $a1
	
	jal getChessPiece	# returns $v0 (piece) $v1 (player)
	
	addi $sp, $sp, -4
	move $a3, $sp 
	
	li $t0, 0x45
	beq $v0, $t0, invalidError
	lw $a0, 8($sp)
	bne $v1, $a0, inputError
	
	lw $a0, 12($sp) 		# from
	lw $a1, 16($sp) 	# to
	lw $a2, 8($sp) 		# player num
	
	move $s0, $v0
	
	li $t0, 0x42
	beq $v0, $t0, bishMove
	li $t0, 0x48
	beq $v0, $t0, HorseMove
	li $t0, 0x4B
	beq $v0, $t0, KingMove
	li $t0, 0x50
	beq $v0, $t0, PawnMove
	li $t0, 0x70
	beq $v0, $t0, PawnMove2
	li $t0, 0x51
	beq $v0, $t0, QueenMove
	li $t0, 0x52
	beq $v0, $t0, CastMove
	
CastMove:
	jal validRookMove
	j decode
	
QueenMove:
	jal validQueenMove
	j decode
	
PawnMove:
	
	jal validPawnMove
	j decode
PawnMove2:
	addi $s0, $s0, -0x20
	jal validPawnMove
	j decode
	
KingMove:
	jal validKingMove
	sw $a1, 0($s1)
	j decode
	
HorseMove:
	jal validKnightMove
	j decode
	
bishMove:
	jal validBishopMove
	j decode


decode:
	li $t0, 1
	beq $v0, $t0, decodes
	li $t0, 0
	beq $v0, $t0, decodes0
	
	j donemove
decodes: # row col char player fg
	lw $t0, 12($sp) # from
	sra $a0, $t0, 8	# row
	sll $a1, $t0, 24# column
	sra $a1, $a1, 24
	li $a2, 0x45   	# char or E
	lw $a3, 8($sp)  # player
	lw $t0, 20($sp) # contains fg
	addi $sp, $sp, -4 # add room to stack
	sw $t0, 0($sp)	# saving it onto stack

	jal setSquare # function call
	
	addi $sp, $sp, 4 # adding back to the stack
	
	
	lw $t0, 16($sp) # from
	sra $a0, $t0, 8	# row
	sll $a1, $t0, 24# column
	sra $a1, $a1, 24
	move $a2, $s0 	# char or E
	lw $a3, 8($sp)  # player
	lw $t0, 20($sp) # contains fg
	addi $sp, $sp, -4 # add room to stack
	sw $t0, 0($sp)	# saving it onto stack

	jal setSquare # function call
	
	addi $sp, $sp, 4 # adding back to the stack
	
	
	li $v0, 1
	
	j donemove

decodes0: # row col char player fg
	lw $t0, 12($sp) # from
	sra $a0, $t0, 8	# row
	sll $a1, $t0, 24# column
	sra $a1, $a1, 24
	li $a2, 0x45   	# char or E
	lw $a3, 8($sp)  # player
	lw $t0, 20($sp) # contains fg
	addi $sp, $sp, -4 # add room to stack
	sw $t0, 0($sp)	# saving it onto stack

	jal setSquare # function call
	
	addi $sp, $sp, 4 # adding back to the stack
	
	
	lw $t0, 16($sp) # from
	sra $a0, $t0, 8	# row
	sll $a1, $t0, 24# column
	sra $a1, $a1, 24
	move $a2, $s0 	# char or E
	lw $a3, 8($sp)  # player
	lw $t0, 20($sp) # contains fg
	addi $sp, $sp, -4 # add room to stack
	sw $t0, 0($sp)	# saving it onto stack

	jal setSquare # function call
	
	addi $sp, $sp, 4 # adding back to the stack
	
	
	li $v0, 0
	
	j donemove
	
	
invalidError:
	li $v0, -2
	li $v1, 0x00
	j donemove
	
inputError:
	li $v0, -2
	li $v1, 0x00
	j donemove

donemove:
	addi $sp, $sp, 4
	lw $ra, 0($sp)		# return addres
	lw $a0, 4($sp)		# player number
	lw $a1, 8($sp)		# from
	lw $a2, 12($sp)		# to
	lw $a3, 16($sp)	
	lw $s0, 20($sp)	    
	lw $s1, 24($sp)   # byte fg
	addi $sp, $sp, 28
	
	jr $ra

##########################################
#  Part #3 Function
##########################################


check:
	li $t0, 1
	beq $t0, $a0, startcheck
	li $t0, 2
	beq $t0, $a0, startcheck
	
	j failedinputs
	
startcheck:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	
	lw $a0, 8($sp)
	
	jal getChessPiece
	
	li $t0, 0x4B
	bne $v0, $t0, failedinputs2
	
	lw $t0, 4($sp)
	beq $v1, $t0, failedinputs2
	
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	
	addi $sp, $sp, -4
	move $a3, $sp
	
	li $s2, 0x0000

checkloop:
	move $a0, $s2
	jal getChessPiece
	
	li $t0, 0x45		# check if cahr is empty
	beq $v0, $t0, stepone
	
	lw $t0, 8($sp)		# check if it's the same piece as the player
	bne $v1, $t0, stepone
	
	li $t0, 0x42
	beq $t0, $v0, bishopcheck
	
	li $t0, 0x48
	beq $t0, $v0, knightcheck
	
	li $t0, 0x4B
	beq $t0, $v0, kingcheck
	
	li $t0, 0x50
	beq $t0, $v0, pawncheck1
	
	li $t0, 0x51
	beq $t0, $v0, queencheck
	
	li $t0, 0x52
	beq $t0, $v0, rookcheck
	
	li $t0, 0x70
	beq $t0, $v0, pawncheck2
	
	j stepone

bishopcheck:
	jal validBishopMove
	
	li $t0, 1
	beq $v0, $t0, winner

	j stepone

knightcheck:
	jal validKnightMove
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone

kingcheck:
	jal validKingMove
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone

pawncheck1:
	li $t0, 0x50
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal validPawnMove
	addi $sp, $sp, 4
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone
queencheck:
	jal validQueenMove
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone

rookcheck:
	jal validRookMove
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone

pawncheck2:
	li $t0, 0x70
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal validPawnMove
	addi $sp, $sp, 4
	
	li $t0, 1
	beq $v0, $t0, winner
	
	j stepone
	
stepone:
	sll $t0, $s2, 24
	sra $t0, $t0, 24
	
	li $t1, 0x07
	bgt $t0, $t1, steptwo
	
	addi $s2, $s2, 0x0001
	
	j checkloop

steptwo:
	sra $t0, $s2, 8
	
	li $t1, 0x07
	bgt $t0, $t1, checkover
	
	addi $s2, $s2, -0x0007
	addi $s2, $s2, 0x0100
	
	j checkloop


checkover:
	addi $sp, $sp, 4
	li $v0, -1
	li $v1, 0x00
	
	j checkdone
	
checkover2:
	addi $sp, $sp, 4
	
	j checkdone
	

failedinputs:
	li $v0, -2
	li $v1, 0x00
	
	jr $ra

failedinputs2:
	li $v0, -2
	li $v1, 0x00
	
	j checkdone
winner:
	addi $sp, $sp, 4
	li $v0, 0
	
	j checkdone

checkdone:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra


	
