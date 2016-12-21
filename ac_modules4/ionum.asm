%include 'mio.inc'

global main

section .text

ReadInt:
	xor		eax, eax ;lenullazom eax-et
	xor		ebx, ebx ;lenullazom ebx-et
	xor		dl, dl ;lenullazom mert ebben fogom a hibat megjegyezni hogy volt-e
	mov 	ecx,1	;feltetelezem hogy a szamom pozitiv
	
	call	mio_readchar ;beolvasom az elso karaktert
	call	mio_writechar
	
	cmp		eax, '-'	;ha az elso karakter egy minusz
	je		.negativ_Szam
	
	jmp		.pozitiv_Szam ;ha nem negativ akkor ugrok a pozitiv ciklusomhoz
	
.negativ_Szam:
	mov		ecx,-1 ;negativ szam eseten ecx -1 lesz
	call	mio_readchar
	call	mio_writechar
	
.pozitiv_Szam:
	
.ciklus:
			
	cmp		eax, 13		;megnezi ha egyenlo-e enter-vel
	je		.vege		;jump if equal. ha entert olvastam be ugrik a vegere, vege a beolvasasnak
	
	cmp		al,8
	jne		.ugras
	mov		al,' '
	call	mio_writechar
	mov		al,8
	call	mio_writechar
	cmp		ebx,0	;ellenorzom ha a backspace nincs-e a legelejen
	je		.ciklus
	dec		ebx
	jmp		.vissza_hiba
			
.ugras:
			
; megnezem ha nem szamjegyet olvastam be
	cmp		eax, '9'
	jg		.hiba		;jump if greater
	cmp		eax, '0'	
	jl		.hiba	 	;jump if less
	
	sub		eax, '0'
	imul	ebx, 10
	add		ebx, eax
			
.vissza_hiba:
			
	call	mio_readchar
	call	mio_writechar
			
	jmp		.ciklus

.hiba:
	mov		dl,1
	jmp		.vissza_hiba
	
.vege:
	cmp		ecx,-1
	je		.negativ_sz
	
	jmp 	.negativ_sz_vege
	
.negativ_sz:
	neg		ebx
	jmp		.negativ_sz_vege
	
.negativ_sz_vege:

	call	mio_writeln
	
	mov 	eax,ebx
	
	ret

main:

.ujra:
	call	ReadInt
	
	clc
	shr		dl,1
	jne		.nem_hiba
	
	call	mio_writeln
	mov 	eax, hiba_uzenet
	call	mio_writestr
	call	mio_writeln
	
	jmp		.ujra

.nem_hiba:
	
	ret
	
section .data
	hiba_uzenet db 'Hiba',0