# Daniel Minor
# Principles of Computer Organization 
# Assignment 5: Find the Length of a String
# 11/17/2016
# C code for Problem
# int strlen( char *string) {
# int length = 0;
# while( *(string + length) != NULL) 
# {
#    length++;
# }
#  return(length);
#}

#+++++++++++++++Beginning of Data Section +++++++++++++
.data
	String1: .asciiz "Daniel" 	# String to be used to find the length of.
	String2: .asciiz "Minor"	
	Answer: .word 0 			# Should contain the length of string1 after StrLen is called.
	Answer2: .word 0			# Should contain the length of string2 after StrLen is called.
	times: .asciiz " , "		
#-------------- End of Data Section --------------------

.text	

#++++++ Beginning of Main Program +++++++++++++++++++
Main:
	addi  $sp, $sp, -4  	# need to make main into a function by bumping stack pointer down
	sw    $ra, 0($sp)
	
	la $a0, String1			# loads the address of the first byte of string1 into register $a0 to be passed into the StrLen function	
	jal StrLen				# Call StrLen Function
	sw $v0, Answer 			# Must store value in $v0 as the value for Answer
	
	addi $v0, $zero, 1 		# A value of 1 in $v0 tells syscall when called that it should print an int
	lw $a0, Answer 			# copies the value of Answer into the argument register to be passed into the syscall function
	syscall 				# syscall function call to print integer 
	
	addi $v0, $zero, 4 		# A value of 4 in $v0 tells syscall when called that it should print a string
	la $a0, times 			# copies the value of times into the argument register to be passed into the syscall function
	syscall 				# syscall function call
	
	la $a0, String2			# loads the address of the first byte of string2 into register $a0 to be passed into the StrLen function	
	jal StrLen				# Call StrLen Function
	sw $v0, Answer2 		# Must Store value in $v0 as the value for Answer2 
	
	addi $v0, $zero, 1 		# A value of 1 in $v0 tells syscall when called that it should print an int
	lw $a0, Answer2 		# copies the value of Answer2 into the argument register to be passed into the syscall function
	syscall 				# syscall function call to print integer 
	
	lw $ra, 0($sp)			# cleaning up/restoring main function	
	addi $sp, $sp, 4		# Bumping the stack pointer back up.
  
	li $v0, 10				# Syscall code 10 is for exit 
	syscall					# make the syscall
#--------------- End of Main ---------------------------




# +++++ Beginning of Function Defintions +++++++++++++++
StrLen:
	addi $sp, $sp, -12 		# bump the stack pointer down 12 (3 registers used)*(4 bits used per register)
	sw $s0, 0($sp) 			# creating save temporary registers
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	add $s0, $a0, $zero 	# adds address of first byte of array from argument register into a save register
	li $t0, 0 				# initialize the count to zero
	
	loop:
		lb $t1, 0($s0) 		# load the next character into t1
		beqz $t1, exit 		# check for the null character
		addi $s0, $s0, 1 	# increment the string pointer
		addi $t0, $t0, 1 	# increment the count
		j loop 				# return to the top of the loop

exit:
	add $v0, $t0, $zero		# Stores the length of the string from $t0 into return register $v0 
	lw $s0, 0($sp) 			# Restores values from the stack/cleans up the mess
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 		# bump the stack pointer up 12, because we're dealing with 3 registers (3 registers used)*(4 bits used per register)=16
	jr $ra
# -------- End of Function Defintions -------------------