bits 32
section .text
    extern _C
    global __main
    global _idt_init
    global _paging_enable
    global _load_logo
    global _jmp_main
_jmp_main:
    lss esp,[stark_inf]
    call _C
__main:
    ret
_DE:
    pushad
    cli
    call _error
    popad
    iret
_DB:
_NMI:
_BP:
_OF:
_BR:
_UD:
_NM:
_DF:
_TS:
_NP:
_SS:
_GP:
_PF:
_MF:
_AC:
_MC:
_XM:
_VE:
_CP:
_HARDDISK:
    cmp ah,0x00
    je _HDREAD
    cmp ah,0x01
    je _HDWRITE
    iret
_HDREAD: ;读硬盘扇区
    mov edi,ebx
    ;设置扇区数
    mov dx,0x1f2
    mov al,bh;扇区数高8位
    out dx,al
    mov dx,0x1f2
    mov al,bl;扇区数低8位
    out dx,al
    ;设置起始扇区号,第一轮
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
    ;设置起始扇区号,第二轮
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
    jmp _READHD
_READHD:
    mov ebx,edi
    shl ebx,9
    mov dx,0x1f0
    in ax,dx
    mov [ecx],ax
    add ecx,2
    sub ebx,2
    cmp ebx,0
    jne _READHD
    iret
_HDWRITE:
_VIDEO:
_KEYBOARD:
_idt_init:
    lea eax,_DE
    add eax,0x8000
    mov word [0x2000],ax
    mov word [0x2002],0x10
    shr eax,16
    mov word [0x2004],0x8E00
    mov word [0x2006],ax

    lea eax,_DB
    add eax,0x8000
    mov word [0x2008],ax
    mov word [0x200A],0x10
    shr eax,16
    mov word [0x200C],0x8E00
    mov word [0x200E],ax

    lea eax,_NMI
    add eax,0x8000
    mov word [0x2010],ax
    mov word [0x2012],0x10
    shr eax,16
    mov word [0x2014],0x8E00
    mov word [0x2016],ax

    lea eax,_BP
    add eax,0x8000
    mov word [0x2018],ax
    mov word [0x201A],0x10
    shr eax,16
    mov word [0x201C],0x8E00
    mov word [0x201E],ax

    lea eax,_OF
    add eax,0x8000
    mov word [0x2020],ax
    mov word [0x2022],0x10
    shr eax,16
    mov word [0x2024],0x8E00
    mov word [0x2026],ax

    lea eax,_BR
    add eax,0x8000
    mov word [0x2028],ax
    mov word [0x202A],0x10
    shr eax,16
    mov word [0x202C],0x8E00
    mov word [0x202E],ax

    lea eax,_UD
    add eax,0x8000
    mov word [0x2030],ax
    mov word [0x2032],0x10
    shr eax,16
    mov word [0x2034],0x8E00
    mov word [0x2036],ax

    lea eax,_NM
    add eax,0x8000
    mov word [0x2038],ax
    mov word [0x203A],0x10
    shr eax,16
    mov word [0x203C],0x8E00
    mov word [0x203E],ax

    lea eax,_DF
    add eax,0x8000
    mov word [0x2040],ax
    mov word [0x2042],0x10
    shr eax,16
    mov word [0x2044],0x8E00
    mov word [0x2046],ax

    mov dword [0x2048],0x00000000
    mov dword [0x204C],0x00000000

    lea eax,_TS
    add eax,0x8000
    mov word [0x2050],ax
    mov word [0x2052],0x10
    shr eax,16
    mov word [0x2054],0x8E00
    mov word [0x2056],ax

    lea eax,_NP
    add eax,0x8000
    mov word [0x2058],ax
    mov word [0x205A],0x10
    shr eax,16
    mov word [0x205C],0x8E00
    mov word [0x205E],ax

    lea eax,_SS
    add eax,0x8000
    mov word [0x2060],ax
    mov word [0x2062],0x10
    shr eax,16
    mov word [0x2064],0x8E00
    mov word [0x2066],ax

    lea eax,_GP
    add eax,0x8000
    mov word [0x2068],ax
    mov word [0x206A],0x10
    shr eax,16
    mov word [0x206C],0x8E00
    mov word [0x206E],ax

    lea eax,_PF
    add eax,0x8000
    mov word [0x2070],ax
    mov word [0x2072],0x10
    shr eax,16
    mov word [0x2074],0x8E00
    mov word [0x2076],ax

    mov dword [0x2078],0x00000000
    mov dword [0x207C],0x00000000

    lea eax,_MF
    add eax,0x8000
    mov word [0x2080],ax
    mov word [0x2082],0x10
    shr eax,16
    mov word [0x2084],0x8E00
    mov word [0x2086],ax

    lea eax,_AC
    add eax,0x8000
    mov word [0x2088],ax
    mov word [0x208A],0x10
    shr eax,16
    mov word [0x208C],0x8E00
    mov word [0x208E],ax

    lea eax,_MC
    add eax,0x8000
    mov word [0x2090],ax
    mov word [0x2092],0x10
    shr eax,16
    mov word [0x2094],0x8E00
    mov word [0x2096],ax

    lea eax,_XM
    add eax,0x8000
    mov word [0x2098],ax
    mov word [0x209A],0x10
    shr eax,16
    mov word [0x209C],0x8E00
    mov word [0x209E],ax

    lea eax,_VE
    add eax,0x8000
    mov word [0x20A0],ax
    mov word [0x20A2],0x10
    shr eax,16
    mov word [0x20A4],0x8E00
    mov word [0x20A6],ax
    lea eax,_CP
    add eax,0x8000
    mov word [0x20A8],ax
    mov word [0x20AA],0x10
    shr eax,16
    mov word [0x20AC],0x8E00
    mov word [0x20AE],ax

    mov ax,0x10
    mov es,ax
    mov edi,0x20AC
    mov ecx,80
    mov al, 0x00
    rep stosb

    lea eax,_HARDDISK
    add eax,0x8000
    mov word [0x2100],ax
    mov word [0x2102],0x10
    shr eax,16
    mov word [0x2104],0x8E00
    mov word [0x2106],ax

    lidt [idtr_inf]
    ret
_paging_enable:
    mov eax,0x00060000
    mov cr3, eax
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    ret
idtr_inf:
    dw 0x07FF
    dd 0x00002000
stark_inf:
    dd 0xA0000000  ;  
    dd 0x10
_load_logo:
    mov ah,0x00
    mov ebx,0x00001200
    mov ecx,0xC0000000
    mov esi,0x0012C208
    int 0x20
_error:
    mov ah,0x00
    mov ebx,0x00001200
    mov ecx,0xC0000000
    mov esi,0x0012D410
    int 0x20
    in al, 0x64
    test al, 1
    jz _error
    in al, 0x60
    ret
times 8192 - ($ - $$) db 0