.data
	
	memoria: .space 12
	
.text

	main:
	
		#pedindo quantidade de elementos
		li $v0, 5
		syscall
		
		move $a0, $v0
		li $v0, 1
		syscall
		
		sw $a0, 0(memoria) #adiciona a quantidade de elementos na memoria
	
