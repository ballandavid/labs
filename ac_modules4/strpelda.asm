;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L4_4b
;A stringek olvasását egyszerre lehet bemutatni a stringeken végzett műveletekkel.
;Mindkét stringnek kiírjuk a hosszát, kompaktált formáját, majd a kompaktált formát kis betűkre alakítva és nagy betűkre alakítva.
;Végül hozzáfűzzük az első string nagybetűs verziójához a második string kisbetűs verzióját és kiírjuk a hosszával együtt.

;    megfelelő üzenet kiíratása után beolvasunk egy stringet;
;    kiírjuk a hosszát;
;    kiírjuk a tömörített formáját;
;    kiírjuk a tömörített formáját kisbetűkre alakítva;
;    megfelelő üzenet kiíratása után beolvasunk egy második stringet;
;    kiírjuk a hosszát;
;    kiírjuk a tömörített formáját;
;    kiírjuk a tömörített formáját nagybetűkre alakítva;
;    létrehozunk a memóriában egy új stringet: az első string nagybetűs verziójához hozzáfűzzük a második string kisbetűs verzióját;
;    kiírjuk a létrehozott stringet;
;    kiírjuk a létrehozott string hosszát;
;    befejezzük a programot.

%include 'mio.inc'
%include 'iostr.inc'
%include 'strings.inc'
%include 'ionum.inc'

global main

section .text

main:
  mov   eax,uzenet1
  call  mio_writestr

  mov   edi,a
  mov   ecx,255
  call  ReadLnStr

  mov   esi,a
  call  StrLen

  call  WriteInt

  mov   esi,a
  call  StrCompact

  mov   esi,edi
  call  WriteStr

  call  NewLine

  mov   esi,edi
  call  StrLower

  call  WriteStr

  call  NewLine

  mov   eax,uzenet2
  call  mio_writestr

  mov   edi,b
  mov   ecx,255
  call  ReadLnStr

  mov   esi,b
  call  StrLen

  call  WriteInt

  mov   esi,b
  call  StrCompact

  mov   esi,edi
  call  WriteStr

  call  NewLine

  mov   esi,edi
  call  StrUpper

  call  WriteStr

  call  NewLine

  mov   esi,a
  call  StrUpper

  mov   esi,b
  call  StrLower

  mov   edi,c
  mov   esi,a
  call  StrCat

  mov   edi,c
  mov   esi,b
  call  StrCat

  mov   esi,c
  call  WriteLnStr

  mov   esi,c
  call  StrLen

  call  WriteInt

  ret

section .bss
  a resb 256
  b resb 256
  c resb 256

section .data
  uzenet1 db 'A = ', 0
  uzenet2 db 'B = ', 0
