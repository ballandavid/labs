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

%include 'io.inc'
%include 'mio.inc'
%include 'iostr.inc'

global ReadInt
global WriteInt
global ReadBin
global WriteBin
global ReadHex
global WriteHex
global ReadInt64
global WriteInt64
global ReadHex64
global WriteHex64
global ReadBin64
global WriteBin64

section .text

; 32-bit

ReadInt:
xor		eax, eax ;lenullazom eax-et
xor		ebx, ebx ;lenullazom ebx-et
xor		ecx,ecx ;lenullazom ecx-et
mov		edx,1

mov		ecx,255
mov		edi,a
call	ReadStr

mov		esi,a
xor		edi,edi ; feltetelezem hogy nem lesz hiba a feldat soran

lodsb ; betoltom az elso karaktert, s novelem esi-t

cmp		al,'-'
jne		.pozitiv ; ha nem '-' akkor ugrok a pozitiv esetre
mov		edx,0

.loop:
xor 	eax,eax
lodsb

.pozitiv:

cmp 	al,0
je		.vege

cmp		al,'0'
jl		.hiba
cmp		al,'9'
jg		.hiba

imul	ebx,10
sub		al,'0'
add		ebx,eax

jmp		.loop

.hiba:
mov		edi,1

.vege:
cmp		edx,1
je		.ugras
neg		ebx ; ha negativ volt a szamom akkr most negalom

.ugras:

call NewLine

cmp		edi,1
je		.ugras1
clc ; nem volt hiba CF <-- 0
ret

.ugras1:
stc ; volt hiba CF <-- 1
ret

WriteInt:

		push	eax
		push 	ebx
		push 	ecx
		push 	edx

		mov		ebx,eax

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

		call	NewLine

		ret

ReadHex:
		xor		ebx, ebx
		xor		eax, eax

		mov		edi,a
		call	ReadStr ; beolvasom a Hexa szamot mint egy karlancot
		mov		esi,a ; esi-t raallitom a karlanc elejere
		xor		edi,edi

		;call	WriteStr

.ciklus:
		lodsb
		cmp		al,0		;ha enter akkor ugrok a .vege cimkere s vege a beolvasasnak
		je		.vege

		cmp		al, '0'
		jl		.hiba		;ha kisebb mint '0' akkor egybol hibat adok
		cmp		al, '9'
		jg		.ellenorzes	;ha '9'-nel nagyobb a beolvasott karakter tovabb lepek a kovetkezo ellenorzesre

		sub		al,'0'		;megkapom az al szambeli erteket
		shl		ebx,4		;4 bittel eltolom a szamom hogy hozzaadjam a kovetkezot
		add		ebx, eax	;hozzaadom az uj szamjegyet
		jmp 	.ciklus

.ellenorzes:
		cmp		al, 'F'		;ellenorzom ha nagyobb-e 'F'-nel. ha igen tovabb ellenorzok
		jg		.ellenorzes2
		cmp		al, 'A'
		jl		.hiba

		sub		al,55
		shl		ebx,4
		add		ebx, eax
		jmp		.ciklus

.ellenorzes2:				;megnezem ha kicsi betuk kozott van-e.
		cmp		al, 'a'
		jl		.hiba			;mindket esetben ugrok a hiba cimkehez
		cmp		al, 'f'
		jg		.hiba

		sub		al,87
		shl		ebx,4
		add		ebx, eax
		jmp		.ciklus

.hiba:
		mov		edi,1

.vege:

		cmp		edi,1
		je		.ugras
		clc
		ret

.ugras:
		stc
		ret

WriteHex:

			push	eax
			push 	ebx
			push 	ecx
			push 	edx

			xor		eax, eax
			xor		ecx, ecx

			mov		eax, ebx
			mov		ebx, 16		;ebx-el osztom a szamot amig nem nulla
			push	dword -1

.ciklus1:
			xor 	edx, edx
			div		ebx

			push	edx ; sorba a verembe teszem
			inc 	ecx
			test	eax, eax
			cmp		eax, 0
			jne		.ciklus1

			mov		ebx,8		;1 byte-ot hasznalok
			sub		ebx,ecx		;(8 - hany osztas)
			mov		ecx,ebx		;ecx-szer vegzem el a ciklust

			cmp		ecx,0
			je		.ugras

			mov		eax,'0'		;0-kat irok ki a szamom ele

.ki_nulla:
			call	mio_writechar
			dec		ecx

			cmp		ecx,0
			jg	.ki_nulla	;ecx-szer kiirom a 0-t a hexa szam ele

.ugras:

.ciklus2:
				xor		eax,eax
				pop		eax				; veszem ki sorban a verembol
				cmp		eax, -1		; amig nem ures a verem
				je		.vege

				cmp		eax,10
				je		.ertek_A

				cmp		eax,11
				je		.ertek_B

				cmp		eax,12
				je		.ertek_C

				cmp		eax,13
				je		.ertek_D

				cmp		eax,14
				je		.ertek_E

				cmp		eax,15
				je		.ertek_F

				add		eax,'0'

