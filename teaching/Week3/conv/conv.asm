; conv.asm
include irvine32.inc

; Decbin 使用 PROTO/INVOKE 定义，参数通过栈按 stdcall 方式传递：
; pBuf = 指向 WORD 源数据的地址
; pMas = 指向 BYTE 输出缓冲区的地址
Decbin PROTO,
  pBuf:PTR WORD,
  pMas:PTR BYTE

.data
  BUF WORD 1234h
  MAS BYTE 4 DUP(?)               ; 保存转换得到的 4 个 ASCII 字符

.code
main PROC
  ; INVOKE 会根据 PROTO 自动压栈传参：
  ; ADDR BUF -> pBuf
  ; ADDR MAS -> pMas
  INVOKE Decbin, ADDR BUF, ADDR MAS

  ; DumpMem 使用寄存器传参：
  ; ESI = 要显示的内存首地址
  ; ECX = 元素个数
  ; EBX = 每个元素的字节数
  mov esi, OFFSET MAS
  mov ecx, LENGTHOF MAS
  mov ebx, TYPE MAS
  call DumpMem

  exit
main ENDP

Decbin PROC USES eax ebx ecx edx esi edi,
  pBuf:PTR WORD,
  pMas:PTR BYTE

  ; USES 会自动保存并恢复 eax、ebx、ecx、edx、esi、edi
  ; 这里把栈上传入的参数读到寄存器里：
  ; EBX = 输入 WORD 的地址
  ; EDI = 输出数组的首地址
  mov ebx, pBuf
  mov edi, pMas
  mov esi, 0                      ; ESI = 当前输出下标
  mov ecx, 4                      ; ECX = 循环次数，共处理 4 个半字节

AGAIN:
  mov dx, [ebx]
  rol dx, 4                       ; 把下一个待处理半字节转到低 4 位
  mov [ebx], dx                   ; 写回后，下一轮继续在新位置上旋转
  and dl, 0Fh                     ; DL 只保留当前半字节
  cmp dl, 0Ah
  jb NUM
  add dl, 7                       ; 0Ah~0Fh 需要补上 'A'~'F' 的偏移

NUM:
  add dl, 30h                     ; 转成 ASCII 码
  mov [edi + esi], dl             ; 把 ASCII 字符写到输出数组
  movsx eax, BYTE PTR [edi + esi] ; WriteInt 使用 EAX 传参，这里传入当前字符的 ASCII 码
  call WriteInt
  call Crlf                       ; Crlf 无参数，直接输出换行
  inc esi
  loop AGAIN

  ret
Decbin ENDP

END main
