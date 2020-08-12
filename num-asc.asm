;二进制转十进制的ASCII码输出
enterline macro
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
endm

DATAS SEGMENT
    ;此处输入数据段代码 
    output db 'AX Register Content is:$' 
    flag db 0
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
   	lea dx,output
    mov ah,9
    int 21h
    
    mov ax, 4090;(有效数值为0~65535)
    mov bx,10000
    
cov:
	xor dx,dx
	div bx
	mov cx,dx
	
	cmp flag,0
	jne nor1
	cmp ax,0
	je cont
	
nor1:
	mov dl,al
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1
	
cont:
	cmp bx,10
	je outer
	
	xor dx,dx
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx
    jmp cov    
   
outer:
	mov dl,cl
	add dl,30h
	mov ah,2
	int 21h   
	enterline
	
stop:    
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START






