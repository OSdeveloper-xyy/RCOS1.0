nasm -f bin setup.asm -o setup.bin

nasm -f bin Load.asm -o Load.bin

nasm -f bin LOGO.asm -o LOGO.bin

nasm -f win32 KERNEL.asm -o KERNEL.o
gcc -m32 -c KERNEL.c -o KERNEL.obj -ffreestanding -fno-builtin
gcc -m32 KERNEL.obj KERNEL.o -o KERNEL.exe -nostdlib -e _kernel_main
objcopy -I pe-i386 --set-start=0x20000 -O binary -j .text KERNEL.exe KERNEL.bin

del KERNEL.o
del KERNEL.obj
del KERNEL.exe
pause