# t0 - indeks wyra�enia do przetworzenia
# t3 - przesuni�cie
# t4 - zmieniana litera
# t5 - liczba liter alfabetu
# t6 - tryb

.data
	tryb: .asciiz "\nPodaj tryb operacji  (0  szyfrowanie, 1  odszyfrowanie)    "
	przes: .asciiz "\nPodaj liczbe przesuniecia    "
	tekst: .asciiz "\nPodaj tekst do zaszyfrowania (max. 16 znakow)   "
	tekstod: .asciiz "\nPodaj tekst do odszyfrowania (max. 16 znakow)   "
	err: .asciiz "\nPodano zle wartosci!"
	
 	data: .space 17 #bo 16 liter + enter
	
.text
	main:	
		li $v0 4
		la $a0 tryb
		syscall
		li $v0 5
		syscall
		move $t6 $v0
		
		bgt $t6 1 error
		nop
		blt $t6 0 error
		nop
		
		beq $t6 0 normalnytekst
		nop
		beq $t6 1 zaszyfrowanytekst
		nop
	
		li $v0 10 
		syscall
	
	normalnytekst: #odczytuje normalny tekst od u�ytkownika
					
 		la $a0,tekst 	#podaj tekst
 		li $v0,4
	 	syscall
		la $a0,data		#tablica data
 		la $a1,17  		
 		li $v0,8		#wprowadzanie stringa
 		syscall
 		la $t0,($a0) 	#adres
 	
 		la $a0,przes
 		li $v0,4
	 	syscall
 		li $v0,5
 		syscall
 		move $t3,$v0 		# przechowuje warto�� przesuni�cia
 	
 	Zaszyfruj:
 		lb $t4, 0($t0)  	 	# czytanie chara z tablicy, �adowanie do t4
		beq $t4,10, koniec 	# 10 to enter
	 	nop
	 	
 		beqz $t4, koniec  	#je�li r�wne 0
 		nop
 			
 		jal CzyDobra 		#sprawdza czy to dobra litera w kodzie asciiz
		nop
		
 		beq $v0,1,Wyswietlanie  #je�li 1 to mo�na dalej
 		nop
		beq $v0,0,error 	
	  	nop	
	
	CzyDobra:	#po 122 ko�cz� sie ma�e, na 97 zaczynaj� si� ma�e litery
		
 		bgt $t4,122,error	 
 		nop	
 		blt $t4,97,error	
 		nop	
 		li $v0,1   			#je�li wszystko si� zgadza to v0 przechowuje 1 
 		jr $ra    
 		nop			
 
	Wyswietlanie:			# szyfrowanie ma�ych liter
 		li $t5,26   				
 		sub $t4,$t4,97
 		add $t4, $t4, $t3
 		blt $t4, 0, Ujemne
 		nop
 		
 		div $t4,$t5
		mfhi $a0			#bierze reszte
 		addi $a0,$a0,97
 		
 		li $v0,11 			# wy�wietl char
		syscall
		add $t0,$t0,1 		# kolejny char dzi�ki temu oczytujemy kolejne litery
 		
 		j Zaszyfruj			#p�tla
 		nop
 		
 	Ujemne:
 		div $t4,$t5
		mfhi $a0				#bierze reszte
 		addi $a0,$a0, 26
 		#move $t4, $a0	#tutaj jest odpowiednie przesuni�cie dla ujemnej
 		addi $a0, $a0, 97
 		
 		li $v0,11 			# wy�wietl char
		syscall
		addi $t0,$t0,1 		# kolejny char dzi�ki temu oczytujemy kolejne litery
 		
 		j Zaszyfruj			#p�tla
 		nop
 		
 	#######################     ODSZYFROWYWANIE     #######################
 	
 	zaszyfrowanytekst:
 		li $v0 4
 		la $a0 tekstod
 		syscall
 		
 		la $a0,data		#tablica data
 		la $a1,17  		
 		li $v0,8		#wprowadzanie stringa
 		syscall
 		la $t0,($a0) 	 
 		
 		li $v0 4
 		la $a0 przes
 		syscall
 		li $v0 5
 		syscall
 		move $t3 $v0  #przesuni�cie
 	
 	Odszyfruj:
 		lb $t4, 0($t0)  	 	
		beq $t4,10, koniec
		nop 	
	 
 		beqz $t4, koniec  
 		nop	
 		jal CzyDobra2 	
 		nop
 		
 		beq $v0,1,Wyswietlanie2  
 		nop 
		beq $v0,0,error 
		nop	
	
	CzyDobra2:	#po 122 ko�cz� sie ma�e, na 97 zaczynaj� si� ma�e litery
		
 		bgt $t4,122,error	
 		nop 	
 		blt $t4,97,error	
 		nop	
 		li $v0,1   			#je�li wszystko si� zgadza to v0 przechowuje 1 
 		jr $ra    			
 		nop
 		
	Wyswietlanie2:			# odszyfrowywanie ma�ych liter
 		li $t5,26   				
 		sub $t4,$t4,97
 		sub $t4, $t4, $t3		#gdy ujemne to problem
 		blt $t4, 0, Ujemne2
 		nop
 		
 		div $t4,$t5
		mfhi $a0				
 		addi $a0,$a0,97
 		
 		li $v0,11 			# wy�wietl char
		syscall
		add $t0,$t0,1 		# kolejny char
 		
 		j Odszyfruj			#p�tla
 		nop
 		
 	Ujemne2:
 		div $t4,$t5
		mfhi $a0				#bierze reszte
 		addi $a0,$a0, 26 #tutaj jest odpowiednie przesuni�cie dla ujemnej
 		addi $a0, $a0, 97
 		
 		li $v0,11 			# wy�wietl char
		syscall
		addi $t0,$t0,1 		# kolejny char dzi�ki temu oczytujemy kolejne litery
 		
 		j Odszyfruj			#p�tla
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
		
	
					
