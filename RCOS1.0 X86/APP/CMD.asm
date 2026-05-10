bits 32
org 0x12000
section .text
    global _code
_code:
    mov dword eax,[0x50B0]
    and eax,0x00000001
    cmp eax,0
    je _setup
    call _wait
    call _key_board

    cmp al,0x1C
    je _line_break

    mov edi,[0x50D0]
    add edi,1
    mov [0x50D0],edi
    mov edi,[0x50E0]
    add edi,1
    mov [0x50E0],edi
    mov edi,[0x50C0]
    mov [edi],al
    add edi,1
    mov [0x50C0],edi
    mov dword edi,[0x50A0]
    mov byte [edi],al
    add edi,1
    mov byte [edi],0x07
    add edi,1
    mov dword [0x50A0],edi
    call _set_cursor
    mov edi,[0x50D0]
    cmp edi,80
    jge _input_line_break
    ret
_line_break:
    call _command_code
    mov edi,[0x50C0]
    mov [0x50F0],edi
    call _TEST_SCOLLING
    mov ax,0x0007
    mov esi,msg1
    mov ecx,18
    call _VIDEO
    call _set_cursor
    call _clear
    ret
_command_code:
    mov edi,[0x50E0]
    cmp edi,0
    jle _ret
    mov edi,[0x5090]
    add edi,0x100
    mov [0x5090],edi
    _break_test2:
        mov edi,[0x5090]
        cmp edi,0x1700
        jge _scrolling_for_command_code
    _test_ok2:
    mov edi,[0x50F0]
    mov ax,[edi]
    cmp ax,'pr'
    je _print_command
    cmp ax,'ve'
    je _version_command
    cmp ax,'ti'
    je _time_command
    cmp ax,'ex'
    je _exit_command
    cmp ax,'he'
    je _help_command
    call _command_error
    ret
_help_command:
    add edi,2
    mov ax,[edi]
    cmp ax,'lp'
    jne _command_error
    mov ax,0x0007
    mov esi,msg6
    mov edi,[0x5090]
    mov ecx,25
    call _VIDEO
    call _TEST_SCOLLING
    mov ax,0x0007
    mov esi,msg7
    mov edi,[0x5090]
    mov ecx,42
    call _VIDEO
    call _TEST_SCOLLING
    mov ax,0x0007
    mov esi,msg8
    mov edi,[0x5090]
    mov ecx,27
    call _VIDEO
    call _TEST_SCOLLING
    mov ax,0x0007
    mov esi,msg9
    mov edi,[0x5090]
    mov ecx,19
    call _VIDEO
    call _TEST_SCOLLING
    mov ax,0x0007
    mov esi,msg10
    mov edi,[0x5090]
    mov ecx,11
    call _VIDEO
    ret
_exit_command:
    add edi,2
    mov ax,[edi]
    cmp ax,'it'
    jne _command_error
    jmp 0:0
    ret
_time_command:
    add edi,2
    mov ax,[edi]
    cmp ax,'me'
    jne _command_error
    add edi,3
    mov al,[edi]
    cmp al,'y'
    je _year
    cmp al,'m'
    je _month
    cmp al,'d'
    je _day
    cmp al,'a'
    je _all
    jne _command_error
    ret
_year:
    mov ax,0x0007
    mov esi,0x5000
    mov edi,[0x5090]
    mov ecx,4
    call _VIDEO
    ret
_month:
    mov ax,0x0007
    mov esi,0x5005
    mov edi,[0x5090]
    mov ecx,2
    call _VIDEO
    ret
_day:
    mov ax,0x0007
    mov esi,0x5008
    mov edi,[0x5090]
    mov ecx,2
    call _VIDEO
    ret
_all:
    mov ax,0x0007
    mov esi,0x5000
    mov edi,[0x5090]
    mov ecx,19
    call _VIDEO
    ret
_version_command:
    add edi,2
    mov al,[edi]
    cmp al,'r'
    jne _command_error
    add edi,2
    mov eax,[edi]
    cmp eax,'syst'
    je _version_system
    mov ax,[edi]
    cmp ax,'cm'
    je _version_cmd
    jne _command_error
    ret
_version_system:
    add edi,4
    mov ax,[edi]
    cmp ax,'em'
    jne _command_error
    mov ax,0x0007
    mov esi,msg4
    mov edi,[0x5090]
    mov ecx,26
    call _VIDEO
    ret
