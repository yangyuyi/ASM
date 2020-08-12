title markingsystem
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
    sum dw 0
    min db ?
    max db ?
    score db 10 dup(0)
    msg db 'Please enter the scores of 7 judges.(score:0-100)$'
    hint db 'Score of judge$'
    err db 'Illegal input! Please try again.$'
    over db 'Overflow! score:0-100. Please try again.$'
    flag db ?
    r db ?
    ans db ?
data ends

stack segment
    db 10 dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
start:
    mov ax,data
    mov ds,ax

begin:
    mov bl,0
    lea di,score
    lea dx,msg
    mov ah,9
    int 21h
    enterline

lop1:
    inc bl
    lea dx,hint
    mov ah,9
    int 21h
    mov dl,bl
    add dl,30h
    mov ah,2
    int 21h
    mov dl,':'
    mov ah,2
    int 21h
    enterline

    lea dx,buf
    mov ah,10
    int 21h
    enterline

    mov ch,0
    mov cl,buf+1
    lea si,buf+2
    
    cmp cl,0
    je error_trs
    cmp cl,3
    ja error_trs

    mov al,0
lop2:
    mov bh,[si]
    cmp bh,'0'
    jb error_trs
    cmp bh,'9'
    ja error_trs
    sub bh,30h

    mov ah,0
    mov dh,10
    mul dh
    cmp ah,0
    jne error_trs
    add al,bh
    jc error_trs
    inc si
    loop lop2

    cmp al,100
    ja error_trs
    mov [di],ax
    inc di
    cmp bl,7
    jb lop1  
    jmp work

error_trs:
    jmp error

work:
    lea si,score
    mov bl,[si]
    mov min,bl
    mov bl,[si]
    mov max,bl
    add si,1
    mov cx,6
lop4:
    mov bl,[si]
    cmp bl,min
    ja cmp2
    mov min,bl
cmp2:
    cmp bl,max
    jb nxt
    mov max,bl
nxt:
    inc si
    loop lop4

    lea si,score
    mov sum,0
    mov cx,7
lop5:
    mov bl,[si]
    mov bh,0
    add sum,bx
    inc si
    loop lop5

    mov ax,sum
    mov bl,min
    mov bh,0
    sub ax,bx
    mov bl,max
    mov bh,0
    sub ax,bx

    shl ax,1
    mov dx,0
    mov bx,10
    div bx

    mov r,dl
    mov bx,100
    mov flag,0
lop3:
    mov dx,0
    div bx
    mov cx,dx
    cmp flag,0
    jne print
    cmp ax,0
    je modd

print:
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h
    mov flag,1

modd:
    cmp bx,10
    je outer

    mov dx,0
    mov ax,bx
    mov bx,10
    div bx
    mov bx,ax
    mov ax,cx
    jmp lop3

outer:
    mov dl,cl
    add dl,30h
    mov ah,2
    int 21h
    mov dl,'.'
    mov ah,2
    int 21h
    mov dl,r
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
    jmp begin

exit:
    mov ah,4ch
    int 21h
code ends
    end start