INCLUDE Irvine32.inc
INCLUDE VirtualKeys.inc

.data
    upPressedS      BYTE "Up     ", 0
    downPressedS    BYTE "Down   ", 0
    blankLines      BYTE 80 dup(219), 0
    deltaX          BYTE 1
    deltaY          BYTE 1
    ballX           BYTE 40
    ballY           BYTE 10
    prevBallX       BYTE 40
    prevBallY       BYTE 10
    ballCount       BYTE 5
    playerPos       BYTE 10
    __PLAYER_MAX__  = 18
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
top:
    call        Input
    call        DrawPlayer
    call        UpdateBall

    mov         eax, 100
    call        Delay
    jmp         top    
GameLoop ENDP

UpdateBall PROC
    push        eax
    push        edx

    mov         dl, ballX       ; Clear the ball from the previous location
    mov         dh, ballY
    call        Gotoxy
    
    mov         al, ' '
    call        WriteChar

    mov         al, ballY       ; Bottom wall collision
    cmp         al, 22
    jb          notBottomWall
    neg         deltaY
notBottomWall:

    mov         al, ballY       ; Top wall collision
    cmp         al, 1
    ja          notTopWall
    neg         deltaY
notTopWall:

    mov         al, ballX       ; Paddle collision
    cmp         al, 74
    jbe          notPaddle

    mov         al, ballY
    cmp         al, (playerPos + 5)
    jae          notPaddle
    cmp         al, playerPos
    jbe         notPaddle

    neg         deltaX

notPaddle:
    push        ecx
    mov         ecx, 5
topLoop:
    mov         dl, 74
    push        ecx
    add         cl, playerPos
    mov         dh, cl
    pop         ecx
    call        Gotoxy
    mov         al, 'B'
    call        WriteChar
    loop        topLoop
    pop         ecx

    mov         al, ballX       ; Update the ball's X position
    add         al, deltaX
    mov         ballX, al

    mov         al, ballY       ; Update the ball's Y position
    add         al, deltaY
    mov         ballY, al

    mov         dl, ballX       ; Draw the ball in the new position
    mov         dh, ballY
    call        Gotoxy      
    mov         al, '@'
    call        WriteChar

    pop         edx
    pop         eax
    ret
UpdateBall ENDP

DrawPlayer PROC

    pushad

    mov         dl,75           ; Clear the previous Paddle pixels
    mov         dh, 1
    call        Gotoxy
    mov         ecx, (__PLAYER_MAX__ + 4)
    mov         al, ' '
clearLoop:
    call        WriteChar
    inc         dh
    call        Gotoxy
    loop        clearLoop

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
    ;and         al, 0DFh
    cmp         al, 077h     ; Is up key pressed
    jne         notUp
    call        MoveUp
notUp:
    ;and         al, 0DFh
    cmp         al, 073h     ; Is down key pressed
    jne         notDown
    call        MoveDown
notDown:

    ret

Input ENDP

MoveUp PROC

    push        eax

    movzx       eax, playerPos    
    cmp         eax, 1
    jbe          tooBig

    dec         playerPos

tooBig:
    pop         eax
    ret

MoveUp ENDP

MoveDown PROC

    push        eax

    movzx       eax, playerPos    
    cmp         eax, __PLAYER_MAX__
    jae         tooSmall

    inc         playerPos
    
tooSmall:
    pop         eax
    ret

MoveDown ENDP

END main
