#Daniel Minor
#Assignment 1: multiplication by addition

.data					#declating variables

x:	.word 4 
y:	.word 20
z:	.word 0


.text					#program

main: 
lw $2, x				#delcaring registers
lw $3, y				#delcaring registers
lw $4, z				#delcaring registers, z= sum

TopofLoop:
beq $2, $0, EndofLoop 			#break on equal, checking to see if register 2 is equal to zero,
addi $2, $2, -1 			#decrements x variable by 1
add $4, $4, $3				#adds y to z
j TopofLoop 				#jumps to the top of the loop

EndofLoop:				#loop ends when 4 is equal to zero.
nop 					#error out of program
nop
