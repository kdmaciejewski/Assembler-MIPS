# t0 czas systemu seed
# $t1 ilo�� ci�g�w
# $t3 warunek p�tli
# $t4 warunek p�tli t4
# $t6 zakres liter kt�re chce

.data
	ciag: .asciiz "\nPodaj liczbe ciagow "
	wynik: .asciiz "\nWygenerowane ciagi:\n"
	spacja: .asciiz "  "
	

.text
	main:
		li $v0 4
		la $a0 ciag    #ilo��
		syscall
		
		li $v0 5
		syscall
		move $t1 $v0			
		
		addi $t3 $zero 0  # do p�tli
		
		li $v0 4
		la $a0 wynik
		syscall
		
	petla:
		
		beq $t3, $t1, koniec 				
		nop 
		 # trzeba wyzerowa�
		move $t4 $zero
		
		mala:
		
		beq $t4, 10, malakoniec
		nop
		
			li $v0 30		# czas systemu w milisek 64bit�w
			syscall

			move	$t0, $a0	# bierzemy dolne 32 bity
		
			addi $t6 $t6 26			
			#wz�r   (3X + 13)  mod 127
			
			mul $t0 $t0 3
			
			addi $t0 $t0 13
			div $t0 $t6  # bo do tego znaku chce
			mfhi $a0
			addi $a0 $a0 64
					
						
			
			li $v0,11 			# wy�wietl char
			syscall
			addi $t4 $t4 1		#inkrementuje
			
			j mala
			nop
	
	malakoniec:
		#nowa linia
		addi $a0 $zero 10
		li $v0 11
		syscall
		
	
		addi $t3 $t3 1  #inkrementuje
		j petla
		nop	

   	koniec:
   		li $v0 10
   		syscall
   		
