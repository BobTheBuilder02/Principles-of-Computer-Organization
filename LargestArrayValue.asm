#Daniel Minor
#10/28/16
#Principle of Computer Organization
#Assembly Assignment 3: Largest value in an array

#int largest( int* array, int arrayLength) 
#{
#    	int largest = array[0];
#    	int index = 1;
#    	while( index < arrayLength) 
#	{
#       	if(array[index] > largest) 
#		{
#           		largest = array[index];
#        	}
#        index++;
#    	}
#   return( largest);
#}


.data
    array:    	.word 5,  6,  23,  -7,  18, 201
    number:   	.word 6
    Answer:	.word 0
.text


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  main:
	addi  $sp, $sp, -4		# need to make main into a function by moving things to the stack  
	sw    $ra, 0($sp)

	la    $a0, array            	# base address of the array, put into argument register to be passed into "Largest" function 
    	lw    $a1, number           	# length of the array, put into argument register to be passed into "Largest" function 

	jal Largest 			# calls "Largest" function with the arguments being the values in the argument registers
	sw $v0, Answer 			# Must Store the answer into $v0

	addi $v0, $zero, 1 		# A value of 1 in $v0 tells syscall when called that it should print an int
	lw $a0, Answer 			# copies the value of Answer into the argument register to be passed into the syscall function
	syscall 			# syscall function call

	lw $ra, 0($sp)			# cleaning up/restoring main function	
	addi $sp, $sp, 4
	li $v0, 10			# Syscall code 10 is for exit 
	syscall				# make the syscall		
#-----------------------------------------------------------------------------------------------------




#Function Definition
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Largest: 				#Function "Largest" finds the largest value in an array.
	addi $sp, $sp, -16 		# bump the stack pointer down 16, because we're dealing with 4 registers(3: $sp, $s0, $s1, $s2), (4 registers used)*(4 bits used per register)
	sw $s0, 0($sp) 			# creating save temporary registers
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	sw $s2, 12($sp)

	add $s0, $a0, $zero 		# adds value from argument register into a save register
	add $s1, $a1, $zero		# adds length of array into $s1
   	addi $t2, $zero, 0         	# counter
    	addi $s2, $zero, 0 		# smallest possible value in array, initialize to smallest 32 bit number: (2^31)-1 = -2147483647
  
	loop:
    	beq $s1, $t2, end		# when the counter hits the length, exit the loop
    	sll $t3, $t2, 2        		# multiply counter by 4
    	add $t4, $s0, $t3      		# add it to the base address
    	lw  $t5, 0($t4)         	# grab the value from the array
    	slt $t6, $s0, $t5		# if ($s0 < $t5)
	bne $t6, $zero, Replace		# when the value in $t6 is NOT a zero put the value from t5(array value) into s0(largest value in array variable)
	tag:				# Tag for "Replace" to jump back to.
    	addi  $t2, $t2, 1        	# increment the counter
    	j loop				#jump to top of loop

Replace: 
	add $s0, $t5, $zero
	j tag
  
end: 					# Restores values from the stack/cleans up the mess
	add $v0, $s0, $zero 		# Stores the largest value found in the array into $v0
	lw $s0, 0($sp) 		
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16		# Bump the stack pointer up 16, because we're dealing with 4 registers (4 registers used)*(4 bits used per register)=16
	jr $ra
#-----------------------------------------------------------------------------------------------------
