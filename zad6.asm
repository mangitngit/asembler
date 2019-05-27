dane SEGMENT ;segment danych

tekst_przerwa db 13, 10, "$"
WE dw 10, 23, 45, 56, 103, 23, 45, 56, 103, 23, 45, 56, 103, 23, 45, 56, 103;
WY dw 103, 23, 45, 56, 103, 23, 45, 56, 103, 23, 45, 56, 103, 23, 45, 56, 103;
koniec_txt db ? ;
nlcr db 0dh, 0ah, "$"
rej dw 0
dane ENDS

rozkazy SEGMENT ;segment rozkazu
ASSUME cs:rozkazy, ds:dane


startuj:  	;program dziala do end wystartuj
			mov ax, SEG dane    
			mov ds, ax 
			
			
			mov cx, 10; 64 
			mov si, 0; OFFSET WE ; nasz sterownik petla
			
			
glowny:		
		
			push cx
			mov cx, word PTR WE[si] ; do cx wpisujemy piewsza komorke
			mov ax, cx
			mov bx, 220
			mul bx
			mov bx, 64
			div bx 	
			mov cx, ax  ; w cx mamy co obliczylismy w pierwszym dodawaniu
			
			mov ax, word PTR WE[si] ; do axa nasze xi
			mov bx, 220 
			mul bx
			add ax, 160
			mov bx, 128
			div bx
			add ax, cx
			;shr ax, 5
			mov cx, ax
			mov word PTR WY[si], cx ; do TRZECIEJ komorki wpisujemy cx 
			call WYSWIETL
			call SPACJA 
			inc si
			inc si
			pop cx
			loop glowny
			
 	
	

			
			;dec si 
			;loop p1 
			
			
przerwa:    
            mov dx, offset tekst_przerwa
            mov ah, 09h
            ;int 21h
            
dalej:

		mov al, 0 	;kod powrotu programu (przekazywany przez
				;rejestr AL) stanowi syntetyczny opis programu
				;przekazywany do systemu operacyjnego
				;(zazwyczaj kod 0 oznacza, że program został
				;wykonany poprawnie)
				
				
				;do systemu, za pomocą funkcji 4CH DOS
				; zrwacamy zero - gry jest ok.
				
		mov ah, 4CH 	;zakończenie programu – przekazanie sterowania
		int 21H
		
SPACJA PROC near		
			mov dx, offset tekst_przerwa
            mov ah, 09h
            int 21h
			ret
SPACJA ENDP
		
		
WYSWIETL PROC near
			mov cx, 0  ;licznik cyfr 
			mov bx, 10 ;dzielnik p1:
			
p1:			mov dx, 0  ;zerowanie starszej części dzielnej 
			div bx  ;dzielenie przez 10 – iloraz w AX, reszta w DX 
			add dx, 30H ;zamiana reszty na kod ASCII 
			push dx  ;zapisanie cyfry na stosie 
			inc cx  ;inkrementacja licznika cyfr 
			cmp ax, 0  ;porównanie uzyskanego ilorazu 
			jnz p1  ;skok gdy iloraz jest różny od zera 

p2: 		pop dx  ;pobranie kodu ASCII kolejnej cyfry 
			mov ah, 2 
			int 21H  ;wyświetlenie cyfry na ekranie 
			loop p2  ; sterowanie pętlą wyświetlania 
			ret  
WYSWIETL ENDP
		
rozkazy ENDS
stosik SEGMENT stack
dw 128 dup(?)
stosik ENDS
END startuj