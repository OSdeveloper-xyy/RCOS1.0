org 0x4000
bits 16
section .text
    global setup
setup:
    mov ax,0x0000
    mov ds,ax
    mov es,ax
    mov ax,0x1301
    mov bx, 0x0007
    mov dx, 0x0200
    mov bp,msg1
    mov cx,27
    int 0x10
move:
    mov dx,0x0080
    mov cx,0x000A
    mov bx,0x6000
    mov ax,0x0240
    int 0x13
    jnc get_inf
    jc _error
get_inf:
    mov ax,0xB828
    mov es,ax
    mov dword [es:0],0x07200720
    mov dword [es:4],0x07200725
    mov dword [es:160],0x07200720
    mov dword [es:164],0x0720075B
    mov dword [es:196],0x075D0720
    mov ah,0x0F
    int 0x10
    mov [0x3000],al
    mov word [es:6],0x0739
    mov word [es:166],0x073D
    mov word [es:168],0x073D
    mov ah,0x12
    mov bl,0x10
    int 0x10
    mov [0x3001],bh
    mov [0x3002],bl
    mov [0x3003],ah
    mov byte [es:6],0x32
    mov word [es:8],0x0734
    mov word [es:170],0x073D
    mov word [es:172],0x073D
    mov ah,0x03
    int 0x10
    mov [0x3004],dh
    mov [0x3005],dl
    mov [0x3006],ch
    mov [0x3007],cl
    mov byte [es:6],0x34
    mov byte [es:8],0x35
    mov word [es:174],0x073D
    mov word [es:176],0x073D
    mov ax,0xE801
    int 0x15
    mov [0x3008],ax
    mov [0x300A],bx
    mov [0x300C],cx
    mov [0x300E],dx
    mov byte [es:6],0x37
    mov byte [es:8],0x38
    mov word [es:178],0x073D
    mov word [es:180],0x073D
    mov ah,0x02
    int 0x16
    mov [0x300F],al
    mov byte [es:6],0x39
    mov byte [es:8],0x34
    mov dword [es:182],0x073D073D
    mov dword [es:186],0x073D073D
    mov ah,0x08
    int 0x13
    mov [0x3010],dl
    mov [0x3011],dh
    mov [0x3012],ch
    mov [0x3013],cl
    mov byte [es:6],0x31
    mov byte [es:8],0x30
    mov word [es:10],0x0730
    mov dword [es:190],0x073D073D
    mov dword [es:194],0x073D073D
    mov ax,0x0000
    mov ds,ax
    mov es,ax
    mov ax,0x1301
    mov bx, 0x0002
    mov dx, 0x0300
    mov bp,msg3
    mov cx,24
    int 0x10
    mov bx,0x0005
    mov dx,0x0600
    mov bp,msg4
    mov cx,28
    int 0x10
    mov ah, 0x00
    int 0x16
a20:
    in al,0x92
    or al,2
    out 0x92,al
idt_init:
    lidt [idtr_inf]
gdt_init: 
    mov ax,0x1000
    mov es,ax
    mov dword [es:0],0x00000000
    mov dword [es:4],0x00000000
    mov dword [es:8],0x0000FFFF
    mov dword [es:12],0x00CF9A00
    mov dword [es:16],0x0000FFFF
    mov dword [es:20],0x00CF9200
    lgdt [gdtr_inf]
set_vbe:
    mov ax, 0x4F01
    mov cx, 0x105
    mov di, mode_info
    int 0x10
    mov dword [mode_info+0x28],0xC0000000
    mov ax, 0x4F02
    mov bx, 0x4105
    mov di, mode_info
    int 0x10
    cmp ax, 0x004F
    jne _error
    jnc _protect_mode
_protect_mode:
    cli
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x8:0x6000
idtr_inf:
    dw 0x07FF
    dd 0x00006000
gdtr_inf:
    dw 0x00FF
    dd 0x00001000
_error:
    mov ax,0x0000
    mov ds,ax
    mov es,ax
    mov ax,0x1301
    mov bx, 0x0004
    mov dx, 0x0300
    mov bp,msg2
    mov cx,13
    int 0x10
    jmp $
msg1 db 'Load and get information...'
msg2 db 'Load error!!!'
msg3 db 'Get information succeed!'
msg4 db 'Press any key to continue...'
mode_info times 256 db 0