include irvine32.inc

.data
    initValue       DWORD 0111H                 ; 初始双字数据，十六进制为 0111H            
    newlineStr      BYTE 13,10,0                ; 回车换行字符串
    promptInput     BYTE "Please Input: ",0     ; 输入提示字符串
    promptOutput    BYTE "The output is: ",0    ; 输出提示字符串
    inputBuffer     BYTE 64 DUP(0)              ; 字符串输入缓冲区，最多存放 63 个字符和结尾 0

.code
main PROC
    ; ------------------------------
    ; 1. 输出初始数值
    ; ------------------------------
    mov eax, initValue            ; 将初始数值送入 EAX
    call WriteHex                 ; 以十六进制形式输出 EAX 中的值

    mov edx, OFFSET newlineStr    ; EDX 指向回车换行字符串
    call WriteString              ; 输出回车换行

    call WriteInt                 ; 以十进制形式输出 EAX 中的值
    call WriteString              ; 输出回车换行（沿用原程序逻辑）

    ; ------------------------------
    ; 2. 读入一个整数，加 1 后输出
    ; ------------------------------
    mov edx, OFFSET promptInput   ; EDX 指向输入提示字符串
    call WriteString              ; 显示输入提示

    call ReadInt                  ; 从键盘读入整数，结果存入 EAX

    mov edx, OFFSET promptOutput  ; EDX 指向输出提示字符串
    call WriteString              ; 显示输出提示

    add eax, 1                    ; 输入的整数加 1
    call WriteHex                 ; 以十六进制形式输出结果

    mov edx, OFFSET newlineStr    ; EDX 指向回车换行字符串
    call WriteString              ; 输出回车换行

    ; ------------------------------
    ; 3. 读入一个字符串，再原样输出
    ; ------------------------------
    mov edx, OFFSET promptInput   ; EDX 指向输入提示字符串
    call WriteString              ; 显示输入提示

    mov edx, OFFSET inputBuffer   ; EDX 指向字符串输入缓冲区
    mov ecx, 64                   ; ECX 指定最多可输入的字符数
    call ReadString               ; 读入字符串，实际长度返回到 EAX

    mov ecx, eax                  ; 保存输入字符串长度（沿用原程序写法）
    mov edx, OFFSET promptOutput  ; EDX 指向输出提示字符串
    call WriteString              ; 显示输出提示

    mov edx, OFFSET inputBuffer   ; EDX 指向刚刚读入的字符串
    call WriteString              ; 输出输入的字符串

    mov edx, OFFSET newlineStr    ; EDX 指向回车换行字符串
    call WriteString              ; 输出回车换行

    exit
main ENDP

END main