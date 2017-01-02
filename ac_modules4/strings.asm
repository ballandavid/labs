;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_3
;Készítsük el a következő stringkezelő eljárásokat és helyezzük el őket egy STRINGS.ASM / INC nevű modulba.

;    StrLen(ESI):(EAX)              – EAX-ben visszatéríiti az ESI által jelölt string hosszát, kivéve a bináris 0-t
;    StrCat(EDI, ESI):()             – összefűzi az ESI és EDI által jelölt stringeket (azaz az ESI által jelöltet az EDI után másolja)
;    StrUpper(ESI):()                 – nagybetűssé konvertálja az ESI stringet
;    StrLower(ESI):()                 – kisbetűssé konvertálja az ESI stringet
;    StrCompact(ESI):(EDI)      – EDI-be másolja át az ESI stringet, kivéve a szóköz, tabulátor (9), kocsivissza (13) és soremelés (10) karaktereket

%include 'mio.inc'
%include 'iostr.inc'

global StrLen
global StrCat
global StrUpper
global StrLower
global StrCompact

section .text

StrLen:
  push  esi
  xor   ebx,ebx

.loop:
  lodsb
  cmp al,0
  je .vege
  inc ebx
  jmp  .loop

.vege:
  mov  eax,ebx

  pop   esi
  ret

StrCat:
.loop:
  mov   al,[edi]

  cmp   al,0
  je    .vege

  inc   edi
  jmp   .loop

.vege:
  lodsb
  cmp   al,0
  je    .end
  stosb
  jmp   .vege
.end:
  stosb

  ret

StrUpper:
  push  esi
.loop
  lodsb
  cmp   al,0
  je    .vege
  cmp   al,'a'
  jl    .loop
  cmp   al,'z'
  jg    .loop

  sub   al,32
  dec   esi
  mov   [esi],al
  inc   esi
  jmp   .loop

.vege:
  pop   esi
  ret

StrLower:
  push  esi
.loop
  lodsb
  cmp   al,0
  je    .vege
  cmp   al,'A'
  jl    .loop
  cmp   al,'Z'
  jg    .loop

  add   al,32
  dec   esi
  mov   [esi],al
  inc   esi
  jmp   .loop

.vege:
  pop  esi
  ret

StrCompact:
  push  edi
.loop:
  lodsb
  cmp   al,0
  je    .vege
  cmp   al,' '
  je    .loop
  cmp   al,9
  je    .loop
  cmp   al,13
  je    .loop
  cmp   al,10
  je    .loop

  stosb
  jmp   .loop

.vege:
  pop   edi
  ret

section .bss
  a resb 256
  b resb 256
