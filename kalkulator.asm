#odczytane liczby:
# $t0 i $t2
#odczytany znak: $t1
#odczytanie czy kontynuowaæ: $t4
#wynik: $t3

.data
	tekst: .asciiz "\nPodaj pierwsza liczbe     "
	tekst2: .asciiz "\nPodaj druga liczbe      "
	znak: .asciiz "\nPodaj znak  (0-3)       "
	czy: .asciiz "\nCzy wykonac kolejna operacje (1 - tak, 0 - nie)  "
	wynik: .asciiz "\nWynik: "
	err: .asciiz "Zla cyfra!"
	
.text	
	
	main: ################################################################################################
		add $t4, $zero,1
		jal petla
		nop
	
	petla: 
		
	beq $t4,$zero, koniec #if odp jest równa 0 to przerwij pêtle i skocz na koniec
		nop
	
	#podaj liczbe 1
		li $v0, 4 
		la $a0, tekst
		syscall
	#wprowadzanie
		li $v0, 5
		syscall
		move $t0, $v0
	
	#podaj znak
		li $v0, 4 
		la $a0, znak
		syscall
	#wprowadzanie 2
		li $v0, 5	
		syscall
		move $t1, $v0
		
		bgt $t1, 3, error  #if t1> 3 to error
		nop
		blt $t1, 0, error	#if t1<0 to error
		nop
		
	#podaj liczbe 2 (znak)
		li $v0, 4 
		la $a0, tekst2
		syscall
	#wprowadzanie 3
		li $v0, 5
		syscall
		move $t2, $v0
	
	#cztery funkcje beq przenosz¹ce do metody wykonuj¹cej dane dzia³anie
	#porównujemy odczytany znak ze znakiem metody
		
		
		beq $t1, 0, dodawanie
		nop 
		beq $t1, 1, odejmowanie 
		nop
		beq $t1, 2, mnozenie
		nop
		beq $t1, 3, dzielenie
		nop
		
	##########################################################################################################
	dodawanie:
		add $t0, $t0, $t2
		
		jal wyswietlanie
		nop
		
	odejmowanie:
		sub $t0, $t0, $t2
	
		jal wyswietlanie
		nop
	
	mnozenie:
		mul $t0, $t0, $t2
	
		jal wyswietlanie
		nop
	
	dzielenie:
		div $t0, $t0, $t2
	
		jal wyswietlanie
		nop
	wyswietlanie:
		li $v0, 4
		la $a0, wynik
		syscall
		
		
		li $v0, 1	#wyœwietlanie
		move $a0, $t0  		
		syscall	
				
		jal kontynuacja
		nop
	kontynuacja:#############################################
		li $v0, 4
		la $a0, czy
		syscall
	
		li $v0, 5
		syscall
		move $t4, $v0 
		
		
		bgt $t4, 1, error  #if t4> 1 to error
		nop
		blt $t4, 0, error	#if t4<0 to error
		nop
		beq $t4, 1, petla # t4 = 1 to do pêtli
		nop
		beq $t4, 0, koniec
		nop
		
		jr $ra
		nop
	error:
		li $v0, 4
		la $a0, err
		syscall
		jal koniec
		nop
	koniec:
		li $v0, 10 
		syscall
