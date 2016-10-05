#Daniel Minor
#Computer Organization: Assembly 2
#9-25-2016



#values to multiply
.data
valueOne: .word 4
valueTwo: .word 20
Answer: .word 0
times: .asciiz " times "
equals: .asciiz " equals "


.text 

#program
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
main:

lw $a0, valueOne 	#Storing value into argument register
lw $a1, valueTwo 	#Storing value into argument register

jal multiply 		#calls multiply function with the arguments being the values in the argument registers

sw $v0, Answer 		#Stores the value in $v0 into answer (hopefully is 80, or hex-0..50)

#printing answer 
addi $v0, $zero, 1 	#A value of 1 in $v0 tells syscall when called that it should print an int
lw $a0, valueOne 	#copies the value of valueOne into the argument register to be passed into the syscall function
syscall 		#syscall function call

addi $v0, $zero, 4 	#A value of 4 in $v0 tells syscall when called that it should print a string
la $a0, times 		#copies the value of times into the argument register to be passed into the syscall function
syscall 		#syscall function call

addi $v0, $zero, 1 	#A value of 1 in $v0 tells syscall when called that it should print an int
lw $a0, valueTwo 	#copies the value of valueTwo into the argument register to be passed into the syscall function
syscall 		#syscall function call

addi $v0, $zero, 4 	#A value of 4 in $v0 tells syscall when called that it should print a string
la $a0, equals 		#copies the value of valueOne into the argument register to be passed into the syscall function
syscall 		#syscall function call

addi $v0, $zero, 1 	#A value of 1 in $v0 tells syscall when called that it should print an int
lw $a0, Answer	 	#copies the value of valueTwo into the argument register to be passed into the syscall function
syscall 		#syscall function call



li $v0, 10		#Syscall code 10 is for exit 
syscall			#make the syscall

#--------------------------------------------------------------------------------------------------



#multiply function
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
multiply:
addi $sp, $sp, -16 	#bump the stack pointer down 12, because we're dealing with 4 registers(4: $s0, $s2, $s3, $sp), (4 registers used)*(4 bits used per register)
sw $s0, 0($sp) 		#creating save temporary registers
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)


#copy arguments from argument registers into save temporary registers
addi $s0, $a0, 0
addi $s1, $a1, 0
addi $s2, $zero, 0


#multiplication loop, terminates when 4 is equal to zero
TopofLoop:
beq $s0, $zero, EndofLoop 	#break on equal, checking to see if register $s0 is equal to zero
addi $s0, $s0, -1 		#decrements valueOne by 1
add $s2, $s2, $s1		#adds valueTwo to Answer
j TopofLoop 			#jumps to the top of the loop
EndofLoop:

addi $v0, $s2, 0		#puts (hopefully 80) into $v0

#Restores values from the stack/cleans up the mess
lw $s0, 0($sp) 		
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16 		#bump the stack pointer up 16, because we're dealing with 4 registers (4 registers used)*(4 bits used per register)=16
jr $ra

