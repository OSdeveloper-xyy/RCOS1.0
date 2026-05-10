bits 16;实模式
org 0x7C00;0x7c00引导扇区的内存地址
section .text
    global _start
_start:
    mov ax,0x8F00;设置堆栈段地址
    mov ss,ax
    mov sp,0x1000;设置堆栈顶地址
    mov ax,0x0003;设置为80x25文本模式
    int 0x10
    mov ax,0x0000;初始化段寄存器
    mov ds,ax
    mov es,ax
    mov ax,0x1301;输出字符串
    mov bx,0x0007
    mov dx,0x0000
    mov bp,msg1
    mov cx,17
    int 0x10
_move:
    mov dx,0x0080
    mov cx,0x0002
    mov bx,0x8000
    mov ax,0x0208
    int 0x13
gdt_init: 
    mov dword [0x6000],0x00000000
    mov dword [0x6004],0x00000000
    mov dword [0x6008],0x0000FFFF
    mov dword [0x600C],0x00CF9A00
    mov dword [0x6010],0x0000FFFF
    mov dword [0x6014],0x00CF9200
    mov dword [0x6018],0xFFFF00FF
    mov dword [0x601C],0xFFC096FF
    lgdt [gdtr_inf]
a20:
    in al,0x92
    or al,2
    out 0x92,al
_write_inf:
    mov ax,0x1301;输出字符串
    mov bx,0x0002
    mov dx,0x0100
    mov bp,msg3
    mov cx,13
    int 0x10
    mov bx,0x0005
    mov dx,0x0200
    mov bp,msg4
    mov cx,32
    int 0x10
    mov ah,0x00
    int 0x16;等待按键
_protect_mode:
    mov ax,0x0003
    int 0x10
    call _idt_init
    cli
    mov eax, cr0
    add eax,0x1
    mov cr0,eax
    jmp 0x8:0x8000
_error:
    ;错误处理
    mov ax,0x1301
    mov bx,0x0004
    mov dx,0x0100
    mov bp,msg2
    mov cx,13
    int 0x10
    jmp $
_idt_init:
    call _8529A
    mov di,0x6800
    mov ax,_default_int
    mov ecx,32
    mov edx,0
    call _set_idt
    lidt [idtr_inf]
    ret
_8529A:
    mov al,0x11
    out 0x20,al
    mov al,0x20
    out 0x21,al
    mov al,0x04
    out 0x21,al
    mov al,0x01
    out 0x21,al
    mov al,0x11
    out 0xa0,al
    mov al,0x70
    out 0xa1,al
    mov al,0x02
    out 0xa1,al
    mov al,0x01
    out 0xa1,al  
    ret
_set_idt:
    imul dx,3
    add di,dx
    mov word [di],ax
    add di,2
    mov word [di],0x0010
    add di,2
    mov word [di],0x8E00
    add di,2
    mov word [di],0x0000
    add dx,1
    loop _set_idt
    ret
_default_int:
    iret
msg1 db 'Loading system...'
msg2 db 'Load error!!!'
msg3 db 'Load succeed!'
msg4 db 'press any key to start system...'
idtr_inf:
    dw 0x01FF
    dd 0x00006800
gdtr_inf:
    dw 0x007F
    dd 0x00006000
times 0x1BE - ($ - $$) db 0
db 0x00,0x20,0x21,0x00,0xEF,0x1E,0x2B,0x33,0x00,0x08,0x00,0x00,0x00,0x80,0x0C,0x00;分区表
times 510 - ($ - $$) db 0
dw 0xAA55;引导扇区标志