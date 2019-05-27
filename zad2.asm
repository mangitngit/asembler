data SEGMENT MEMORY 'DATA'
Buf_1 	db 4 dup(0)
LBin 	dw 0
Buf_2 	db 128 dup(0)

data ENDS

code SEGMENT MEMORY 'CODE'
ASSUME ds:data
start:	mov ax, SEG data
	mov ds, ax

				; wczytywanie liczby do AX, zakończenie wczytywania po Enter
	mov si, 0 		;początkowa wartość wyniku konwersji w SI
p1: mov ah, 1 		;wczytanie znaku w kodzie ASCII
	int 21H 		;z klawiatury do AL
	cmp al, 13
	je nacis_enter 		;skok gdy naciśnięto klawisz Enter
	sub al, 30H 		;zamaiana kodu ASCII na wartość cyfry
	mov bl, al 		;przechowanie kolejnej cyfry w AL
	mov bh, 0 		;zerowanie rejestru BH
	mov ax, 5 		;mnożnik
	mul si 			;mnożenie dotychczas uzyskanego wyniku przez
				;5 iloczyn zostaje wpisany do rejestrów DX:AX
	add ax, bx 		;dodanie aktualnie wczytanej cyfry
	mov si, ax 		;przesłanie wyniku obliczenia do rejestru SI
	jmp p1 			;
nacis_enter:

	mov ax, si 		;przepisanie wyniku konwersji do rejestru AX
	mov LBin, ax		;zapisanie konwertowanej liczby w LBin

	mov bx, SEG data
	mov ds, bx
	mov cx, 4 			;liczba obiegów pętli
	mov bx, 6 			; dzielnik
	mov si, 3			;indeks początkowy w tablicy tbl_cyfr
p2: mov dx, 0 			;zerowanie starszej części dzielnej
	div bx 				;dzielenie przez 6; iloraz w AX, reszta w DX
	add dx, 30H 			;zamiana reszty na kod ASCII
	mov Buf_2[si], dl 		;odesłanie kodu ASCII kolejnej cyfry do tablicy
	dec si 				;zmniejszenie indeksu w rejestrze SI o 1
	loop p2 			;sterowanie pętlą

	;usuwanie zer nieznaczących z lewej strony
	mov cx, 3 			;liczba obiegów pętli usuwania zer nieznaczących
	mov si, 0 			;indeks początkowy w tablicy cyfry
p3: cmp byte PTR Buf_2[si], 30H 	;czy cyfra '0'
	jne druk
	mov byte PTR Buf_2[si], 20H 	;wpisanie kodu spacji w miejsce zera
	inc si
	loop p3

	;wyświetlanie cyfr
druk: mov cx, 4 			;liczba obiegów pętli
	mov si, 0 			;indeks początkowy w tablicy cyfry
p4: mov dl, Buf_2[si] 		;pobranie kodu ASCII kolejnej cyfry
	mov ah, 2 			;wyświetlenie cyfry na ekranie
	int 21H
	inc si 				;zwiększenie indeksu w rejestrze SI o 1
	loop p4 			;sterowanie pętlą wyświetlania  

	mov al, 0			;return 0
	mov ah, 4CH
	int 21H
code ENDS



stack SEGMENT STACK 'STACK'
	dw 128 dup (?)
stack ENDS



END start