_version_cmd:
    add edi,2
    mov al,[edi]
    cmp al,'d'
    jne _command_error
    mov ax,0x0007
    mov esi,msg5
    mov edi,[0x5090]
    mov ecx,22
    call _VIDEO
    ret
_print_command:
    add edi,3
    mov ecx,[0x50E0]
    sub ecx,3
    mov esi,edi
    mov eax,0x0007
    mov edi,[0x5090]
    call _VIDEO
    ret
_command_error:
    mov ax,0x0004
    mov esi,msg3
    mov edi,[0x5090]
    mov ecx,17
    call _VIDEO
    ret
_key_board:
    in al,0x64
    test al, 1
    jz _pop_ret
    in al,0x60
    call convert
    ret
convert:
    mov edx,[KSR]
    and edx,1
    cmp edx,1
    je _convert_shift_t
_convert_shift_f:
    cmp al,0x29
    je _back_tick
    cmp al,0x02
    je _1
    cmp al,0x03
    je _2
    cmp al,0x04
    je _3
    cmp al,0x05
    je _4
    cmp al,0x06
    je _5
    cmp al,0x07
    je _6
    cmp al,0x08
    je _7
    cmp al,0x09
    je _8
    cmp al,0x0A
    je _9
    cmp al,0x0B
    je _0
    cmp al,0x0C
    je _minus_sign
    cmp al,0x0D
    je _equal_sign
    cmp al,0x0E
    je _backspace
    cmp al,0x10
    je _q
    cmp al,0x11
    je _w
    cmp al,0x12
    je _e
    cmp al,0x13
    je _r
    cmp al,0x14
    je _t
    cmp al,0x15
    je _y
    cmp al,0x16
    je _u
    cmp al,0x17
    je _i
    cmp al,0x18
    je _o
    cmp al,0x19
    je _p
    cmp al,0x1A
    je _curly_brackets_l
    cmp al,0x1B
    je _curly_brackets_r
    cmp al,0x1C
    je _ret
    cmp al,0x1E
    je _a
    cmp al,0x1F
    je _s
    cmp al,0x20
    je _d
    cmp al,0x21
    je _f
    cmp al,0x22
    je _g
    cmp al,0x23
    je _h
    cmp al,0x24
    je _j
    cmp al,0x25
    je _k
    cmp al,0x26
    je _l
    cmp al,0x27
    je _semicolon
    cmp al,0x28
    je _single_quotation_mark
    cmp al,0x2B
    je _backslash
    cmp al,0x2A
    je _press_shift
    cmp al,0x36
    je _press_shift
    cmp al,0x2C
    je _z
    cmp al,0x2D
    je _x
    cmp al,0x2E
    je _c
    cmp al,0x2F
    je _v
    cmp al,0x30
    je _b
    cmp al,0x31
    je _n
    cmp al,0x32
    je _m
    cmp al,0x33
    je _comma
    cmp al,0x34
    je _period
    cmp al,0x35
    je _slash
    cmp al,0x39
    je _space
    pop edx
    jmp _pop_ret
_convert_shift_t:
    cmp al,0x29
    je _tilde
    cmp al,0x02
    je _exclamation_mark
    cmp al,0x03
    je _at_sign
    cmp al,0x04
    je _hash_sign
    cmp al,0x05
    je _dollar_sign
    cmp al,0x06
    je _percent_sign
    cmp al,0x07
    je _caret_sign
    cmp al,0x08
    je _ampersand_sign
    cmp al,0x09
    je _asterisk_sign
    cmp al,0x0A
    je _left_parenthesis
    cmp al,0x0B
    je _right_parenthesis
    cmp al,0x0C
    je _underscore
    cmp al,0x0D
    je _plus_sign
    cmp al,0x10
    je _Q
    cmp al,0x11
    je _W
    cmp al,0x12
    je _E
    cmp al,0x13
    je _R
    cmp al,0x14
    je _T
    cmp al,0x15
    je _Y
    cmp al,0x16
    je _U
    cmp al,0x17
    je _I
    cmp al,0x18
    je _O
    cmp al,0x19
    je _P
    cmp al,0x1A
    je _square_brackets_l
    cmp al,0x1B
    je _square_brackets_r
    cmp al,0x1E
    je _A
    cmp al,0x1F
    je _S
    cmp al,0x20
    je _D
    cmp al,0x21
    je _F
    cmp al,0x22
    je _G
    cmp al,0x23
    je _H
    cmp al,0x24
    je _J
    cmp al,0x25
    je _K
    cmp al,0x26
    je _L
    cmp al,0x27
    je _colon
    cmp al,0x28
    je _double_quotation_mark
    cmp al,0x2B
    je _vertical_line
    cmp al,0x2C
    je _Z
    cmp al,0x2D
    je _X
    cmp al,0x2E
    je _C
    cmp al,0x2F
    je _V
    cmp al,0x30
    je _B
    cmp al,0x31
    je _N
    cmp al,0x32
    je _M
    cmp al,0x33
    je _less_sign
    cmp al,0x34
    je _greater_sign
    cmp al,0x35
    je _question_mark
    cmp al,0xAA
    je _release_shift
    cmp al,0xB6
    je _release_shift
    pop edx
    jmp _pop_ret
