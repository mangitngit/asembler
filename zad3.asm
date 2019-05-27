dane SEGMENT MEMORY 'DATA'	;segment danych
ent 	db 13,10, "$"
tablica	db '46821379546483548246841384981322',"$"
dane ENDS

rozkazy SEGMENT MEMORY 'CODE'
	ASSUME cs:rozkazy, ds:dane
wystartuj:
	mov ax, SEG dane
	mov ds, ax
	
mov dl, tablica[3]
call ZNAK
call ENTE

mov dx, OFFSET tablica
call TEKST
call ENTE

;call ZAMIEN
call WYJDZ

ZAMIEN PROC near
	mov bx, OFFSET tablica
	mov cx, 32
	mov si, 0
	mov di, 1
lp1:
	mov dl, tablica[si]
	cmp di, 4
	je change
	jchange:
	call ZNAK
	inc si
	inc di
	loop lp1
	ret

change:
	mov al, 9
	sub dl, 30H
	sub al, dl
	mov dl, al
	add dl, 30H
	mov di, 0
	jmp jchange
	
ZAMIEN ENDP

ZNAK PROC near
	mov ah, 2h
	int 21H
	ret
ZNAK ENDP

TEKST PROC near
	mov ah, 9h
	int 21H
	ret
TEKST ENDP

ENTE PROC near
	mov dx, OFFSET ent
	mov ah, 9h
	int 21H
	ret
ENTE ENDP

WYJDZ PROC near
	mov al, 0 
	mov ah, 4CH 
	int 21H
WYJDZ ENDP

rozkazy ENDS

nasz_stos SEGMENT stack 	;segment stosu
dw 128 dup (?)
nasz_stos ENDS

END wystartuj 			;wykonanie programu zacznie siê od rozkazu
				;opatrzonego etykiet¹ wystartuj