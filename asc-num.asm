;���̼����ASCII��ת������
enterline macro
	mov dl,13  ;�س�
	mov ah,2
	int 21h
	mov dl,10  ;����
	mov ah,2
	int 21h
endm

DATAS SEGMENT
    ;�˴��������ݶδ��� 
    input db 'Please Input Number(<=65535):$'
    output db 'Convertion Success!$' 
    err db 'Illegal input! Please Try Again$'
    buf db 10,?,10 dup(0)
    FNN DW 0
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
begin:
    lea dx,input ;�����ʾ��
    mov ah,9
    int 21h
    
    
    lea dx,buf  ;���뻺�����׵�ַ
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
    cmp dx,0  ;������
    jne error
    
    add di,ax   ;����λ
    jc error    ;�н�λ�ͳ���
    
        
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





