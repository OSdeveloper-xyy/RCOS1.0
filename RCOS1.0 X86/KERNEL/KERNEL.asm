bits 32
org 0x8000
section .text
    global _ready
_ready:
    mov ax,0x0007    ;字符串输出+黑底白字
    mov esi,msg1    ;输出字符串msg1
    mov edi,0x0000  ;0行(第一行)0列
    mov ecx,25      ;25个字符
    call _VIDEO
    mov ax,0x0007
    mov esi,msg4
    mov edi,0x1700
    mov ecx,80
    call _VIDEO
    mov esi,msg2
    mov edi,0x0100
    mov ecx,23
    call _VIDEO
    mov esi,msg3
    mov edi,0x0200
    mov ecx,13
    call _VIDEO
    call _get_time
    mov ax,0x0007
    mov esi,0x5000
    mov edi,0x020D
    mov ecx,19
    call _VIDEO
    call _set_cursor
    call _start_process
    mov dword [0x5090],0x00000300
    jmp _kernel
_kernel:
    mov ecx,1
    call _show_time
    mov eax,_kernel
    push eax
    jmp 0x8:0x12000
    loop _kernel
_start_process:
    mov ah,0x00         ;读磁盘
    mov esi,0x000000009 ;从LBA9开始读
    mov edi,0x12000     ;读到0x12000
    mov ecx,8           ;读8个扇区
    call _HARD_DISK
    ret
_VIDEO:
    cmp ah,0x00
    je _printf
_printf:
    mov edx,edi
    mov ebx,edi
    shr ebx,8
    mov edi,ebx
    imul edi,0xA0
    add edi,0xB8000
    shl ebx,8
    sub edx,ebx
    shl edx,1
    add edi,edx
_video_string_loop:
    mov byte dl,[esi]
    mov byte [edi],dl
    add edi,1
    mov byte [edi],al
    add esi,1
    add edi,1
    loop _video_string_loop
    mov dword [0x5080],edi
    ret
_get_time:
    mov byte [0x5000],0x32
    mov byte [0x5001],0x30

    mov al,0x09
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x5002],bl
    add al,0x30
    mov byte [0x5003],al

    mov byte [0x5004],0x2f

    mov al,0x08
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x5005],bl
    add al,0x30
    mov byte [0x5006],al

    mov byte [0x5007],0x2f

    mov al,0x07
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x5008],bl
    add al,0x30
    mov byte [0x5009],al

    mov byte [0x500A],0x20

    mov al,0x04
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x500B],bl
    add al,0x30
    mov byte [0x500C],al

    mov byte [0x500D],0x3a

    mov al,0x02
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x500E],bl
    add al,0x30
    mov byte [0x500F],al

    mov byte [0x5010],0x3a

    mov al,0x00
    out 0x70,al
    in al,0x71
    mov bl,al
    shr bl,4
    shl bl,4
    sub al,bl
    shr bl,4
    add bl,0x30
    mov byte [0x5011],bl
    add al,0x30
    mov byte [0x5012],al

    ret
_set_cursor:
    mov ebx,[0x5080]
    sub ebx,0xB8000
    shr ebx,1

    mov dx,0x3D4
    mov al,0x0E
    out dx,al
    mov dx,0x3D5
    mov al,bh
    out dx,al

    mov dx,0x3D4
    mov al,0x0F
    out dx,al
    mov dx,0x3D5
    mov al,bl
    out dx,al

    ret
_HARD_DISK:
    cmp ah,0x00
    je _read_hard_disk
_read_hard_disk:
    mov [0x5050],ecx
    call _read_hard_disk_func
    add esi,1           
    mov ecx,[0x5050]
    loop _read_hard_disk
    ret
_read_hard_disk_func:
    mov dx,0x1F2
    mov al,0x01
    out dx,al

    mov eax,esi

    mov dx,0x1F3
    out dx,al

    shr eax,8
    mov dx,0x1F4
    out dx,al

    shr eax,8
    mov dx,0x1F5
    out dx,al

    shr eax,8
    and al,0x0F
    or al,0xE0
    mov dx,0x1F6
    out dx,al

    mov dx,0x1F7
    mov al,0x20
    out dx,al
_waits:
    mov dx,0x1F7
    in al,dx
    and al,0x88
    cmp al,0x08
    jnz _waits
    mov ecx,256
    mov dx,0x1F0
_hd_read_loop:
    in ax,dx
    mov word [edi],ax
    add edi,2
    loop _hd_read_loop
    ret
_show_time:
    call _get_time
    mov al,0x07
    mov esi,0x5000
    mov edi,0x183C
    mov ecx,19
    call _VIDEO
    ret
_error_func:
    mov ax,0x0004
    mov esi,msg5
    mov dword edi,[0x5090]
    mov ecx,18
    call _VIDEO
    ret
msg1 db 'Welcome to RCOS1.0 system'
msg2 db '    version:c_1.0.26504'
msg3 db 'Startup Time:'
msg4 db '________________________________________________________________________________'
msg5 db 'Something error!!!'
times 4096 - ($ - $$) db 0