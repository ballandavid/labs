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
%include 'iostr.inc'

global ReadInt
global WriteInt
global ReadBin
global WriteBin
global ReadHex
global WriteHex
global ReadInt64
global WriteInt64

section .text

ReadInt:
xor		eax, eax ;lenullazom eax-et
xor		ebx, ebx ;lenullazom ebx-et
xor		ecx,ecx
mov		edx,1

mov		ecx,255
mov		edi,a
call	ReadStr

mov		esi,a
xor		edi,edi

lodsb

cmp		al,'-'
jne		.pozitiv
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
neg		ebx

.ugras:

call NewLine

cmp		edi,1
je		.ugras1
clc
ret

.ugras1:
stc
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

			;mov		ebx,eax

			xor		eax, eax
			xor		ecx, ecx
			mov		eax, ebx
			mov		ebx, 16		;16-val fogom osztani a szamom amig nem 0
			push	dword -1


			.ciklus1:
				xor 	edx, edx
				div	ebx

				push	edx
				inc 	ecx
				test	eax, eax
				cmp		eax, 0
				jne		.ciklus1

			mov		eax,'0'
			call	mio_writechar
			mov		eax,'x'
			call	mio_writechar

			mov		ebx,8		;1 byte-bol kell kivonjam hany osztas volt
			sub		ebx,ecx		;ebx-be megkapom (8 - hany osztas)om volt
			mov		ecx,ebx		;beteszem az ecx-be hogy annyiszor vegezzem el a ciklust

			cmp		ecx,0
			je		.ugor

			mov		eax,'0'		;0-kat irok ki a szamom ele
			.ciklus_nullak:
				call	mio_writechar
				dec		ecx

				cmp		ecx,0
				jg	.ciklus_nullak	;ecx-szer kiirom a 0-t a hexa szam ele

			.ugor:

			.ciklus2:
				xor		eax,eax
				pop		eax				; sorban kiveszem a verembol s megnezem ha 10 es 15 kozott van-e a szamom
				cmp		eax, -1		;veszem az elemeket amig nem ures a verem
				je		.vege

				cmp		eax,10
				je		.plusz_ertek_A

				cmp		eax,11
				je		.plusz_ertek_B

				cmp		eax,12
				je		.plusz_ertek_C

				cmp		eax,13
				je		.plusz_ertek_D

				cmp		eax,14
				je		.plusz_ertek_E

				cmp		eax,15
				je		.plusz_ertek_F

				add		eax,'0'		;megkapom az eax szambeli erteket

				.vissza:

				call	mio_writechar
				jmp		.ciklus2

			.plusz_ertek_A:
				xor		eax,eax
				mov		eax,'A'
				jmp		.vissza

			.plusz_ertek_B:
				xor		eax,eax
				mov		eax,'B'
				jmp		.vissza

			.plusz_ertek_C:
				xor		eax,eax
				mov		eax,'C'
				jmp		.vissza

			.plusz_ertek_D:
				xor		eax,eax
				mov		eax,'D'
				jmp		.vissza

			.plusz_ertek_E:
				xor		eax,eax
				mov		eax,'E'
				jmp		.vissza

			.plusz_ertek_F:
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

		;dec		ecx
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

		;cmp		ecx,223
		;je		.jump
		;mov		edi,1

;.jump:

		cmp		edi,1
		jne		.ugras
		stc
		ret

.ugras:
		clc

		ret

WriteBin:
		mov		ecx,32 ;32szer hajtom vegere a kiiratast
		mov		edx,28 ;ha a 28.ik bitnel leszek, kiirok szokozt
		;mov		ebx,eax

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
		jne 		.ciklus

		inc 	esi	;ha negativ tullepunk, majd a vegen lekezeljuk

.ciklus:
		mov 	bl, [esi]
		inc 	esi

		cmp		bl, 0
		je		.ellenorzes
		cmp 	bl, '0'
		jl 		.hiba
		cmp 	bl, '9'
		jg 		.hiba

		sub 		ebx, '0' ; ebx<--szamjegy

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

		.ellenorzes:
		cmp 	edi, 1
		je 		.vegehiba

		mov 	esi, str_decimalis64		;elovesszuk az eredeti stringet, nezzuk ha - volt
		mov 	bl, [esi]
		cmp 	bl, '-'						;ellenorizzuk ha negativ volt a szam
		jne 		.vege
		;negativ:
		not 		eax
		not 		edx
		inc 		eax
		adc 		edx, 0

		.vege:
		pop 		ecx
		pop 		ebx
		clc
		ret

		.vegehiba:
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
			push 		dword-1						;majd a verem vege ellenorzesere

			cmp 		edx,0
			jge 			.ciklus

		;negativ
			mov 		[seged], eax
			mov 		eax, '-'
			call 			mio_writechar
			mov 		eax, [seged]

			not 		eax
			not 		edx
			add 		eax,1
			adc 		edx,0

		.ciklus:
			mov 		ebx,eax					;elmentjuk az also 32 bit-et
			mov			eax,edx					;dolgozunk a felso 32 bit-el

			xor 		edx, edx
			div 		ecx							;elosszuk a felso 32 bit-et (EDX)
			xchg 		eax,ebx					;felcsereljuk

			div 		ecx							;elosszuk az also 32 bit-et (EAX)
			push 		edx							;verembe a maradek
			mov 		edx,ebx					;edx = felso 32 bit-et

			cmp 		edx,0
			je 			.also32

			jmp 		.ciklus

		.also32:
			xor 		edx, edx
			div 		ecx							;elosszuk csak az also 32 bit-et
			push		edx
			test 		eax, eax					;amig 0 nem lesz
			jnz 		.also32


		.verem:
			pop 		eax
			cmp			eax, -1
			je 			.vege
			add 		eax, '0'
			call 		mio_writechar
			jmp 		.verem

		.vege:
			pop 		edx
			pop 		eax
			pop 		ecx
			pop 		ebx
			ret

;main:
;.hiba:
;	call	ReadInt
;	jnc		.nem_hiba
;	jmp		.hiba
;.nem_hiba:
;
;	call	WriteInt

;.hiba_hex:
;	call	ReadHex
;	jnc		.nem_hiba_hex
;	call	NewLine
;	jmp		.hiba_hex
;.nem_hiba_hex:

;	call	NewLine

;	call	WriteHex

;	call	NewLine

;	call	ReadBin

;	call	NewLine

;	call	WriteBin

;	call	NewLine

;	ret

section .bss
	a resb 256
	str_decimalis64 resb 256
	seged resb 32
