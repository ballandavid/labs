;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_2
;Készítsünk el egy olyan stringbeolvasó eljárást, amely megfelelőképpen kezeli le a backspace billentyűt (azaz visszalépteti a kurzort és letörli az előző karaktert).
;Teszteljük ezt az eljárást különböző kritikus esetekre (pl. a string elején a backspace-nek ne legyen hatása, valamint ha már több karaktert vitt be a felhasználó, mint a megengedett hossz és lenyomja a backspace-t akkor nem az elmentett utolsó karaktert kell törölni, hanem az elmentetlenekből az utolsót).
;<Enter>-ig olvas.
;Ebben a feladatban C stringekkel dolgozunk, itt a string végét a bináris 0 karakter jelenti.
;Készítsünk el egy olyan IOSTR.ASM / INC modult, amely a következő eljárásokat tartalmazza:
;ReadStr(EDI vagy ESI, ECX max. hossz):()   – C-s (bináris 0-ban végződő) stringbeolvasó eljárás, <Enter>-ig olvas
;WriteStr(ESI):()                           – stringkiíró eljárás
;ReadLnStr(EDI vagy ESI, ECX):()   				 – mint a ReadStr() csak újsorba is lép
;WriteLnStr(ESI):()                         – mint a WriteStr() csak újsorba is lép
;NewLine():()                               – újsor elejére lépteti a kurzort

%include 'mio.inc'

global ReadStr
global WriteStr
global ReadLnStr
global WriteLnStr
global NewLine

section .text

; beolvas egy karlancot
ReadStr:
.ciklus:
	call    mio_readchar
	cmp		al,13
	je		.vege

	cmp		ecx,0
	je		.ciklus

	cmp		al,8
	jne		.ugras

	cmp		ecx,255		; megnezem ha a karlanc elejen vagyok
	je		.ciklus

	call	mio_writechar
	mov		al,' '
	call	mio_writechar
	mov		al,8
	call	mio_writechar

	inc		ecx
	dec 	edi
	jmp		.ciklus

.ugras:
	call	mio_writechar		;kiiratom a karaktert
	dec		ecx ; csokkentem, mert egy karakter bekerult
	stosb ; betolti oda ahova az edi mutat
	jmp		.ciklus

.vege:
	xor		al,al
	stosb

	ret

WriteStr:
	pusha

.ciklus:
	lodsb
	cmp		al,0
	je		.vege
	call	mio_writechar
	jmp		.ciklus

.vege:
	popa
	ret

ReadLnStr:
.ciklus:
	call    mio_readchar
	cmp		al,13
	je		.vege

	cmp		ecx,0
	je		.ciklus

	cmp		al,8
	jne		.ugras

	cmp		ecx,255		; megnezem ha a karlanc elejen vagyok
	je		.ciklus

	call	mio_writechar
	mov		al,' '
	call	mio_writechar
	mov		al,8
	call	mio_writechar

	inc		ecx
	dec 	edi
	jmp		.ciklus

.ugras:
	call	mio_writechar		;kiiratom a karaktert
	dec		ecx ; csokkentem, mert egy karakter bekerult
	stosb ; betolti oda ahova az edi mutat
	jmp		.ciklus

.vege:
	xor		al,al
	stosb

	call	mio_writeln

	ret

WriteLnStr:
	pusha

.ciklus:
	lodsb
	cmp		al,0
	je		.vege
	call	mio_writechar
	jmp		.ciklus

.vege:
	call	mio_writeln

	popa
	ret

NewLine:
	pusha

	mov     al, 13
  call    mio_writechar
  mov     al, 10
  call    mio_writechar

	popa
	ret

section .bss
	a resb 256
