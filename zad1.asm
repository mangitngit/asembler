dane SEGMENT 	;segment danych
new_line 	db 13,10, "$"
puste_po	db '           ',"$"
puste_przed	db '    ',"$"
pod_1	db '%%%%%',13,10,"$"
pod_2	db '%%%%%%%%%%%%%%%',"$"
char    db '%',"$"
dane ENDS

rozkazy SEGMENT 'CODE' use16 	;segment zawierający rozkazy programu
	ASSUME cs:rozkazy, ds:dane
	
wystartuj:
	mov ax, SEG dane
	mov ds, ax
	
	mov dx, OFFSET puste_po		;spacje przed podstawa
	mov dx, 9
	mov ah, 9h
	int 21H
	
	mov dx, OFFSET pod_1	;gorna podstawa
	mov ah, 9h
	int 21H
	
	mov cx, 4
	mov bx, OFFSET puste_przed
	mov bx, 10
	mov si, OFFSET puste_po
	mov si, 9

lp1:
	mov dx, bx	;spacje przed
	mov ah, 9h
	int 21H

	mov dl, char	;znak
	mov ah, 2h
	int 21H
	
	mov dx, si	;spacje po znaku
	mov ah, 9h
	int 21H
	
	mov dl, char	;znak
	mov ah, 2h
	int 21H

	mov dx, OFFSET new_line	;nowa linia
	mov ah, 9h
	int 21H		
	
	dec si
	dec si
	inc bx
loop lp1		

	mov dx, OFFSET pod_2	;dolna podstawa
	mov ah, 9h
	int 21H
	
	mov al, 0 
	mov ah, 4CH 
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack 	;segment stosu
dw 128 dup (?)
nasz_stos ENDS

END wystartuj 