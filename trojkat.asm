data SEGMENT MEMORY 'DATA'
base	db "77777777777777", 13, 10, "$"
space	db "           ", "$"
char	db "6"
ent	db 13, 10, "$"
data ENDS



code SEGMENT MEMORY 'CODE'
ASSUME ds:data
start:	mov ax, SEG data
	mov ds, ax

	mov dx, OFFSET base		;print base
	mov ah, 9h
	int 21H

	mov cx, 6			;setup loop
	mov bx, OFFSET space

lp1:	mov dl, char			;print character
	mov ah, 2h
	int 21H

	mov dx, bx			;print space
	mov ah, 9h
	int 21H

	mov dl, char			;print character
	mov ah, 2h
	int 21H

	mov dx, OFFSET ent		;print new line
	mov ah, 9h
	int 21H
	
	mov dl, char			;decrement character
	dec dl
	mov char, dl

	inc bx				;shorten space
	inc bx

loop lp1

	mov dl, char			;print last character
	mov ah, 2h
	int 21H

	mov al, 0			;return 0
	mov ah, 4CH
	int 21H
code ENDS



stack SEGMENT STACK 'STACK'
stack ENDS



END start