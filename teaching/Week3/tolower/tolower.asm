;tolower.asm
include irvine32.inc

MAX = 80
; ToLower 过程使用栈传参：
; [ebp+8]  = pString，字符串首地址
; [ebp+12] = strLen，字符串长度
pString EQU <[ebp+8]>
strLen  EQU <[ebp+12]>

.data
  string BYTE MAX + 1 DUP(?)    ; ReadString 的输入缓冲区，额外 1 字节留给结尾 0

.code
main PROC
  ; ReadString 使用寄存器传参：
  ; EDX = 缓冲区首地址
  ; ECX = 最多可接收的字符数（不含结尾 0）
  mov edx, OFFSET string
  mov ecx, SIZEOF string - 1
  call ReadString    ; 返回时 EAX = 实际读入的字符个数
  ; ToLower 使用手工压栈的方式传参，顺序是从右到左：
  ; 先 push eax，把长度作为第 2 个参数压栈
  ; 再 push OFFSET string，把地址作为第 1 个参数压栈
  ; 进入过程后分别通过 [ebp+12] 和 [ebp+8] 取出
  push eax
  push OFFSET string
  call ToLower
  ; WriteString 使用寄存器传参：
  ; EDX = 以 0 结尾的字符串地址
  mov edx, OFFSET string
  call WriteString
  call Crlf    ; Crlf 无参数，直接输出换行

  exit
main ENDP

ToLower PROC
  push ebp
  mov ebp, esp
  push eax
  push ecx
  push esi

  mov esi, pString                ; ESI = 当前待处理字符的地址
  mov ecx, strLen                 ; ECX = 循环次数，来自调用者传入的长度
  jecxz DONE                      ; 长度为 0 时直接返回

AGAIN:
  mov al, [esi]
  cmp al, 'A'
  jb NEXT
  cmp al, 'Z'
  ja NEXT
  add BYTE PTR [esi], 20h         ; ASCII 大写字母转为小写字母

NEXT:
  inc esi
  loop AGAIN

DONE:
  pop esi
  pop ecx
  pop eax
  pop ebp
  ret 8                           ; 被调用者一次性弹出 2 个 DWORD 参数
ToLower ENDP

END main
