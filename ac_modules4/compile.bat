nasm -f win32 ionum.asm
nasm -f win32 iostr.asm
nasm -f win32 iopelda.asm
nlink ionum.obj iostr.obj iopelda.obj -lmio -o iopelda.exe

iopelda.exe
