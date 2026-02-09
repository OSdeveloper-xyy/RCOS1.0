org 0x6000
bits 32
section .text
_jmp_main:  
    mov ax,0x18
    mov ss,ax
    xor esp,esp
    mov ax,0x10
    mov ds,ax
    mov es,ax
    call _idt_init
    call _paging_init
    call _load_logo
    call _load_kernel
    jmp 0x8:0x20000
    call _error
_default_int:
    iret
_HARDDISK:
    cmp ah,0x00
    je _HDREAD
    cmp ah,0x01
    je _HDWRITE
    iret
_HDREAD:;读硬盘扇区
    mov ebp,ebx
    ;初始化
    mov dx, 0x1F1 
    mov al, 0x00 
    out dx, al 
    out dx, al
    ;设置扇区数
    mov dx,0x1f2
    mov al,bh;扇区数高8位
    out dx,al
    mov dx,0x1f2
    mov al,bl;扇区数低8位
    out dx,al
    ;设置起始扇区号,第一轮
    mov ebx,esi
    mov dx,0x1f3
    mov al,bl;0-7位
    out dx,al
    inc dx
    mov al,bh;8-15位
    out dx,al
    shr ebx,16
    inc dx
    mov al,bl;16-23位
    out dx,al
    ;设置起始扇区号,第二轮
    mov ebx,esi
    shr ebx,16
    mov dx,0x1f3
    mov al,bh;24-31位
    out dx,al
    inc dx
    mov al,0x00;32-39位(不用)
    out dx,al
    inc dx
    mov al,0x00;40-47位(不用)
    out dx,al
    ;LBA模式,主硬盘
    mov dx,0x1f6
    mov al,0x40
    out dx,al
    ;读扇区命令
    mov dx,0x1f7
    mov al,0x24
    out dx,al
    ;等待硬盘准备
_WAITFORHD:
    mov dx,0x1f7
    in al,dx
    test al,0x08
    jz _WAITFORHD
    mov ecx,ebp
    shl ecx,8
    jmp _READHD
_READHD:
    mov dx,0x1f0
    in ax,dx
    mov [edi],ax
    add edi,2
    loop _READHD
    iret
_HDWRITE:
_VIDEO:
    cmp ah,0x01
    je _VIDEOWRITE
    iret
_VIDEOWRITE:

_KEYBOARD:
_idt_init:
    call _8529A

    mov ebp,0x2000
    mov eax,_default_int
    mov edx,22
    mov ecx,22
    call _set_idt

    mov edi,0x20B0
    mov ecx,80
    mov al,0x00
    rep stosb

    mov eax,_HARDDISK
    mov word [0x2100],ax
    mov word [0x2102],0x10
    shr eax,16
    mov word [0x2104],0x8E00
    mov word [0x2106],ax

    mov eax,_VIDEO
    mov word [0x2108],ax
    mov word [0x210A],0x10
    shr eax,16
    mov word [0x210C],0x8E00
    mov word [0x210E],ax

    mov eax,_KEYBOARD
    mov word [0x2110],ax
    mov word [0x2112],0x10
    shr eax,16
    mov word [0x2114],0x8E00
    mov word [0x2116],ax    

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
    sub edx,ecx
    imul edx,3
    add edi,edx
    mov word [edi],ax
    add edi,2
    mov word [edi],0x10
    shr eax,16
    add edi,2
    mov word [edi],0x8E00
    add edi,2
    mov word [edi],ax
    loop _set_idt
    ret
_load_kernel:
    mov ah,0x00
    mov ebx,0x00000200
    mov edi,0x00020000
    mov esi,0x0012C000
    int 0x20
    ret
_paging_init:
    mov ecx,1024
    call _set_pd
    mov eax,0x00160000
    mov cr3, eax
    cli
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    ret
_set_pd:
    mov eax,1025
    sub eax,ecx
    mov edi,eax
    imul eax,0x1000
    add eax,0x00160003
    sub edi,1
    shl edi,2
    add edi,0x00160000
    mov dword [edi],eax
    push ecx
    mov ecx,1024
    call _set_pte
    pop ecx
    loop _set_pd
    ret
_set_pte:
    mov ebx,1024
    sub ebx,ecx
    mov edi,ebx
    mov ebp,edi
    imul ebp,0x400000
    imul ebx,0x1000
    add ebx,ebp
    or ebx,0x00000003
    shl edi,2
    add ebp,eax
    mov dword [edi],ebx
    loop _set_pte
    ret
idtr_inf:
    dw 0x07FF
    dd 0x00002000
_load_logo:
    mov ah,0x00
    mov ebx,0x00001200
    mov edi,0x000A0000
    mov esi,0x0012C208
    int 0x20
    ret
_error:
    mov ah,0x00
    mov ebx,0x00001200
    mov edi,0x000A0000
    mov esi,0x0012D410
    int 0x20
    in al,0x64
    test al,1
    jz _error
    in al, 0x60
    ret
times 8192 - ($ - $$) db 0