.data
	#espaco inicial
	size: .space 4
	bk: .asciiz "\n"
	
.text
	
	#considera o espaco ali em cima e ver a quantidade de elementos adicionados
	li $s0, 12
	
	addi $t2, $t2, 0
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	addi $t2, $t2, 4
	addi $s0, $s0, 1
	sw $s0, size($t2)
	
	
	li $s2, 0
	li $s3, 32
	
	while: 
		beq $s2, $s3, end
		
		lw $s4, size($s2)
		
		move $a0, $s4
		li $v0, 1
		syscall
		
		la $a0, bk
		li $v0, 4
		syscall
		
		addi $s2, $s2, 4
		
		j while
		
		
	end:
		li $v0, 10
		syscall
	
	
