data segment;数据段
  errs db 'error!$'
data ends

stack1 segment para stack;堆栈段
  
stack1 ends

code segment;代码段
assume cs:code,ds:data
start:mov ax,data;程序起点
      mov ds,ax
input:mov ah,08h;控制台输入到al
      int 21h
      cmp al,'0';是否=0
      jz zero
      cmp al,'A';是否>=A，大于等于则cf=0，对应jnc
      jc err;<A且！=0的情况
      ;下面的情况>=A
      cmp al,5bh;是否<=Z，和Z的后一个字符比较，小于则cf=1，对应jc
      jc plus
      ;下面的情况>Z
      cmp al,'a'
      jc err
      cmp al,7bh
      jc minus
      jnc err
zero: mov dl,'0';移动到dl供显示
      mov ah,02h;字符显示
      int 21h
      mov ah,4ch;返回控制台
      int 21h
plus: add al,20h
      mov dl,al
      jmp show
minus: sub al,20h
       mov dl,al
       jmp show
show: mov ah,02h;字符显示
      int 21h
      loop input
err:  mov dx,offset errs;将errs首地址传送给dx
      mov ah,09h;召唤字符串
      int 21h;芝麻开门
      loop input

code ends;代码段结束
 end start