#-------------------------------------------------------------------------------------------
#  Programmer: Andrew Craze accraze@gmail.com
#  Description: This program reads in an integer and runs it through a recursive method.
#				If input n<=2, return 4, else  = 2*function1(n-2) + 5*function1(n-3) + 2
#-------------------------------------------------------------------------------------------

#data declarations: declare variable names used in program, storage allocated in RAM
					 .data
message1:			 .asciiz "\nEnter an integer:\n"
message2:			 .asciiz "The solution is: "
message3:			 .asciiz "\n--------------------------------------------------\n"

					 

.text
.globl main

#the program begins execution at main()
main:
li $s0, 0			# $s0 = int ans = 0
li $t0, 0			# $t0 = 0

la $a0, message1 	# $a0 = address of message1
	li $v0, 4       	# $v0 = 4  --- this is to call print_string()
        syscall         	# call print_string()
li	$v0, 5			# $v0 = 5 --- this is to call read_int()
syscall 
move $a0, $v0		# $a0 = user input or "int n"

addi $sp, $sp, -4	# move the stack pointer down
sw $ra, 0 ($sp)		# save the return address for main

jal function1		# call function1(n);

lw $ra, 0 ($sp)		# copy the return address for main back
addi $sp, $sp, 4	# move the stack pointer up

move $s0, $v0		# st0 = ans = function1(n);

la $a0, message2 	# $a0 = address of message2
	li $v0, 4       	# $v0 = 4  --- this is to call print_string()
        syscall         	# call print_string()
		
move $a0, $s0		# set up to print "sum"
li $v0, 1			# $v0 = 1 --- this is to call print_int()
	syscall			# call print_int()
	
	
la $a0, message3 	# $a0 = address of message3
	li $v0, 4       	# $v0 = 4  --- this is to call print_string()
        syscall         	# call print_string()


jr $ra



############################################################################
# Procedure function1 (int n)
# Description: -----
# parameters: $a0x = int n,
# return value: $v0 = comp
# registers to be used: $s3 and $s4 will be used.
############################################################################

function1:
bgt $a0, 2, recurse		# if (n <= 2) else-> recurse
li $t0, 0				# initialize $t0 = 0
addi $t0, $t0, 4		# $t0 = 4
move $v0, $t0			# return 4
jr $ra

recurse:

#int comp = 2*function1(n-2) + 5*function1(n-3) + 2;

sub $sp, $sp, 12	# store 3 registers
sw $ra, 0($sp)		# $ra is the first register
sw $a0, 4($sp)		# $a0 is the second register


addi $a0, $a0, -2	# $a0 = n - 2
jal function1
sw $v0, 8($sp)		# store $v0, the 3rd register to be stored


lw $a0, 4($sp)		# retrieve original value of n
addi $a0, $a0, -3	# n - 3
jal function1


mul $v0, $v0, 5		# $v0= 5 * function1(n-3)
addi $v0, $v0, 2
lw $t0, 8($sp)		# retrieve first function result (function1 (n-2))
mul $t0, $t0, 2		# $t0 = 2 * function1(n-2)
add $v0, $v0, $t0
lw $ra, 0($sp)		# retrieve return address
addi $sp, $sp, 12
jr $ra
