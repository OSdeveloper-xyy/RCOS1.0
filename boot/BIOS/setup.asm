bits 16;实模式
org 0x7C00;0x7c00引导扇区的内存地址
section .text
    global _start
_start:
    mov ax,0x1000;设置堆栈段地址
    mov ss,ax
    mov sp,0x0000;设置堆栈顶地址
    mov ax,0x0003;设置为80x25文本模式
    int 0x10
    mov ax,0x0000;初始化段寄存器
    mov ds,ax
    mov es,ax
    mov ax,0x1301;输出字符串
    mov bx, 0x0007
    mov dx, 0x0000
    mov bp,msg1
    mov cx,17
    int 0x10
_move:
    ;从硬盘读取Load部分到内存0x4000处
    mov dx,0x0080
    mov cx,0x0002
    mov bx,0x4000
    mov ax,0x0208
    int 0x13
    jnc _jamp
    jc _error
_jamp:
    mov ax,0x1301;输出字符串
    mov bx,0x0002
    mov dx,0x0100
    mov bp,msg3
    mov cx,13
    int 0x10
    jmp 0x0400:0x0000;跳转到Load部分执行
_error:
    ;错误处理
    mov ax,0x1301
    mov bx,0x0004
    mov dx,0x0100
    mov bp,msg2
    mov cx,13
    int 0x10
    jmp $
msg1 db 'Loading system...'
msg2 db 'Load error!!!'
msg3 db 'Load succeed!'
times 0x1BE - ($ - $$) db 0
db 0x00,0x20,0x21,0x00,0xEF,0x1E,0x2B,0x33,0x00,0x08,0x00,0x00,0x00,0x80,0x0C,0x00;分区表
times 510 - ($ - $$) db 0
dw 0xAA55;引导扇区标志