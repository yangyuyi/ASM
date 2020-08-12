title subroution

enterline macro
    mov dl,13  ;回车
	mov ah,2
	int 21h
	mov dl,10  ;换行
	mov ah,2
	int 21h
endm

data segment
    hint_input db 'Choose Function:Please enter num 1-5:$'
    hint_func db '1-lowercase to uppercase',13,10,'2-uppercase to lowercase',13,10,'3-binary to hex',13,10,'4-hex to binary',13,10,'5-hex to decimal',13,10,'q-Exit$'
    hint1 db 'Please enter a lowercase(a-z):$'
    hint2 db 'Please enter a uppercase(A-Z):$'
    hint3 db 'Please enter a 8-bit binary(0-11111111):$'
    hint4 db 'Please enter a 2-bit hex(0-FF):$'
    hint5 db 'Please enter a 2-bit hex(0-FF):$'
    hint_success db 'Conversion Success!',13,10,'result:$'
    err db 'Illagel input!Please try again.$'
    mode db ?
    jmp_table dw func1,func2,func3,func4,func5
    letter db ?
    buf db 10,?,10 dup(0)
    error db ?
    flag db ?
data ends

stack segment
    dw 10h dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
start:
    mov ax,data
    mov ds,ax

read:
    lea dx,hint_input
    mov ah,9
    int 21h
    enterline

    lea dx,hint_func
    mov ah,9
    int 21h
    enterline

    mov ah,1
    int 21h

    cmp al,'q'
    je quit_trans

    sub al,30h
    mov mode,al
    enterline

    cmp mode,1
    jb err_input
    cmp mode,5
    jbe work

err_input:
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp read

work:
    xor bh,bh
    mov bl,mode
    sub bl,1
    shl bl,1
    jmp jmp_table[bx]

quit_trans:
    jmp quit
    
func1:
    lea dx,hint1
    mov ah,9
    int 21h
    enterline

    mov ah,1
    int 21h
    mov letter,al

    cmp letter,'a'
    jb err_func1
    cmp letter,'z'
    ja err_func1

    enterline
    lea dx,hint_success
    mov ah,9
    int 21h

    mov al,letter
    call lwtoup
    mov dl,al
    mov ah,2
    int 21h
    jmp quit

err_func1:
    enterline
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp func1

func2:
    lea dx,hint2
    mov ah,9
    int 21h
    enterline

    mov ah,1
    int 21h
    mov letter,al

    cmp letter,'A'
    jb err_func2
    cmp letter,'Z'
    ja err_func2

    enterline
    lea dx,hint_success
    mov ah,9
    int 21h

    mov al,letter
    call uptopw
    mov dl,al
    mov ah,2
    int 21h
    jmp quit

err_func2:
    enterline
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp func2

func3:
    lea dx,hint3
    mov ah,9
    int 21h
    enterline

    lea dx,buf  ;输入缓冲区首地址
    mov ah,10
    int 21h
    enterline

    mov error,0
    push ax
    push bx
    push cx
    push dx
    call bintohex
    pop dx
    pop cx
    pop bx
    pop ax
    cmp error,1
    je err_func3
    jmp quit

err_func3:
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp func3

func4:
    lea dx,hint4
    mov ah,9
    int 21h
    enterline

    lea dx,buf  ;输入缓冲区首地址
    mov ah,10
    int 21h
    enterline

    mov error,0
    push ax
    push bx
    push cx
    push dx
    call hextobin
    pop dx
    pop cx
    pop bx
    pop ax
    cmp error,1
    je err_func4
    jmp quit

err_func4:
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp func4

func5:
    lea dx,hint5
    mov ah,9
    int 21h
    enterline

    lea dx,buf  ;输入缓冲区首地址
    mov ah,10
    int 21h
    enterline

    mov error,0
    push ax
    push bx
    push cx
    push dx
    call hextodec
    pop dx
    pop cx
    pop bx
    pop ax
    cmp error,1
    je err_func5
    jmp quit

err_func5:
    lea dx,err
    mov ah,9
    int 21h
    enterline
    jmp func5

quit:
    mov ah,4ch
    int 21h

lwtoup proc
    pushf
    cmp al,'a'
    jb lw1
    cmp al,'z'
    ja lw1
    sub al,'a'-'A'
lw1:
    popf
    ret
lwtoup endp

uptopw proc
    pushf
    cmp al,'A'
    jb up1
    cmp al,'Z'
    ja up1
    add al,'a'-'A'
up1:
    popf
    ret
uptopw endp

bintohex proc
    mov ch,0
    mov bl,buf+1
    lea si,buf+2
    cmp bl,1
    jb bth_err
    cmp bl,8
    ja bth_err

bth_xch:
    mov al,0
    mov cl,bl
    cmp bl,4
    jbe bth_lop
    sub cl,4

bth_lop:
    mov bh,[si]
    sub bh,30h
    cmp bh,0
    jb bth_err
    cmp bh,1
    ja bth_err
    shl al,1
    add al,bh
    inc si
    dec bl
    loop bth_lop

bth_print:
    cmp al,10
    jb bth_next
    add al,7

bth_next:
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h
    cmp bl,0
    je bth_exit
    jmp bth_xch

bth_err:
    mov error,1
bth_exit:
    ret
bintohex endp

hextobin proc
    mov flag,0
    mov ch,0
    mov cl,buf+1
    lea si,buf+2
    cmp cl,1
    jb htb_err
    cmp cl,2
    ja htb_err
    
htb_lop:
    mov bh,[si]
    sub bh,30h
    cmp bh,0
    jb htb_err
    cmp bh,10
    jb htb_next
    sub bh,7
    cmp bh,10
    jb htb_err
    cmp bh,15
    ja htb_err

htb_next:
    mov bl,8
htb_lop2:
    mov al,bh
    and al,bl
    cmp flag,0
	jne htb_print
	cmp al,0
    je htb_shr

htb_print:
    mov dl,30h
    cmp al,0
    je print
    inc dl 
print:
	mov ah,2
	int 21h	
	mov flag,1

htb_shr:
    shr bl,1
    cmp bl,0
    je htb_nextnum
    jmp htb_lop2

htb_nextnum:
    inc si
    dec cl
    je htb_exit
    jmp htb_lop

htb_err:
    mov error,1
htb_exit:
    ret
hextobin endp

hextodec proc
    mov al,0
    mov ch,0
    mov cl,buf+1
    lea si,buf+2
    cmp cl,1
    jb htd_err_trans
    cmp cl,2
    ja htd_err_trans

htd_lop:
    mov bh,[si]
    sub bh,30h
    cmp bh,0
    jb htd_err_trans
    cmp bh,10
    jb htd_next
    sub bh,7
    cmp bh,10
    jb htd_err_trans
    cmp bh,15
    ja htd_err_trans
    jmp htd_next

htd_err_trans:
    jmp htd_err

htd_next:
    mov bl,cl
    mov cl,4
    shl al,cl
    mov cl,bl
    add al,bh
    inc si
    loop htd_lop

    mov flag,0
    mov bl,100 
cov:
	mov ah,0
	div bl
	mov cl,ah
	
	cmp flag,0
	jne nor1
	cmp al,0
	je cont
	
nor1:
	mov dl,al
	add dl,30h
	mov ah,2
	int 21h	
	mov flag,1	

cont:
	cmp bl,10
	je outer
	
	mov ah,0
	mov al,bl
	mov bl,10
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
    jmp htd_exit

htd_err:
    mov error,1
htd_exit:
    ret
hextodec endp
code ends
    end start