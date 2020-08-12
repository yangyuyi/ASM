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
    buf db 10,?,10 dup(0)
    err db 'Illegal Input!$'
    overf db 'Overflow!$'
    msg1 db 'Please input the first operand(<=65535):$'
    msg2 db 'Please input the second operand(<=65535):$'
    msg3 db 'Please input a number(1-4) to choose operator:$'

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
    lea dx,msg1
    mov ah,9
    int 21h
    enterline
    lea dx,buf
    mov ah,10
    int 21h
    enterline
    mov cl,[buf+1]
    lea si,buf+2
    mov di,0
lop:
    mov al,[si]
    mov ah,0
    cmp al,'0'
    jb error
    cmp al,'9'
    ja error
    sub 
error:
    lea dx,err
    mov ah,9
    int 21h
    enterline
exit:
    mov ah,4ch
    int 21h
code ends
    end start