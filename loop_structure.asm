title loop_structure
data segment
    input db ?
    quotient db ?
    remainder db ?
    etr db 13,10,'$'
    err db 13,10,'Illegal Input!',13,10,'$'
data ends

stack segment
    db 10 dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
start:
    mov ax,data
    mov ds,ax

read:
    mov ah,1
    int 21h
    cmp al,'q'
    je trans

    sub al,30h
    mov input,al
    
    cmp input,0
    ja cmp2
    lea dx,err
    mov ah,9
    int 21h
    jmp read

cmp2:
    cmp input,10
    jb work
    lea dx,err
    mov ah,9
    int 21h
    jmp read

work:
    lea dx,etr
    mov ah,9
    int 21h
    mov bl,1
    xor ch,ch
    mov cl,input
    jmp loop1
    
trans:
    jmp quit

loop1:
    push cx
    mov bh,1
    xor ch,ch
    mov cl,bl
    loop2:
        mov dl,bl
        add dl,30h
        mov ah,2
        int 21h

        mov dl,'*'
        mov ah,2
        int 21h

        mov dl,bh
        add dl,30h
        mov ah,2
        int 21h

        mov dl,'='
        mov ah,2
        int 21h

        mov al,bl
        mul bh
        mov dl,10
        div dl
        mov quotient,al
        mov remainder,ah

        cmp quotient,0
        je print_input0
        
        mov dl,quotient
        add dl,30h
        mov ah,2
        int 21h

    print_input0:
        mov dl,remainder
        add dl,30h
        mov ah,2
        int 21h  
        
        mov dl,' '
        mov ah,2
        int 21h
        
        inc bh
        loop loop2
    inc bl   

    lea dx,etr
    mov ah,9
    int 21h

    pop cx
    loop loop1

quit:
    mov ah,4ch
    int 21h
code ends
    end start