.data
	
	getQuantidade: .asciiz "Informe a quantidade de elementos: "
	
	#funcoes de menu
	menuAddElemento: .asciiz "\n\n1 - Adicionar elemento\n"
	menuRecElemento: .asciiz "2 - Recuperar elemento\n"
	menuImpLista: .asciiz "3 - Imprimir lista\n"
	menuDelElemento: .asciiz "4 - Deletar elemento\n"
	menuSair: .asciiz "5 - Sair\n"
	
	#pedir informacao
	informarValor: .asciiz "valor: "
	
	#Resposta ao usuario
	informaEscolha: .asciiz "Voce escolheu o valor de numero: "
	informaSaida: .asciiz "\nVoce saiu do programa!\n"
	msgError: .asciiz "\nO valor informado e invalido\n\n"
	msgMaxError: .asciiz "\nNumero maximo de elementos atingido!\n"
	adicionou: .asciiz "\nVoce adicionou a lista o valor: "
	informarElemento: .asciiz "\nElemento: "
	informarIndice: .asciiz "\nIndice: "
	msgImpLista: .asciiz "\n====== Elementos da Lista ======\n"
	msgRecuperou: .asciiz "\nVoce recuperou o elemento: "
	#padroes
	breakLine: .asciiz "\n"	
	separator: .asciiz " - "
	
	memoria: .word 8
	
	
	
.text

	# Configuracoes:
	# s1 -> usado para pegar um valor qualquer para comparacao ou recuperacao de dados
	# s2 -> usado para pegar um segundo valor qualquer para comparacao ou recuperacao de dados
	
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
		jal inputInt
		
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
			
			beq $s1, $t1, lblAddElemento
			beq $s1, $t2, lblRecElemento
			beq $s1, $t3, lblImpLista
			beq $s1, $t4, lblDelElemento
			beq $s1, $t5, saida
			
			j valorInvalido
	
	end:
		li $v0, 10
		syscall
		
	
	# funcoes do menu
	
	lblAddElemento:
		jal addElemento
		j menu
		
	lblRecElemento:
		jal recElemento
		j menu
	lblImpLista:
		jal impLista
		j menu
	lblDelElemento:
		jal delElemento
		j menu
		
	
	# adiciona um novo elemento
	addElemento:
	
		# verifica se a quantidade atual e menor que a quantidade total
		verificaQuantidade:
		
			li $s0, 0
			lw $s1, memoria($s0)
			addi $s0, $s0, 4
			lw $s2, memoria($s0)
		
			beq $s1, $s2, maximoAtingido
	
		la $a0, informarElemento
		li $v0, 4
		syscall
		
		# pega o valor atual da memoria e adiciona ao atual da pilha
		li $s0, 4
		lw $s1, memoria($s0)
		li $s4, 0
		mul $s4, $s1, -4
		
		move $sp, $s4
		
		#primeiramente - pega o valor atual, multiplica por -4 e inicializa em sp
		
		subu $sp, $sp, 4
		
		li $v0, 5
		syscall
		move $s1, $v0
		
		sw $s1, ($sp)
		
		la $a0, adicionou
		li $v0, 4
		syscall
		
		move $a0, $s1
		li $v0, 1
		syscall
		
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
		
		jr $ra
		
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
		
		li $s3, 1
		#imprime o aviso
		la $a0, msgImpLista
		li $v0, 4
		syscall
		
		for:
			bgt $s3, $s1, endFor
			
			#imprime o indice
			move $a0, $s3
			li $v0, 1
			syscall
			
			la $a0, separator
			li $v0, 4
			syscall
			
			# pega o elemento da lista
			lw $t6, ($sp)
			# imprime o elemento
			move $a0, $t6
			li $v0, 1
			syscall
			
			la $a0, breakLine
			li $v0, 4
			syscall
			
			subu $sp, $sp, 4 #subtrai ate o valor atual
			addi $s3, $s3, 1
			
			j for
			
		endFor:
			jr $ra
			
	# recupera um elemento
	recElemento:
		# reinicia a pilha em 0
		li $sp, 0
		# pede o indice
		la $a0, informarIndice
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		move $s1, $v0
		
		#pegar valor atual
		li $s0, 4
		lw $s2, memoria($s0)
		#verifica se o indice informado esta entre 1 e o valor atual
		bgt $s1, $s2, valorInvalido
		blez $s1, valorInvalido
		
		# vai ate o numero de bytes
		mul $s1, $s1, -4
		# adiciona a posicao da pilha
		addu $sp, $sp, $s1
		# pega o valor da pilha
		lw $a1, ($sp)
		
		#imprime que recuperou
		la $a0, msgRecuperou
		li $v0, 4
		syscall
		# imprime o valor pego
		move $a0, $a1
		li $v0, 1
		syscall
		
		jr $ra
		
	# deleta um elemento
	delElemento:
		
		#pega o indice
		la $a0, informarIndice
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		move $s1, $v0
		
		#pegar valor atual
		li $s0, 4
		lw $s2, memoria($s0)
		#verifica se o indice informado esta entre 1 e o valor atual
		bgt $s1, $s2, valorInvalido
		blez $s1, valorInvalido
		
		rescrever:
			mul $sp, $s1, -4
			move $k0, $s1 # valor atual
			addi $s5, $k0, 1 # proximo
			move $k1, $s2
			fore:
				bgt $k0, $k1, endFore
				
				# pega o proximo elemento
				mul $sp, $s5, -4
				lw $s4, ($sp)
				
				# adiciona no elemento atual
				mul $sp, $k0, -4
				sw $s4, ($sp)
				
				addi $k0, $k0, 1
				addi $s5, $s5, 1
				
				j fore
				
				
				
			endFore:
				
				# decrementa a quantidade atual de elementos
				decrementaAtual:
					li $s0, 4
					lw $s1, memoria($s0)
					subi $s1, $s1, 1
					sw $s1, memoria($s0)
					
				jr $ra
				
				
		
		
		
	# sai do programa
	saida:
	
		la $a0, informaSaida
		jal printString
		j end
		
		
	# funcoes de erros
	
	# informa erro
	valorInvalido:
		la $a0, msgError
		jal printString
		
		j menu
		
	maximoAtingido:
		la $a0, msgMaxError
		jal printString
		
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