_back_tick:
    mov al,0x60
    ret
_tilde:
    mov al,0x7E
    ret
_1:
    mov al,0x31
    ret
_exclamation_mark:
    mov al,0x21
    ret
_2:
    mov al,0x32
    ret
_at_sign:
    mov al,0x40
    ret
_3:
    mov al,0x33
    ret
_hash_sign:
    mov al,0x23
    ret
_4:
    mov al,0x34
    ret
_dollar_sign:
    mov al,0x24
    ret
_5:
    mov al,0x35
    ret
_percent_sign:
    mov al,0x25
    ret
_6:
    mov al,0x36
    ret
_caret_sign:
    mov al,0x5E
    ret
_7:
    mov al,0x37
    ret
_ampersand_sign:
    mov al,0x26
    ret
_8:
    mov al,0x38
    ret
_asterisk_sign:
    mov al,0x2A
    ret
_9:
    mov al,0x39
    ret
_left_parenthesis:
    mov al,0x28
    ret
_0:
    mov al,0x30
    ret
_right_parenthesis:
    mov al,0x29
    ret
_minus_sign:
    mov al,0x2D
    ret
_underscore:
    mov al,0x5F
    ret
_equal_sign:
    mov al,0x3D
    ret
_plus_sign:
    mov al,0x2B
    ret
_backspace:
    mov dword edi,[0x50E0]
    cmp edi,0
    jle _project_msg1
    sub edi,1
    mov [0x50E0],edi
    mov edi,[0x50C0]
    sub edi,1
    mov [0x50C0],edi
    mov dword edi,[0x50D0]
    sub edi,1
    mov [0x50D0],edi
    mov dword edi,[0x50A0]
    sub edi,2
    mov byte [edi],0x00
    mov dword [0x50A0],edi
    call _set_cursor
    mov al,0x20
    _project_msg1:
        pop edx
        jmp _pop_ret
_q:
    mov al,0x71
    ret
_Q:
    mov al,0x51
    ret
_w:
    mov al,0x77
    ret
_W:
    mov al,0x57
    ret
_e:
    mov al,0x65
    ret
_E:
    mov al,0x45
    ret
_r:
    mov al,0x72
    ret
_R:
    mov al,0x52
    ret
_t:
    mov al,0x74
    ret
_T:
    mov al,0x54
    ret
_y:
    mov al,0x79
    ret
_Y:
    mov al,0x59
    ret
_u:
    mov al,0x75
    ret
_U:
    mov al,0x55
    ret
_i:
    mov al,0x69
    ret
_I:
    mov al,0x49
    ret
_o:
    mov al,0x6F
    ret
_O:
    mov al,0x4F
    ret
_p:
    mov al,0x70
    ret
_P:
    mov al,0x50
    ret
_curly_brackets_l:
    mov al,0x7B
    ret
_square_brackets_l:
    mov al,0x5B
    ret
_curly_brackets_r:
    mov al,0x7D
    ret
_square_brackets_r:
    mov al,0x5D
    ret
_a:
    mov al,0x61
    ret
_A:
    mov al,0x41
    ret
_s:
    mov al,0x73
    ret
_S:
    mov al,0x53
    ret
_d:
    mov al,0x64
    ret
_D:
    mov al,0x44
    ret
_f:
    mov al,0x66
    ret
_F:
    mov al,0x46
    ret
_g:
    mov al,0x67
    ret
_G:
    mov al,0x47
    ret
_h:
    mov al,0x68
    ret
_H:
    mov al,0x48
    ret
_j:
    mov al,0x6A
    ret
_J:
    mov al,0x4A
    ret
_k:
    mov al,0x6B
    ret
