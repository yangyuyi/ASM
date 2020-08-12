title branch_structure
data segment
    input db ?
    str0 db ':',13,10,'You recieved a message: this is number zero!',13,10,'$'
    str1 db ':',13,10,'You recieved a message: this is number one!',13,10,'$'
    str2 db ':',13,10,'You recieved a message: this is number two!',13,10,'$'
    str3 db ':',13,10,'You recieved a message: this is number three!',13,10,'$'
    str4 db ':',13,10,'You recieved a message: this is number four!',13,10,'$'
    str5 db ':',13,10,'You recieved a message: this is number five!',13,10,'$'
    str6 db ':',13,10,'You recieved a message: this is number six!',13,10,'$'
    str7 db ':',13,10,'You recieved a message: this is number seven!',13,10,'$'
    str8 db ':',13,10,'You recieved a message: this is number eight!',13,10,'$'
    err db ':',13,10,'!WARNING! llegal Input',13,10,'$'
data ends

code segment
    assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

read:
    mov ah,1
    int 21h
    mov input,al
    cmp input,'0'
    je msg0
    cmp input,'1'
    je msg1
    cmp input,'2'
    je msg2
    cmp input,'3'
    je msg3
    cmp input,'4'
    je msg4
    cmp input,'5'
    je msg5
    cmp input,'6'
    je msg6
    cmp input,'7'
    je msg7
    cmp input,'8'
    je msg8
    cmp input,'q'
    je  quit
    lea dx,err
    mov ah,9
    int 21h
    jmp read
msg0:
    lea dx,str0
    mov ah,9
    int 21h
    jmp read
msg1:
    lea dx,str1
    mov ah,9
    int 21h
    jmp read
msg2:
    lea dx,str2
    mov ah,9
    int 21h
    jmp read
msg3:
    lea dx,str3
    mov ah,9
    int 21h
    jmp read
msg4:
    lea dx,str4
    mov ah,9
    int 21h
    jmp read
msg5:
    lea dx,str5
    mov ah,9
    int 21h
    jmp read
msg6:
    lea dx,str6
    mov ah,9
    int 21h
    jmp read
msg7:
    lea dx,str7
    mov ah,9
    int 21h
    jmp read
msg8:
    lea dx,str8
    mov ah,9
    int 21h
    jmp read
quit:
    mov ah,4ch
    int 21h    
code ends
    end start