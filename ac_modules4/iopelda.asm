;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_4a_32/64
;Az előző három eljárásgyűteményhez készítsünk (a megfelelő, megértést segítő szövegeket is tartalmazó!) példaprogramot, a következők szerint:
;IOPELDA.ASM (actest-ben L4a)
;Minden beolvasás előtt ki kell írni, hogy milyen számrendszerben kérjük a számot, kiíratásnál meg kell jelenjen, hogy milyen számrendszerben írattuk ki az aktuális sorban. Ellenőrizzük a határeseteket és a nagy értékeket is, egyik próba a 2.000.000.000.000 lesz.

;    -beolvas egy előjeles 32 bites egész számot 10-es számrendszerben;
;    -kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;    -beolvas egy 32 bites hexa számot;
;    -kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;    -beolvas egy 32 bites bináris számot;
;    -kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;    -kiírja a három beolvasott érték összegét 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;  ez előző lépéseket elvégzi 64 bites értékekre is.

%include 'mio.inc'
%include 'iostr.inc'
%include 'ionum.inc'

global  main

section .text

Write0x:
	pusha

	mov 	eax, '0'
	call 		mio_writechar
	mov 	eax, 'x'
	call 		mio_writechar

  popa
	ret

main:

; 32-bit

.hiba:
    mov   esi,uzenet1
    call  WriteStr
    mov   ecx, 255 ; max hossz amekkora lehet a karlanc
    call	ReadInt
    jnc		.nem_hiba
    mov   esi,uzenet_hiba
    call  WriteLnStr
    jmp		.hiba
.nem_hiba:

    mov   [osz1], ebx ; az elso szamom amely az osszegbe kerul, elmentem
    mov   eax,ebx
    mov   [var_a],eax

    mov   esi,uzenet1
    call  WriteStr
    mov   eax, [var_a]
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  Write0x
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin
    call  NewLine

.hiba_hex:
    mov   esi,uzenet2
    call  WriteStr
    mov   ecx,255 ; max hossz amekkora lehet a karlanc
    call	ReadHex
    jnc		.nem_hiba_hex
    call  NewLine
    mov   esi,uzenet_hiba
    call  WriteLnStr
    jmp		.hiba_hex
.nem_hiba_hex:

    mov   [var_a],ebx
    mov   [osz2], ebx

    call  NewLine
    mov   esi,uzenet1
    call  WriteStr
    mov   eax, [var_a]
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  Write0x
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin

.hiba_bin:
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    mov   ecx,255 ; max hossz amekkora lehet a karlanc
    call	ReadBin
    jnc		.nem_hiba_bin
    call  NewLine
    mov   esi,uzenet_hiba
    call  WriteStr
    jmp		.hiba_bin
.nem_hiba_bin:

    mov   [var_a],eax
    mov   [osz3], ebx

    call  NewLine
    mov   esi,uzenet1
    call  WriteStr
    mov   eax,[var_a]
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  Write0x
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin
    call  NewLine

    ;osszeg kiiratas
    mov   esi,uzenet4
    call  WriteStr
    call  NewLine

    xor   eax,eax
    xor   edx,edx
    mov   eax,[osz1]
    add   [osszeg],eax

    mov   eax,[osz2]
    add   [osszeg],eax

    mov   eax,[osz3]
    add   [osszeg],eax

    mov   esi,uzenet1
    call  WriteStr

    mov   eax,[osszeg]
    mov   ebx,[osszeg]
    call  WriteInt

    mov   esi,uzenet2
    call  WriteStr

    call  Write0x
    call  WriteHex
    call  NewLine

    mov   esi,uzenet3
    call  WriteStr

    call  WriteBin
    call  NewLine

; 64-bit

    xor 		eax, eax
  	xor 		ebx, ebx
  	xor 		ecx, ecx
  	xor 		edx, edx

    ; INT read
    mov   esi,uzenet1
    call  WriteStr
    call  ReadInt64

    mov 	[e_d],edx
    mov   [e_a],eax

    call  NewLine
    mov   esi,uzenet1
    call  WriteStr
    call  WriteInt64
    call  NewLine
    mov 	esi, uzenet2
  	call 	WriteStr
  	call 	Write0x
  	call 	WriteHex64
  	call 	NewLine
    mov 	esi, uzenet3
  	call 	WriteStr
  	call 	WriteBin64
  	call 	NewLine

    ; HEX read
    mov   esi, uzenet2
    call  WriteStr
    call  ReadHex64

    xor   ecx,ecx
    add		[e_a],eax
    adc 	ecx,0
    add 	ecx,edx
    mov   [e_d],ecx

    call  NewLine
    mov   esi, uzenet1
    call  WriteStr
    call  WriteInt64
    call  NewLine
    mov 	esi, uzenet2
  	call 	WriteStr
  	call 	Write0x
  	call 	WriteHex64
  	call 	NewLine
    mov 	esi, uzenet3
  	call 	WriteStr
  	call 	WriteBin64
  	call 	NewLine

    ; BIN read
    mov 	esi, uzenet3
  	call 	WriteStr
  	call 	ReadBin64

    xor   ecx,ecx
    add		[e_a],eax
    adc 	ecx,0
    add 	ecx,edx
    mov   [e_d],ecx

  	call 	NewLine
  	mov 	esi, uzenet1
  	call 	WriteStr
  	call 	WriteInt64
  	call 	NewLine
    mov 	esi, uzenet2
  	call 	WriteStr
    call  Write0x
  	call 	WriteHex64
  	call 	NewLine
    mov 	esi, uzenet3
  	call 	WriteStr
  	call 	WriteBin64
  	call 	NewLine

    mov 	esi, uzenet4
  	call 	WriteStr
    call  NewLine
    mov   edx,[e_d]
    mov   eax,[e_a]

    mov 	esi, uzenet1
  	call 	WriteStr
  	call 	WriteInt64
  	call 	NewLine
    mov 	esi, uzenet2
  	call 	WriteStr
    call  Write0x
  	call 	WriteHex64
  	call 	NewLine
    mov 	esi, uzenet3
  	call 	WriteStr
  	call 	WriteBin64
  	call 	NewLine

    ret

section .bss
  a resb 256

section .data
  var_a dd 0
  osz1 dd 0 ; az elso szam amelyiket osszeadom
  osz2 dd 0 ; a masodik szam amelyiket osszeadom
  osz3 dd 0 ; a harmadik szam amelyiket osszeadom
  osszeg dd 0
  e_a dd 0
  e_d dd 0
  uzenet1 db '10-es szamrendszerben: ', 0
  uzenet2 db '16-os szamrendszerben: ', 0
  uzenet3 db '2-es szamrendszerben: ', 0
  uzenet4 db 'Az osszeguk:', 0
  uzenet_hiba db 'Hiba', 0