_K:
    mov al,0x4B
    ret
_l:
    mov al,0x6C
    ret
_L:
    mov al,0x4C
    ret
_semicolon:
    mov al,0x3B
    ret
_colon:
    mov al,0x3A
    ret
_double_quotation_mark:
    mov al,0x22
    ret
_vertical_line:
    mov al,0x7C
    ret
_single_quotation_mark:
    mov al,0x27
    ret
_backslash:
    mov al,0x5C
    ret
_press_shift:
    mov edx,[KSR]
    or edx,1
    mov [KSR],edx
    pop edx
    jmp _pop_ret
_release_shift:
    mov edx,[KSR]
    sub edx,1
    mov [KSR],edx
    pop edx
    jmp _pop_ret
_z:
    mov al,0x7A
    ret
_Z:
    mov al,0x5A
    ret
_x:
    mov al,0x78
    ret
_X:
    mov al,0x58
    ret
_c:
    mov al,0x63
    ret
_C:
    mov al,0x43
    ret
_v:
    mov al,0x76
    ret
_V:
    mov al,0x56
    ret
_b:
    mov al,0x62
    ret
_B:
    mov al,0x42
    ret
_n:
    mov al,0x6E
    ret
_N:
    mov al,0x4E
    ret
_m:
    mov al,0x6D
    ret
_M:
    mov al,0x4D
    ret
_comma:
    mov al,0x2C
    ret
_less_sign:
    mov al,0x3C
    ret
_period:
    mov al,0x2E
    ret
_greater_sign:
    mov al,0x3E
    ret
_slash:
    mov al,0x2F
    ret
_question_mark:
    mov al,0x3F
    ret
_space:
    mov edx,[KSR]
    and edx,2
    cmp edx,0
    je _no_command_space
    mov al,0x00
    ret
_no_command_space:
    mov al,0x20
    ret
_pop_ret:
    pop edx
    ret
_ret:
    ret
_setup:
    call  _clear
    mov dword [0x50C0],0x00004000
    mov dword [0x50F0],0x00004000
    mov dword edi,[0x5090]
    add edi,0x100
    mov dword [0x5090],edi
    mov ax,0x0007
    mov esi,msg1
    mov ecx,18
    call _VIDEO
    call _set_cursor
    mov dword eax,[0x50B0]
    mov eax,0x000000001
    mov dword [0x50B0],eax
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
    mov dword [0x50A0],edi
    ret
_wait:
    mov ecx,0x100000
    _wait_loop:
        loop _wait_loop
    ret
_set_cursor:
    mov ebx,[0x50A0]
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
_scrolling_for_test:
    call _scrolling_func
    jmp _test_ok
_scrolling_for_command_code:
    call _scrolling_func
    jmp _test_ok2
_scrolling_for_in:
    mov edi,[0x5090]
    add edi,0x100
    mov [0x5090],edi
    mov dword [0x50D0],0x00000000
    call _scrolling_func
    mov dword [0x50A0],0xB8DC0
    ret
_scrolling_func:
    mov esi,0xB80A0
    mov edi,0xB8000
    mov cx,0x370
    rep movsd

    mov ax,0x0007
    mov edi,0x1600
    mov esi,msg2
    mov ecx,80
    call _VIDEO

    mov edi,[0x5090]
    sub edi,0x100
    mov [0x5090],edi

    ret
_clear:
    mov dword [0x50E0],0
    mov dword [0x50D0],18
    mov edi,[0x50A0]
    ret
_input_line_break:
    mov dword [0x50D0],0
    mov edi,[0x50A0]
    cmp edi,0xB8E5F
    jge _scrolling_for_in
    mov edi,[0x5090]
    add edi,0x100
    mov [0x5090],edi
    ret
_TEST_SCOLLING:
    mov edi,[0x5090]
    add edi,0x100
    mov [0x5090],edi
    cmp edi,0x1700
    jge _scrolling_for_test
    _test_ok:
        ret
KSR dw 0x00000000
msg1 db 'Press Command -- >'
msg2 dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
msg3 db 'Command Not Found'
msg4 db 'system version:c_1.0.26504'
msg5 db 'cmd version:1.0.2605.1'
msg6 db 'RCOS cmd 1.0.2605.1 Help?'
msg7 db 'get time - time y/m/d/a(year/month/day/all)'
msg8 db 'get version - ver [appname]'
msg9 db 'print - pr [string]'
msg10 db 'exit - exit'