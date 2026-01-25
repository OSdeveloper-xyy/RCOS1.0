nasm -f bin setup.asm -o setup.bin
nasm -f bin Load.asm -o Load.bin
nasm -f win32 LOGO.asm -o LOGO.o
gcc -m32 -c LOGO.c -o LOGO.obj -ffreestanding -fno-builtin
gcc -m32 LOGO.obj LOGO.o -o LOGO.exe -nostdlib -e _jmp_main
objcopy -I pe-i386 --set-start=0x6000 -O binary -j .text LOGO.exe LOGO.bin
del LOGO.o
del LOGO.obj
del LOGO.exe
pause