;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_4a
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
;    -ez előző lépéseket elvégzi 64 bites értékekre is.

%include 'mio.inc'
%include 'iostr.inc'
%include 'ionum.inc'

global  main

section .text
main:
.hiba:
    mov   esi,uzenet1
    call  WriteStr
    call	ReadInt
    jnc		.nem_hiba
    jmp		.hiba
.nem_hiba:

    mov   esi,uzenet1
    call  WriteStr
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin
    call  NewLine

.hiba_hex:
    mov   esi,uzenet2
    call  WriteStr
    call	ReadHex
    jnc		.nem_hiba_hex
    jmp		.hiba_hex
.nem_hiba_hex:

    call  NewLine
    mov   esi,uzenet1
    call  WriteStr
    mov   ebx,eax
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin
    call  NewLine

.hiba_bin:
    mov   esi,uzenet3
    call  WriteStr
    call	ReadBin
    jnc		.nem_hiba_bin
    jmp		.hiba_bin
.nem_hiba_bin:

    call  NewLine
    mov   esi,uzenet1
    call  WriteStr
    call  WriteInt
    mov   esi,uzenet2
    call  WriteStr
    call  WriteHex
    call  NewLine
    mov   esi,uzenet3
    call  WriteStr
    call  WriteBin
    call  NewLine

    ret

section .bss
  a resb 256

section .data
  uzenet1 db '10-es szamrendszerben: ', 0
  uzenet2 db '16-os szamrendszerben: ', 0
  uzenet3 db '2-es szamrendszerben: ', 0
