# t0 czy liczba czy operator
# t1 operator
# t2 pusty stos  = 0
# t4 do push
# t5 z pop
# t6 sk³adnik operacji ostatni
# t7 sk³adnik operacji
# s0 ra
# s4 adres pocz¹tku stosu

.data 
	podaj1: .asciiz "\nCzy chcesz wprowadzic liczbe (0), czy operacje (1)?   "
	podaj2: .asciiz "\nPodaj typ wykonywanej operacji  (0 d, 1 od, 2 m, 3 dz, 4 swap)   "
	podaj3: .asciiz "\nPodaj liczbe   "
	stan: .asciiz "\nStan stosu: "
	wynik: .asciiz "\nWynik: "
	err: .asciiz "\nError brak liczb lub dzielenie zerem "
.text
	main:
		addi $t4 $zero 47 # zabezpieczenie dotarcia do pocz¹tku stosu
		jal push
		nop 
		move $s4 $sp # adres pocz¹tku stosu
	petla:			
		li $v0, 4
		la $a0, stan
		syscall
		
		move $s6 $sp 	# adres koñca stosu przed wyœwietleniem	
		jal stos  		# wyœwietlanie
		nop	

	dalej:	
		move $sp $s6 	# adres koñca sprzed wyœwietlenia				
		li $v0, 4
		la $a0, podaj1
		syscall		
		li $v0 5
		syscall
		move $t0 $v0
		
		beq $t0 0 liczba
		nop
		
		beq $t0 1 operator
		nop
		#zabezpieczenie
		bgt $t0 1 error
		nop
		blt $t0 0 error
		nop
		
	j petla 
	nop	
		
	liczba:
		li $v0, 4
		la $a0, podaj3
		syscall
		li $v0 5
		syscall
		move $t4 $v0 
		
		jal push      
		nop 
		j petla 
		nop			
	operator:
		li $v0, 4
		la $a0, podaj2
		syscall		
		li $v0 5
		syscall
		move $t1 $v0
		
		bgt $t1 4 error	# zabezpieczenia
		nop
		blt $t1 0 error
		nop
	
		### jeœli jeden z ostatnich dwóch = 47 to error
		### bo potrzeba przynajmniej 2 liczb 
		
		jal pop
		nop
		move $t6 $t5
		beq $t6 47 error
		jal pop
		nop
		move $t7 $t5
		beq $t7 47 error
		nop
		
		beq $t1 0 dodawanie
		nop		
		beq $t1 1 odejmowanie
		nop		
		beq $t1 2 mnozenie
		nop		
		beq $t1 3 dzielenie
		nop
		beq $t1 4 swap
		nop
		
		j petla
		nop
	swap:
		
		move $t4 $t6
		jal push
		nop
		move $t4 $t7 
		jal push
		nop
		j petla
		nop
		
	stos:
		jal isEmpty2
		nop
	stos1:
		#beq $t2 1 stos2
		#nop
		beq $t2 0 dalej
		nop		
	stos2:	
		lw $t5, 0($sp) # Za³aduj wartosc do $t5
		addi $sp, $sp, 4 # Zwieksz SP o s³owo
		
		addi $a0 $zero 10 #nowa linia
		li $v0 11
		syscall
		
		li $v0 1
		move $a0 $t5
		syscall
		
		j stos
		nop

	isEmpty2:
		beq $s4 $sp pusty
		nop
		bne $s4 $sp niepusty
		nop	
	pusty:
		addi $t2 $zero 0 
		j stos1
		nop
	niepusty:
		addi $t2 $zero 1 
		j stos2
		nop
	push: 
		addi $sp, $sp, -4 # Obniz SP o s³owo
		sw $t4, 0($sp) # Zapisz $t4 na stosie
		
		jr $ra
		nop
	pop: 
		lw $t5, 0($sp) # Za³aduj wartosc do $t4
		addi $sp, $sp, 4 # Zwieksz SP o s³owo
		
		jr $ra
		nop		
	dodawanie:		
		add $t4 $t7 $t6
		li $v0 4
		la $a0 wynik 
		syscall
		li $v0 1
		move $a0 $t4
		syscall
		
		jal push 
		nop 
		
		j petla
		nop	
	odejmowanie:
		sub $t4 $t7 $t6
		li $v0 4
		la $a0 wynik 
		syscall
		li $v0 1
		move $a0 $t4
		syscall
		
		jal push 
		nop 
		j petla
		nop
	mnozenie:
		mul $t4 $t6 $t7
		li $v0 4
		la $a0 wynik 
		syscall
		li $v0 1
		move $a0 $t4
		syscall
		
		jal push 
		nop 
		j petla
		nop
	dzielenie:
		beqz $t6 error  # tylko to badamy bo to mianownik
		nop
		div $t7 $t6
		mflo $t4
		
		li $v0 4
		la $a0 wynik 
		syscall
		
		li $v0 1
		move $a0 $t4 
		syscall
				
		jal push 
		nop 
		j petla
		nop	
	error:
		li $v0, 4
		la $a0, err
		syscall
		jal koniec
		nop
	koniec:
		li $v0 10
		syscall
		
	
