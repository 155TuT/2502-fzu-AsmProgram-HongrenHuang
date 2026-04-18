; evencnt.asm
include irvine32.inc

FilterEven PROTO,
    pSrc:PTR WORD,
    count:DWORD,
    pDst:PTR WORD,
    pNo:PTR WORD

N = 8

.data
promptTitle BYTE "Input 8 unsigned integers (0..65535):", 0
promptEach  BYTE "> ", 0
msgRetry    BYTE "Invalid input, please enter a value in 0..65535.", 0
msgP        BYTE "P = ", 0
msgPEmpty   BYTE "(empty)", 0
msgNo       BYTE "no = ", 0

DAT WORD N DUP(?)
P   WORD N DUP(?)
no  WORD ?

.code
main PROC
    ; 将 N 个无符号整数读入 DAT。
    mov edx, OFFSET promptTitle
    call WriteString
    call Crlf

    mov ecx, N
    mov esi, 0

ReadLoop:
    push ecx
    push esi
    mov edx, OFFSET promptEach
    call WriteString
    call ReadInt
    pop esi
    pop ecx

    cmp eax, 0
    jl InvalidInput
    cmp eax, 0FFFFh
    ja InvalidInput

    mov DAT[esi], ax
    add esi, 2
    loop ReadLoop
    jmp ReadDone

InvalidInput:
    push ecx
    push esi
    mov edx, OFFSET msgRetry
    call WriteString
    call Crlf
    pop esi
    pop ecx
    jmp ReadLoop

ReadDone:

    ; 构造数组 P，并统计找到的偶数个数。
    INVOKE FilterEven, ADDR DAT, N, ADDR P, ADDR no

    ; 输出数组 P。
    mov edx, OFFSET msgP
    call WriteString

    movzx ecx, WORD PTR no
    mov esi, 0
    jecxz PrintEmpty

PrintLoop:
    push ecx
    push esi
    movzx eax, WORD PTR P[esi]
    call WriteDec
    pop esi
    pop ecx

    add esi, 2
    dec ecx
    jz PrintNo

    push ecx
    mov al, ' '
    call WriteChar
    pop ecx
    jmp PrintLoop

PrintEmpty:
    mov edx, OFFSET msgPEmpty
    call WriteString

PrintNo:
    call Crlf
    mov edx, OFFSET msgNo
    call WriteString
    movzx eax, WORD PTR no
    call WriteDec
    call Crlf

    exit
main ENDP

FilterEven PROC USES eax ecx edx esi edi,
    pSrc:PTR WORD,
    count:DWORD,
    pDst:PTR WORD,
    pNo:PTR WORD

    ; ESI 用于扫描 DAT，EDI 用于填充 P，[EDX] 用于保存 no。
    mov esi, pSrc
    mov edi, pDst
    mov edx, pNo
    mov ecx, count
    mov WORD PTR [edx], 0
    jecxz Done

ScanLoop:
    mov ax, [esi]
    test ax, 1
    jnz NextItem

    mov [edi], ax
    add edi, 2
    inc WORD PTR [edx]

NextItem:
    add esi, 2
    loop ScanLoop

Done:
    ret
FilterEven ENDP

END main
