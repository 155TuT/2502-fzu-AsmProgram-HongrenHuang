# finalexam

## 题目(A2)

在键盘上输入一个任意字符串STRING，不能借助另外字符串变量，删除连续的重复字符后倒序存放。例如输入字符串‘aaabccadcccl1222’，删除连续重复字符后倒序字符串为‘21cdacba’。在终端上显示倒序后的字符串以及字符串长度

```text
STRING byte n dup (?)
Len word ?
```

- 输入任意长度字符串(上限为10~64均可)
- 允许在程序设计中增加所需变量、常量、位置定义

## 要求

1. 删除连续重复字符用子程序实现
2. 字符串倒序存放用子程序实现
3. 在纸质试卷上画出程序流程图，包括子程序流程图
4. 完整程序代码文件保存为:序号_学号_姓名.asm
5. ollydbg运行前和运行后的内存数据截图、命令行方式下的运行结果截图的文档保存为:序号_学号_姓名.pdf
6. “序号_学号_姓名.asm”和“序号_学号_姓名.pdf”压缩成“序号_学号姓名.zip”，发到老师指定邮箱。

## 说明1:从键盘输入字符串代码

```asm
  lea edx, string ; string为字符串变量
  mov ecx, n      ; n为string字符串分配的内存空间字节数
  call ReadString
  ; 调用函数ReadString后寄存器cax中存放字符串实际长度
```

## 说明2:在终端输出一个字符串代码

```asm
lea edx, string ;字符串 string 以0结尾call WriteString
```

## 说明3:在终端输出一个整数用函数WriteInt，例如，要在终端显示双字变量xx，代码

```asm
mov eax, XX
call WriteInt
```
