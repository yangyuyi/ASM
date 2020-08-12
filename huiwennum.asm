enterline macro
    push ax
    push dx
    mov dl,13
    mov ah,2
    int 21h
    mov dl,10
    mov ah,2
    int 21h
    pop dx
    pop ax
endm

data segment
    cnt db 0
    hundred dw 0
    ten dw 0
    unit dw 0
data ends

stack segment
    dw 10 dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
start:
    mov ax,data
    mov ds,ax
read:
    mov ah,1
    int 21h
    cmp al,13
    jne read
    
    mov cx,0
lop:
    mov ax,cx
    cmp ax,10
    jb cmp1
    cmp ax,100
    jb cmp2_trs
    mov dx,0
    mov bx,100
    div bx
    mov hundred,ax
    mov ax,dx
    mov dx,0
    mov bx,10
    div bx
    mov ten,ax
    mov unit,dx
    mov ax,hundred
    cmp ax,unit
    jne next_trs
    inc cnt
    cmp cnt,11
    jne nxt3
    enterline
    mov cnt,0
nxt3:
    mov dl,al
    add dl,'0'
    mov ah,2
    int 21h
    mov ax,ten
    mov dl,al
    add dl,'0'
    mov ah,2
    int 21h
    mov ax,unit
    mov dl,al
    add dl,'0'
    mov ah,2
    int 21h
    mov dl,' '
    mov ah,2
    int 21h
    jmp next
cmp2_trs:
    jmp cmp2
next_trs:
    jmp next
cmp1:
    inc cnt
    cmp cnt,11
    jne nxt1
    enterline
    mov cnt,0
nxt1:
    mov dl,al
    add dl,'0'
    mov ah,2
    int 21h
    mov dl,' '
    mov ah,2
    int 21h
    jmp next
cmp2:
    mov dx,0
    mov bx,10
    div bx
    cmp ax,dx
    jne next
    inc cnt
    cmp cnt,11
    jne nxt2
    enterline
    mov cnt,0
nxt2:
    mov dl,al
    add dl,'0'
    mov ah,2
    int 21h
    int 21h
    mov dl,' '
    mov ah,2
    int 21h
    jmp next
next:
    inc cx
    cmp cx,500
    je exit
    jmp lop
exit:
    mov ah,4ch
    int 21h
code ends
    end start