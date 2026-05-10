nasm -f bin setup.asm -o setup.bin

nasm -f bin KERNEL.asm -o KERNEL.bin

nasm -f bin CMD.asm -o CMD.bin

pause
exit

nasm -f win32 KERNEL.asm -o KERNEL.o
gcc -m32 -c KERNEL.c -o KERNEL.obj -ffreestanding -fno-builtin -O0 -nostdlib -nostartfiles
gcc -m32 KERNEL.o KERNEL.obj -o KERNEL.exe -ffreestanding -fno-builtin -O0 -nostdlib -nostartfiles -e _ready
objcopy -I pe-i386 -O binary -j .text KERNEL.exe KERNEL.bin

del KERNEL.obj
del KERNEL.o
del KERNEL.exe

pause