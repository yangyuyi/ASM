data segment;定义数据段
  x db 'A'; define byte定义x为一个值为A的ASCII码的字节型变量
  y dw 30h; define word定义y为一个值为30h(48)的字型变量
  z dd 40h; define double word定义z为一个值为40h(64)的双字型变量
  a dw ?;定义一个变量
data ends;段结束的标记

stack1 segment para stack;不需要堆栈段可以不要这部分
  db 10h dup(0)
stack1 ends

code segment
assume cs:code,ds:data; assume伪指令用于确定段与段寄存器的关系，assume不会翻译成机器指令，但会存在于exe的文件头中，这会方便DOS重新分配内存时改变对应地址指针寄存器的值
start:mov ax,data;汇编后段名变成立即数，立即数不能直接赋值给段寄存器
  mov ds,ax;段寄存器将指向data数据段
  mov dl,x;显示字符前将字符移动到dl
  mov ah,02h;调用字符显示
  int 21h
  mov ah,4ch;4ch对应返回控制台子程序
  int 21h;根据ah确定子程序，自动跳转到子程序入口地址
 code ends
end start