.vissza:
			call	mio_writechar
			jmp		.ciklus2

.ertek_A:
				xor		eax,eax
				mov		eax,'A'
				jmp		.vissza

.ertek_B:
				xor		eax,eax
				mov		eax,'B'
				jmp		.vissza

.ertek_C:
				xor		eax,eax
				mov		eax,'C'
				jmp		.vissza

.ertek_D:
				xor		eax,eax
				mov		eax,'D'
				jmp		.vissza

.ertek_E:
				xor		eax,eax
				mov		eax,'E'
				jmp		.vissza

.ertek_F:
				xor		eax,eax
				mov		eax,'F'
				jmp		.vissza

.vege:
			pop 	edx
			pop 	ecx
			pop 	ebx
			pop 	eax
			ret

ReadBin:
		mov		edi,a
		call	ReadStr
		mov		esi,a

		xor		edi,edi
		xor		ebx,ebx

.loop:
		lodsb

		cmp		al,0
		je		.vege

		cmp		al,'0'
		jl		.hiba
		cmp		al,'1'
		jg		.hiba

		shl		ebx,1 ; mindenfelekepp tolok balra

		cmp		al,'1'
		je		.egy

		jmp		.loop ; ha 0 nem csinalok semmit, mert balra tolassal kaptam egy 0-t

.egy:
		add		ebx,1 ; ha 1, novelem a szamom
		jmp		.loop

.hiba:
		mov		edi,1

.vege:
		mov		eax,ebx

		cmp		edi,1
		jne		.ugras
		stc
		ret

.ugras:
		clc
		ret

WriteBin:
		mov		ecx,32 ; 32szer hajtom vegre a kiiratast

.loop:
		cmp		ecx,0
		je 		.vege

		shl		ebx,1
		jc		.egy
		jmp		.nulla

.egy:
		mov		al,'1'
		dec		ecx
		call	mio_writechar
		jmp		.loop

.nulla:
		mov		al,'0'
		dec		ecx
		call	mio_writechar
		jmp		.loop

.vege:
		ret

; 64-bit

ReadInt64:
		push 	ebx
		push	ecx

		xor 	eax, eax				;edx:eax-ban az eredmeny
		xor 	edx, edx

		mov		edi, str_decimalis64
		mov		ecx,255 ; a karlanc maximalis hossza
		call	ReadStr ; beolvasom a szamom karlanc formajaban

		mov 	esi, str_decimalis64
		mov 	ecx, 10
		xor 	ebx, ebx				;bl-be veszem ki a karaktereket

		mov 	bl, [esi]
		cmp 	bl, 0
		je 		.vege
		cmp 	bl, '-'
		jne 	.ciklus

		inc 	esi	;ha negativ tullepunk, majd a vegen lekezeljuk

.ciklus:
		mov 	bl, [esi]
		inc 	esi

		cmp		bl, 0
		je		.ellenoriz
		cmp 	bl,'0'
		jl 		.hiba
		cmp 	bl,'9'
		jg 		.hiba

		sub 	ebx, '0' ; ebx<--szamjegy

		mov		edi, edx
		mul		ecx
		mov		[seged], edx
		imul	edi, ecx
		jo		.hiba

		mov		edx, [seged]
		add		edx, edi
		jo		.hiba

		add		eax, ebx
		adc		edx, 0
		jo		.hiba

		jmp		.ciklus

.hiba:
		mov 	edi, 1

.ellenoriz:
		cmp 	edi, 1
		je 		.vege_hiba

		mov 	esi, str_decimalis64		;elovesszuk az eredeti stringet, nezzuk ha - volt
		mov 	bl, [esi]
		cmp 	bl, '-'						;ellenorizzuk ha negativ volt a szam
		jne 		.vege
		;negativ:
		not 		edx
		not 		eax
		inc 		eax
		adc 		edx, 0 ; carry eseten meg hozzaadjuk

.vege:
		pop 		ecx
		pop 		ebx
		clc
		ret

.vege_hiba:
		pop 		ecx
		pop 		ebx
		stc
		ret

WriteInt64:
			push 		ebx
			push 		ecx
			push 		eax
			push		edx

			mov 		ecx,10
			push 		dword-1

			cmp 		edx,0
			jge 			.ciklus

		;negativ
			mov 		[seged], eax
			mov 		eax, '-'
			call 		mio_writechar
			mov 		eax, [seged]

			not 		edx
			not 		eax
			inc			eax
			adc 		edx,0

.ciklus:
			mov 		ebx,eax					;also 32 bit
			mov			eax,edx					;felso 32 bit-el dolgozok

			xor 		edx, edx
			div 		ecx							;felso 32 bit-et (EDX)
			xchg 		eax,ebx					;csere

			div 		ecx							;also 32 bit-et (EAX)
			push 		edx							;maradekot a verembe teszem
			mov 		edx,ebx					;edx <-- felso 32 bit

			cmp 		edx,0
			je 			.also_bitek

			jmp 		.ciklus

