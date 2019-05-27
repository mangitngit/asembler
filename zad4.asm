dane SEGMENT MEMORY 'DATA'	;segment danych
we2	db '2,3,4,5,6,7,8,9,10,11,12,13,14,72,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,1,38,39,40,41,42,43,44,45,46,47',"$"
Buf 	db 4 dup(0)
ent 	db 13,10, "$"
we	dw 2,3,4,5,6,7,8,9,10,11,12,13,14,75,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,1,38,39,40,41,42,43,44,45,46,47
text_min	db 'min  - ',"$"
text_max	db 'max  - ',"$"
text_mean	db 'mean - ',"$"
dane ENDS
; suma 1200
; srednia 25
; najmniejszy 1
; najwiekszy 72

rozkazy SEGMENT MEMORY 'CODE'
	ASSUME cs:rozkazy, ds:dane
wystartuj:
	mov ax, SEG dane
	mov ds, ax


call WYPISZ_WE
call ENTE

mov dx, offset text_min
call TEKST

mov ax, offset we
push ax
mov ax, 47
push ax
call MIN
pop ax
pop ax

call ENTE

mov dx, offset text_max
call TEKST

mov ax, offset we
push ax
mov ax, 47
push ax
call MAX
pop ax
pop ax

call ENTE

mov dx, offset text_mean
call TEKST

mov ax, offset we
push ax
mov ax, 48
push ax
call SREDNIA
pop ax
pop ax

call WYJDZ


MIN PROC near
	push bp
	mov bp, sp
	mov si, [bp]+6
	mov cx, [bp]+4
	mov dx, word PTR[si]
	mov di, dx
lp:
	inc si
	inc si
	mov dx, word PTR[si]
	cmp di, dx
	ja podmien
podmien2:
	loop lp
	push di
	;mov ax, di
	call WYPISZ_LICZBE
	pop di
	pop bp
	ret
podmien:
	mov di, dx
	jmp podmien2
MIN ENDP

MAX PROC near
	push bp
	mov bp, sp
	mov si, [bp]+6
	mov cx, [bp]+4
	mov dx, word PTR[si]
	mov di, dx
lp:
	inc si
	inc si
	mov dx, word PTR[si]
	cmp di, dx
	jb podmien
podmien2:
	loop lp
	push di
	;mov ax, di
	call WYPISZ_LICZBE
	pop di
	pop bp
	ret
podmien:
	mov di, dx
	jmp podmien2
MAX ENDP

SREDNIA PROC near
	push bp
	mov bp, sp
	mov di, 0
	mov si, [bp]+6
	mov cx, [bp]+4
lp:
	mov dx, word PTR[si]
	
	add di, dx
	
	inc si
	inc si
	loop lp
	
	mov ax, di
	mov bl, 48
	div bl
	mov di, ax
	mov ah, 0
	push ax
	call WYPISZ_LICZBE
	pop ax	
	call ZNAK
	mov ax, di
	xchg al, ah
	mov ah, 0
	push ax
	call WYPISZ_LICZBE
	pop ax
	pop bp
	ret
SREDNIA ENDP

ZNAK PROC near
	mov dx, 72H
	mov ah, 2h
	int 21H
	ret
ZNAK ENDP

TEKST PROC near
	mov ah, 9h
	int 21H
	ret
TEKST ENDP

WYPISZ_LICZBE PROC near
	push bp
	mov bp, sp
	mov ax, [bp]+4
	
	mov cx, 2 			;liczba obiegów pętli
	mov bx, 10 			; dzielnik
	mov si, 1		 	;indeks początkowy w tablicy tbl_cyfr
p1: mov dx, 0 			;zerowanie starszej części dzielnej
	div bx 				;dzielenie przez 6; iloraz w AX, reszta w DX
	add dx, 30H 			;zamiana reszty na kod ASCII
	mov Buf[si], dl 		;odesłanie kodu ASCII kolejnej cyfry do tablicy
	dec si 				;zmniejszenie indeksu w rejestrze SI o 1
	loop p1

	mov cx, 1 			;liczba obiegów pętli usuwania zer nieznaczących
	mov si, 0 			;indeks początkowy w tablicy cyfry
p2: cmp byte PTR Buf[si], 30H 	;czy cyfra '0'
	jne druk
	mov byte PTR Buf[si], 20H 	;wpisanie kodu spacji w miejsce zera
	inc si
	loop p2

	;wyświetlanie cyfr
druk:
	mov cx, 2 			;liczba obiegów pętli
	mov si, 0 			;indeks początkowy w tablicy cyfry
p3: mov dl, Buf[si] 		;pobranie kodu ASCII kolejnej cyfry
	mov ah, 2 			;wyświetlenie cyfry na ekranie
	int 21H
	inc si 				;zwiększenie indeksu w rejestrze SI o 1
	loop p3 
	
	pop bp
	ret
WYPISZ_LICZBE ENDP


ENTE PROC near
	mov dx, OFFSET ent
	mov ah, 9h
	int 21H
	ret
ENTE ENDP

WYPISZ_WE PROC near
	mov dx, OFFSET we2
	mov ah, 9h
	int 21H
	ret
WYPISZ_WE ENDP

WYJDZ PROC near
	mov al, 0 
	mov ah, 4CH 
	int 21H
WYJDZ ENDP

rozkazy ENDS

nasz_stos SEGMENT stack 	;segment stosu
dw 128 dup (?)
nasz_stos ENDS

END wystartuj