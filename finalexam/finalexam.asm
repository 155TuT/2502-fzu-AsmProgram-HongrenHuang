; finalexam.asm
include irvine32.inc

N = 64

.data
STRING BYTE N DUP(?)
Len    WORD ?
prompt BYTE "Please input a string: ",0
msgOut BYTE "Reversed string: ",0
msgLen BYTE "Length: ",0

.code
main PROC
    ; 输出提示信息
    mov  edx, OFFSET prompt
    call WriteString

    ; 读入字符串
    lea  edx, STRING
    mov  ecx, N-1
    call ReadString

    ; 保存字符串长度
    mov  Len, ax

    ; 删除连续重复字符
    lea  esi, STRING
    movzx ecx, Len
    call RemoveConsecutiveChar

    ; 字符串倒序存放
    lea  esi, STRING
    mov  ecx, eax
    push eax
    call ReverseString
    pop  eax

    ; 更新字符串长度
    mov  Len, ax

    ; 输出倒序后的字符串
    mov  edx, OFFSET msgOut
    call WriteString
    lea  edx, STRING
    call WriteString
    call Crlf

    ; 输出字符串长度
    mov  edx, OFFSET msgLen
    call WriteString
    movzx eax, Len
    call WriteDec
    call Crlf

    exit
main ENDP

; 删除字符串中连续重复的字符
; 入口: ESI = 字符串首地址, ECX = 字符串长度
; 出口: EAX = 新字符串长度, 字符串原地修改并以0结尾
RemoveConsecutiveChar PROC
    push esi                        ; 保存原始首地址
    push edi
    push ebx

    cmp  ecx, 0
    je   RCD_Exit                   ; 空串直接返回

    mov  edi, esi                   ; edi = 写指针

    mov  bl, [esi]                  ; bl = 上一个写入的字符
    mov  [edi], bl                  ; 写入第一个字符
    inc  esi
    inc  edi
    dec  ecx
    jz   RCD_Finish                 ; 原串长度 = 1, 跳转

RCD_Loop:
    mov  al, [esi]                  ; 读取当前字符
    cmp  al, bl                     ; 与上一个写入的字符比较
    je   RCD_Skip                   ; 相同就跳过
    mov  bl, al                     ; 更新上一个字符
    mov  [edi], al                  ; 写入当前位置
    inc  edi
RCD_Skip:
    inc  esi
    dec  ecx
    jnz  RCD_Loop

RCD_Finish:
    mov  BYTE PTR [edi], 0          ; 末尾写入0

RCD_Exit:
    mov  eax, edi                   ; eax = 写指针
    pop  ebx
    pop  edi
    pop  esi                        ; esi = 原始首地址
    sub  eax, esi                   ; eax = 新长度
    ret
RemoveConsecutiveChar ENDP

; 字符串倒序存放
; 入口: ESI = 字符串首地址, ECX = 字符串长度
; 出口: 字符串原地倒序
ReverseString PROC
    cmp  ecx, 1
    jbe  RS_Done                    ; 长度 <= 1, 无需反转

    lea  edi, [esi+ecx-1]           ; edi = 尾字符地址

RS_Loop:
    cmp  esi, edi
    jae  RS_Done                    ; 指针相遇/交错, 完成

    mov  al, [esi]                  ; 交换首尾字符
    mov  bl, [edi]
    mov  [esi], bl
    mov  [edi], al

    inc  esi
    dec  edi
    jmp  RS_Loop

RS_Done:
    ret
ReverseString ENDP

END main
