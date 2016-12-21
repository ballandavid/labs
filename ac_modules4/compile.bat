nasm -f win32 strings.asm
nlink strings.obj -lmio -o strings.exe

strings.exe
