#Daniel Minor
#10/14/16
#Principle of Computer Organization
#Assembly Assignment 3F: ibonacci

#int fibonacci( int whichOne)
#{
#  if( whichOne < 1) return( 0);
#  if( whichOne < 3) return( 1);
#  return( fibonacci( whichOne - 1) + fibonacci( whichOne - 2));
#}

#++++++++++++++++++++++++++++++++++++++++++++++++
.data
Answer: .word 0
equals: .asciiz " "
#------------------------------------------------

.text



#Program
#+++++++++++++++++++++++++++++++++++++++++++++++
main:
	#need to make main into a function by moving things to the stack
	addi  $sp, $sp,   -4  
	sw    $ra, 0($sp)
	
	addi $s2, $zero, 10 		#puts 9 into a register to be used as a stopping condition
	addi $s3, $zero, 0		#loading the value for the number of fibonacci numbers to be printed.
	
	TopofLoop:
	add $a0, $s3, $zero 		#puts whatever is in $s3 into the argument register
	beq $a0, $s2, EndofLoop	 
	jal fibonacci 			#calls fibonacci function with the arguments being the values in the argument registers
	sw $v0, Answer 			#Must Store the answer into $v0
	
	addi $v0, $zero, 1 		#A value of 1 in $v0 tells syscall when called that it should print an int
	lw $a0, Answer 			#copies the value of Answer into the argument register to be passed into the syscall function
	syscall 			#syscall function call
	
	addi $v0, $zero, 4 		#A value of 4 in $v0 tells syscall when called that it should print a string
	la $a0, equals 			#copies the value of valueOne into the argument register to be passed into the syscall function
	syscall 			#syscall function call
	
	addi $s3, $s3, 1		#increments the number of fiboncacci to be returned by 1
	j TopofLoop
	EndofLoop:
 
		
	lw $ra, 0($sp)			#cleaning up/restoring main function	
	addi $sp, $sp, 4
  
	li $v0, 10			#Syscall code 10 is for exit 
	syscall				#make the syscall		
#-----------------------------------------------------------------------------------------------------
 	
 	

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#function Definitions:
fibonacci:
	addi $sp, $sp, -12 		#bump the stack pointer down xy, because we're dealing with x registers(4: $s0, $s2, $s3, $sp), (4 registers used)*(4 bits used per register)
	sw $s0, 0($sp) 			#creating save temporary registers
	sw $s1, 4($sp)
	sw $ra, 8($sp)

	add $s0, $a0, $zero 		#adds value from argument register into a save register


	beq $s0,$zero, basecase   	#if n=0 return 0
	addi $t0, $zero, 1
	
	beq $s0,$t0, basecase1   	#if n=1 return 1

	addi $s0, $s0, -1		#return (fibonacci( whichOne - 1) + fibonacci( whichOne - 2))
	add $a0, $s0, $zero
	jal fibonacci
	add $s1, $zero, $v0

	addi $s0, $s0, -1
	add $a0, $s0, $zero
	jal fibonacci
	add $v0, $v0, $s1
	j return
 
		basecase:                # In our basecase, just return 0 (put 0 into $v0)
  
		add   $v0, $zero, $zero
		j return

		basecase1:                # In our basecase, just return 1 (put 0 into $v0)
  
		addi  $v0, $zero, 1
		j return




#Restores values from the stack/cleans up the mess
return: 
lw $s0, 0($sp) 		
lw $s1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12	#bump the stack pointer up 16, because we're dealing with 4 registers (4 registers used)*(4 bits used per register)=16
jr $ra

#------------------------------------------------

