INCLUDE Irvine32.inc
INCLUDE VirtualKeys.inc

.data
    upPressedS      BYTE "Up     ", 0
    downPressedS    BYTE "Down   ", 0
    blankLines      BYTE 80 dup(219), 0
    deltaX          BYTE 1
    deltaY          BYTE 1
    ballCount       BYTE 5
    playerPos       BYTE 10
    __PLAYER_MAX__  = 74
.code

main PROC
    mov         eax, black + (blue * 16)
    call        SetTextColor
    call        ClrScr                    ; Initialization Code
    mov         edx, 0
    call        Gotoxy
    mov         edx, offset blankLines
    call        WriteString
    mov         dx, 0
    call        Gotoxy
    mov         ecx, 23
border:
    mov         al, 219
    call        WriteChar
    call        Crlf
loop        border

    mov         edx, offset blankLines
    call        WriteString

    mov         edx, 4
    call        Gotoxy

    call        GameLoop

    mov         eax, 0FFFFFFFFh
    call        Delay

    exit
main ENDP

GameLoop PROC
    call        Input
    call        DrawPlayer

    pushad
    mov         dl, 10
    mov         dh, 10
    call        Gotoxy
    movzx       eax, playerPos
    call        WriteInt
    popad

    mov         eax, 100
    call        Delay
GameLoop ENDP

DrawPlayer PROC

    pushad

    mov         dl, 75
    mov         dh, playerPos
    call        Gotoxy

    mov         al, 219
    call        WriteChar
    inc         dh
    call        Gotoxy
    call        WriteChar
    inc         dh
    call        Gotoxy
    call        WriteChar
    inc         dh
    call        Gotoxy
    call        WriteChar
    inc         dh
    call        Gotoxy
    call        WriteChar

    popad

    ret

DrawPlayer ENDP

Input PROC
    ; The bounds on player position are 1 and 74?
    ; Todo(Sora): Test the max player position
    mov         edx, 0
    call        ReadKey
    and         al, 0DFh
    cmp         al, 'W'     ; Is up key pressed
    jne         notUp
    call        MoveUp
notUp:
    and         al, 0DFh
    cmp         al, 'S'     ; Is down key pressed
    jne         notDown
    call        MoveDown
notDown:

    ret

Input ENDP

MoveUp PROC

    push        eax

    push        edx
    mov         dl, 11
    mov         dh, 11
    call        Gotoxy
    mov         edx, offset upPressedS
    call        WriteString
    pop         edx

    movzx       eax, playerPos    
    cmp         eax, __PLAYER_MAX__
    jae         tooBig

    inc         playerPos

tooBig:
    pop         eax
    ret

MoveUp ENDP

MoveDown PROC

    push        eax


    push        edx
    mov         dl, 11
    mov         dh, 11
    call        Gotoxy
    mov         edx, offset downPressedS
    call        WriteString
    pop         edx

    movzx       eax, playerPos    
    cmp         eax, 0
    jz         tooSmall

    dec         playerPos
    
tooSmall:
    pop         eax
    ret

MoveDown ENDP

END main
