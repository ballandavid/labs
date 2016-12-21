;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_1
;Készítsünk el egy olyan saját IONUM.ASM / INC modult, amely a következő eljárásokat tartalmazza, a megadott pontos paraméterezéssel (az első zárójelben a bemeneti, a másodikban a kimeneti paramétereket adtuk meg, az eljárások globálisak!).
;Hexa olvasásnál kis- és nagybetűket is el kell fogadjon.
;Hexa és bináris olvasásnál nem kötelező az összes számjegyet beírni (azaz nem lehet a számjegyek száma az egyetlen leállási feltétel).
;Az olvasás kell kezelje a túlcsordulást és a backspace-t (hasonlóan a második feladathoz, érdemes egyszer annak az első részét megoldani).
;Minden függvény kötelezően <Enter>-ig olvas. Csak az <Enter> lenyomása után tekintünk egy beírt adatot hibásnak.
;A függvény a hibát a CF beállításával jelzi a főprogramnak. Hiba esetén a főprogram írja ki, hogy Hiba és utána kérje újra az adatot.

;    ReadInt():(EAX)                  – 32 bites előjeles egész beolvasása
;    WriteInt(EAX):()                  – 32 bites előjeles egész kiírása
;    ReadInt64():(EDX:EAX)      – 64 bites előjeles egész beolvasása
;    WriteInt64(EDX:EAX):()      – 64 bites előjeles egész kiírása
;    ReadBin():(EAX)                 – 32 bites bináris pozitív egész beolvasása
;    WriteBin(EAX):()                 –                    - || -                   kiírása
;    ReadBin64():(EDX:EAX)     – 64 bites bináris pozitív egész beolvasása
;    WriteBin64(EDX:EAX):()     –                    - || -                   kiírása
;    ReadHex():(EAX)                – 32 bites pozitív hexa beolvasása
;    WriteHex(EAX):()                –                    - || -                   kiírása
;    ReadHex64():(EDX:EAX)     – 64 bites pozitív hexa beolvasása
;    WriteHex64(EDX:EAX):()     –                    - || -                   kiírása



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

WriteInt:

		push	eax
		push 	ebx
		push 	ecx
		push 	edx

		cmp		ebx, 0		;nezzuk ha negativ volt
		jl		.negativ
		jmp 	.pozitiv

		.negativ:
			mov		eax, '-'
			call	mio_writechar
			neg 	ebx		;negalom hogy megkapja a negativ alakjat

		.pozitiv:
		xor		eax, eax
		mov		eax, ebx
		mov		ebx, 10
		push	dword -1


		.ciklus1:
			cdq
			idiv	ebx
			push	edx
			test	eax, eax
			cmp		eax, 0
			jne		.ciklus1

		.ciklus2:
			pop		eax
			cmp		eax, -1
			je		.vege
			add		eax, '0'
			call	mio_writechar
			jmp		.ciklus2

	.vege:

		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	eax

		ret

main:
	call	ReadInt

	call	WriteInt

	ret

section .data
	hiba_uzenet db 'Hiba',0
