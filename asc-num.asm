;键盘键入的ASCII码转二进制
enterline macro
	mov dl,13  ;回车
	mov ah,2
	int 21h
	mov dl,10  ;换行
	mov ah,2
	int 21h
endm

DATAS SEGMENT
    ;此处输入数据段代码 
    input db 'Please Input Number(<=65535):$'
    output db 'Convertion Success!$' 
    err db 'Illegal input! Please Try Again$'
    buf db 10,?,10 dup(0)
    FNN DW 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
begin:
    lea dx,input ;输出提示行
    mov ah,9
    int 21h
    
    
    lea dx,buf  ;输入缓冲区首地址
    mov ah,10
    int 21h
    enterline
    
    mov cl,buf+1
    xor ch,ch
    xor di,di
    xor dx,dx
    mov bx,1
    lea si,buf+2
    add si,cx
    dec si
    
cov:mov al,[si]
	cmp al,'0'
	jb error
	cmp al,'9'
	ja error

    sub al,30h
    xor ah,ah
    mul bx
    cmp dx,0  ;溢出检测
    jne error
    
    add di,ax   ;检测进位
    jc error    ;有进位就出错
    
        
    mov ax,bx
    mov bx,10
    mul bx
    mov bx,ax
    
    dec si
    loop cov    
   
   	mov ax,di
   	
   	MOV FNN,AX
   	
    lea dx,output
    mov ah,9
    int 21h
    enterline
    jmp stop

error:
	lea dx,err
    mov ah,9
    int 21h
    enterline 
    
    jmp begin   
        
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START