.also_bitek:
			xor 		edx, edx
			div 		ecx							;also 32 bit-et osztjuk
			push		edx
			test 		eax, eax				;amig nem 0
			jnz 		.also_bitek


.stack:
			pop 		eax
			cmp			eax, -1
			je 			.vege
			add 		eax, '0'
			call 		mio_writechar
			jmp 		.stack

.vege:
			pop 		edx
			pop 		eax
			pop 		ecx
			pop 		ebx
			ret

ReadHex64:
		push 		ecx
		push 		ebx
		push 		edi

		mov 		edi, a
		mov 		ecx, 255
		call 		ReadStr

		mov		esi, a

		mov		edi,15
		xor 	ebx, ebx
		xor 	edx, edx

.loop:
		xor 	eax, eax

		lodsb

		test 	al,al
		jz 		.vege  ; ZF = 0 ?

		cmp 	al, '0'
		jl 		.hiba

		cmp		al, 'f'
		jg 		.hiba

		cmp 	al, '9'
		jle 	.szam

		cmp 	al, 'A'
		jl 		.hiba

		cmp 	al, 'F'
		jle		.fbetu

		cmp 	al, 'a'
		jl 		.hiba

		mov 	ecx, ebx
		shr 	ecx, 28

		and 	ecx, edi
		shl 	edx, 4

		or	 	edx, ecx
		shl 	ebx, 4

		sub 	eax, 'a'
		add 	eax, 10
		add 	ebx, eax
		jmp 	.loop

.fbetu:
		sub 	al, 'A'
		add 	al,10

		mov 	ecx,ebx
		shr 	ecx,28

		and 	ecx, edi
		shl 	edx,4

		add 	edx, ecx
		shl 	ebx,4

		add 	ebx, eax
		jmp 	.loop

.szam:
		sub 	al, '0'
		mov 	ecx, ebx
		shr 	ecx,28

		and 	ecx, edi
		shl 	edx,4

		add 	edx, ecx
		shl 	ebx,4

		add 	ebx, eax
		jmp 	.loop

.hiba:
		pop 	edi
		pop 	edx
		pop 	ecx

		stc
		ret

.vege:
		mov 	eax,ebx

		pop 	edi
		pop		ebx
		pop 	ecx

		clc
		ret

WriteHex64:
		pusha ; altalanos regisztereket elmentem

		xchg 	edx,eax
		call 	WriteHex
		mov 	ecx, 8

.loop:
		mov 	eax, 15
		rol 	edx, 4 ; balra forgat 4-vel
		and 	eax, edx

		cmp 	al, 10
		jl 		.kicsi

		add 	al, 'A'
		sub 	al, 10
		jmp 	.ugras

.kicsi:
		add 	al, '0'

.ugras:
		call 	mio_writechar
		loop 	.loop

.vege:
		popa
		ret

ReadBin64:
		push 	esi
		push 	ecx
		push 	ebx
		push 	edi

		mov 	edi, a
		mov 	ecx, 255
		call	ReadStr
		mov 	esi, a
		xor 		ebx, ebx	;EBX-be kerul eloszor az also 32 bit, majd atrakjuk EAX-ba
		xor 		edx, edx

		mov 	ecx, 64

.ciklus:
		cmp 	ecx, 0
		je 		.hiba
		dec 		ecx

		xor 		eax, eax

		lodsb

		cmp 	al, 0
		je 		.vege

		cmp 	al, '0'
		jl			.hiba

		cmp 	al, '1'
		jg 		.hiba

		sub 		eax,'0'
		shl 		edx,1
		shl 		ebx,1
		adc 		edx,0
		add 		ebx, eax
		jmp 		.ciklus

.hiba:
		mov 	edi, 1

.vege:
		mov 	eax, ebx

		clc ; feltetelezem hogy hiba nem volt
		cmp		edi, 1
		jne 	.ki_verem
		stc ; volt hiba. CF <-- 1

.ki_verem:
		pop 	edi
		pop 	ebx
		pop 	ecx
		pop 	esi

		ret

WriteBin64:
		push	eax
		push 	ebx
		push 	ecx
		push 	edx
		push 	edi

		mov 	[bin64], eax
		mov 	ebx, edx			;EBX-el dolgozok

		xor 	edi, edi
		mov 	edi, 2

.ciklus:
		cmp 	edi, 0
		je 		.vege
		mov 	ecx, 32				;ECX-el szamolok

.bit_move:
		mov		al,'1'
		sal		ebx, 1		; balra tol
		jc 		.kiir				;ha 1 lesz, akkor az al-ben is 1 lesz es ugrunk a kiirashoz
		mov 	al, '0'				;CF 0 volt

.kiir:
		call	mio_writechar
		dec		ecx					;csokken az ECX

		cmp 	ecx, 0				;vege?
		jnz 	.bit_move
		dec 	edi
		mov 	ebx, [bin64]
		jmp 	.ciklus

.vege:
		pop 	edi
		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	eax
		ret

section .bss
	a resb 256
	str_decimalis64 resb 256
	seged resb 32

section .data
	bin64 dd 0
