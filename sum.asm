title sum
enterline macro
    mov dl,13
    mov ah,2
    int 21h
    mov dl,10
    mov ah,2
    int 21h
endm

data segment
    buf db 10,?,10 dup(0)
    sum db 0
    hint db 'Input a number(no more than 5 digits):',13,10,'$'
    err db 'Illegal Input!Please try again.$'
    output db 'sum of all digits:$'
data ends

code segment
assume ds:data,cs:code
start:
    mov ax,data
    mov ds,ax
begin:
    lea dx,hint
    mov ah,9
    int 21h

    lea dx,buf
    mov ah,10
    int 21h
    enterline

    mov ch,0
    mov cl,buf+1
    cmp cl,0
    je print
    cmp cl,5
    ja error
    lea si,buf+2
lop:
    mov al,[si]
    cmp al,'0'
    jb error
    cmp al,'9'
    ja error
    add sum,al
    sub sum,30h
    inc si
    loop lop

print:
    lea dx,output
    mov ah,9
    int 21h
    mov al,sum
    mov bl,10
    mov ah,0
    div bl
    mov cl,ah
    cmp al,0
    je nxt
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h
nxt:
    mov dl,cl
    add dl,30h
    mov ah,2
    int 21h
    enterline
    jmp exit

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