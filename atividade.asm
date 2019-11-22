.data
	
	getQuantidade: .asciiz "Informe a quantidade de elementos: "
	
	#funcoes de menu
	menuAddElemento: .asciiz "\n1 - Adicionar elemento\n"
	menuRecElemento: .asciiz "2 - Recuperar elemento\n"
	menuImpLista: .asciiz "3 - Imprimir lista\n"
	menuDelElemento: .asciiz "4 - Deletar elemento\n"
	menuSair: .asciiz "5 - Sair\n"
	
	#pedir informacao
	informarValor: .asciiz "valor: "
	
	#Resposta ao usuario
	informaEscolha: .asciiz "Voce escolheu o valor de numero: "
	informaSaida: .asciiz "\nVoce saiu do programa\n"
	msgError: .asciiz "\nO valor informado e invalido\n\n"
	adicionou: .asciiz "\nVoce adicionou a lista o valor: "
	
	memoria: .word 12
	
	#padroes
	breakLine: .asciiz "\n"
	
.text

	# Configuracoes:
	# s1 -> usado para pegar um valor qualquer para comparacao
	
	# inicializa a pilha em 0
	li $sp, 0

	#posicao da memoria
	li $s0, 0
	
	#valor recebido do menu
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5

	main:
	
		la $a0, getQuantidade
		jal printString
	
		#pedindo quantidade de elementos
		li $v0, 5
		syscall
		
		sw $v0, memoria($s0) #adiciona a quantidade de elementos na memoria
		
		addi $s0, $s0, 4
		li $s1, 0
		sw $s1, memoria($s0) # adiciona a quantidade de elementos atual ( 0 )
		
		#lw $a0, memoria($s0) # pega a quantidade de elementos da memoria
		#jal printInteger
		
		
		
		menu:
			#la $a0, breakLine
			#jal printString
			
			# informa o menu
			la $a0, menuAddElemento
			jal printString
			la $a0, menuRecElemento
			jal printString
			la $a0, menuImpLista
			jal printString
			la $a0, menuDelElemento
			jal printString
			la $a0, menuSair
			jal printString
			
			# pede o valor
			la $a0, informarValor
			jal printString
			jal inputInt
			
			move $s1, $v0
			
			beq $s1, $t1, addElemento
			beq $s1, $t2, recElemento
			beq $s1, $t3, impLista
			#beq $s1, $t4, delElemento
			beq $s1, $t5, saida
			
			j valorInvalido
	
	end:
		li $v0, 10
		syscall
		
	
	# funcoes do menu
	
	# adiciona um novo elemento
	addElemento:
		
		# pega o valor atual da memoria e adiciona ao atual da pilha
		li $s0, 4
		lw $s1, memoria($s0)
		li $s4, 0
		mul $s4, $s1, -4
		
		move $sp, $s4
		
		#primeiramente - pega o valor atual, multiplica por -4 e inicializa em sp
		
		subu $sp, $sp, 4
		
		jal inputInt
		move $s1, $v0
		
		sw $s1, ($sp)
		
		la $a0, adicionou
		jal printString
		move $a0, $s1
		jal printInteger
		
		j incrementaAtual
		
	# imprime a lista
	impLista:
		# reinicia a pilha em quantia atual
		
		li $s0, 4
		lw $s1, memoria($s0)
		
		#li $s4, 0
		#mul $s4, $s1, -4
		#move $sp, $s4
		
		# inicializa para o primeiro valor
		li $sp, -4
		
		li $s3, 0
		
		for:
			beq $s3, $s1, endFor
			
			lw $t6, ($sp)
			
			move $a0, $t6
			jal printInteger
			
			la $a0, breakLine
			li $v0, 4
			syscall
			
			subu $sp, $sp, 4 #subtrai ate o valor atual
			addi $s3, $s3, 1
			
			j for
			
		endFor:
			j menu
			
	recElemento:
	
		li $sp, 0
		
		jal inputInt
		move $s1, $v0
		
		mul $s1, $s1, -4
		
		addu $sp, $sp, $s1
		lw $t1, ($sp)
		
		move $a0, $t1
		jal printInteger
		
		j menu
		
		
		
	# sai do programa
	saida:
		la $a0, breakLine
		jal printString
	
		la $a0, informaSaida
		jal printString
		j end
		
	# informa erro
	valorInvalido:
		la $a0, msgError
		jal printString
		
		j menu
		
	# incrementa a quantidade atual de elementos
	incrementaAtual:
		#pega posicao do valor atual
		li $s0, 4
		# pega o valor atual
		lw $s1, memoria($s0)
		# incrementa
		addi $s1, $s1, 1
		# retorna o valor atual
		sw $s1, memoria($s0)
	
		j menu
	
	# funcoes privadas
	
	printString:
		li $v0, 4
		syscall
		jr $ra
	
	printInteger:
		li $v0, 1
		syscall
		jr $ra
		
	inputInt:
		li $v0, 5
		syscall
		
		jr $ra
