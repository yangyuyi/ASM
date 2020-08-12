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
    msg db 'Please enter 3 number as the sides of a triangle:$'
    msg1 db 'These 3 number can not make a triangle.',13,10,'$'
    msg2 db 'The perimeter of this triangle:$'
    err db 'ERROR!',13,10,'$'
    buf db 100,?,100 dup(0)
    num db 3 dup(0)
    flag db ?
    flg db ?
    cnt db 0
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
    lea dx,msg
    mov ah,9
    int 21h    
    enterline
    lea dx,buf
    mov ah,10
    int 21h
    enterline
    
    mov ch,0
    mov cl,buf+1
    lea si,buf+2
    lea di,num
    mov al,0
    mov flg,0
lop:
    mov bh,[si]
    cmp bh,' '
    je next
    cmp bh,'0'
    jb error_trs
    cmp bh,'9'
    ja error_trs
    mov flg,1
    mov bl,10
    mul bl
    add al,bh
    sub al,'0'
    inc si
    dec cl
    cmp cl,0
    je end_lop
    jmp lop
next:
    inc si
    dec cl
    cmp cl,0
    je end_lop
    mov bh,[si]
    cmp bh,' '
    je next

    cmp flg,1
    jne lop
    mov flg,0
    inc cnt
    mov [di],al
    mov al,0
    inc di
    jmp lop
end_lop:
    cmp flg,1
    jne next
    mov dh,cnt
    inc dh
    mov cnt,dh
    mov [di],al
    jmp work
    
error_trs:
    jmp error

work:
    cmp cnt,3
    jne error_trs
    mov al,[num]
    add al,[num+1]
    cmp al,[num+2]
    jbe unable_trs
    mov al,[num]
    add al,[num+2]
    cmp al,[num+1]
    jbe unable_trs
    mov al,[num+1]
    add al,[num+2]
    cmp al,[num]
    jbe unable_trs
    mov al,[num]
    add al,[num+1]
    add al,[num+2]
    
    lea dx,msg2
    mov ah,9
    int 21h
    jmp trans

unable_trs:
    jmp unable
trans:
    mov bl,100
    mov flag,0
cov:
    mov ah,0   
    div bl
    mov cl,ah
    cmp flag,0
    jne print
    cmp al,0
    je nxt
print:
    mov dl,al
    add dl,'0'
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
    add dl,'0'
    mov ah,2
    int 21h
    enterline
    jmp exit

unable:
    lea dx,msg1
    mov ah,9
    int 21h
    jmp exit

error:
    lea dx,err
    mov ah,9
    int 21h
exit:
    mov ah,4ch
    int 21h
code ends
    end start