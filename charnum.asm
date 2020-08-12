title charnum
enterline macro
    mov dl,13
    mov ah,2
    int 21h
    mov dl,10
    mov ah,2
    int 21h
endm

data segment
    buf db 100,?,100 dup(0)
    msg db 'Please enter a string(less than 100 char):$'
    num_l db 0
    num_n db 0
    num_sp db 0
    num_oth db 0
    msg_l db 'Number of letter:$'
    msg_n db 'Number of number:$'
    msg_sp db 'Number of space:$'
    msg_oth db 'Number of other char:$'
    flag db ?

data ends

stack segment
    db 10 dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
start:
    mov ax,data
    mov ds,ax
    
    lea dx,msg
    mov ah,9
    int 21h
    enterline

    lea dx,buf
    mov ah,10
    int 21h
    enterline

    mov cl,buf+1
    lea si,buf+2
    cmp cl,0
    je print

lop:
    mov al,[si]
    cmp al,' '
    je incsp
    cmp al,'0'
    jb incoth
    cmp al,'9'
    jb incnum
    cmp al,'A'
    jb incoth
    cmp al,'Z'
    jb inclet
    cmp al,'a'
    jb incoth
    cmp al,'z'
    jb inclet
    inc num_oth
next:
    inc si
    loop lop
    jmp print

incnum:
    inc num_n
    jmp next
inclet:
    inc num_l
    jmp next
incsp:
    inc num_sp
    jmp next
incoth:
    inc num_oth
    jmp next

print:
    lea dx,msg_n
    mov ah,9
    int 21h
    mov al,num_n
    call print_num

    lea dx,msg_l
    mov ah,9
    int 21h
    mov al,num_l
    call print_num
    
    lea dx,msg_sp
    mov ah,9
    int 21h
    mov al,num_sp
    call print_num
    
    lea dx,msg_oth
    mov ah,9
    int 21h
    mov al,num_oth
    call print_num

exit:
    mov ah,4ch
    int 21h

print_num proc
    mov bl,100
    mov flag,0
    
cov: 
    mov ah,0
    div bl
    mov cl,ah
    cmp flag,0
    jne prnt
    cmp al,0
    je nxt
prnt:
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h
    mov flag,1
nxt:
    cmp bl,10
    je outer

    mov al,bl
    mov bl,10
    mov ah,0
    div bl
    mov bl,al
    mov al,cl
    jmp cov

outer:
    mov dl,cl
    add dl,30h
    mov ah,2
    int 21h
    enterline
    ret
print_num endp

code ends
    end start