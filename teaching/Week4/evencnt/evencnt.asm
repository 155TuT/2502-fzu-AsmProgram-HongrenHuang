; evencnt.asm
include irvine32.inc

; pSrc  = 源数组 DAT 的首地址
; count = 源数组中元素个数
; pDst  = 目标数组 P 的首地址
; pNo   = 变量 no 的地址，用来回传偶数个数
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
    ; 先提示输入要求：一共读入 N 个无符号整数，每个数必须位于 0..65535。
    mov edx, OFFSET promptTitle
    call WriteString
    call Crlf

    mov ecx, LENGTHOF DAT         ; ECX 作为循环次数，表示还需要读入多少个数
    mov esi, 0                    ; ESI 作为偏移量，指向 DAT 中当前待写入的位置

ReadLoop:
    push ecx
    push esi
    mov edx, OFFSET promptEach
    call WriteString
    call ReadInt                  ; EAX = 当前读入的整数
    pop esi
    pop ecx

    ; ReadInt 读入的是有符号整数，因此这里手工检查范围（irvine 中没找到 ReadDec 的方法）
    ; 只允许输入 0..65535 之间的值，才能安全存入 WORD 单元。
    cmp eax, 0
    jl InvalidInput
    cmp eax, 0FFFFh
    ja InvalidInput

    ; 范围合法时，把低 16 位写入 DAT 当前元素。
    mov DAT[esi], ax
    add esi, 2                    ; WORD 占 2 字节，转到下一个数组元素
    loop ReadLoop                 ; ECX = ECX - 1，未读满 N 个则继续
    jmp ReadDone

InvalidInput:
    ; 输入超出范围时，不写入数组，也不减少有效输入次数；
    ; 只提示用户重新输入当前位置的数据。
    push ecx
    push esi
    mov edx, OFFSET msgRetry
    call WriteString
    call Crlf
    pop esi
    pop ecx
    jmp ReadLoop

ReadDone:

    ; 调用子程序扫描 DAT，把其中的偶数依次复制到 P，
    ; 同时通过 no 返回偶数元素个数。
    INVOKE FilterEven, ADDR DAT, N, ADDR P, ADDR no

    ; 先输出提示前缀“P = ”，随后按 no 的值决定是否真的有元素可输出。
    mov edx, OFFSET msgP
    call WriteString

    movzx ecx, WORD PTR no        ; ECX = P 中有效元素个数
    mov esi, 0                    ; ESI 作为偏移量，指向 P 中当前待输出的元素
    jecxz PrintEmpty              ; 若 no = 0，说明 P 为空，直接输出 "(empty)"

PrintLoop:
    ; WriteDec 会改写寄存器，因此先保护循环计数和偏移量。
    push ecx
    push esi
    movzx eax, WORD PTR P[esi]    ; 把当前 WORD 元素零扩展到 EAX，便于十进制输出
    call WriteDec
    pop esi
    pop ecx

    add esi, 2                    ; 转到 P 中下一个 WORD 元素
    dec ecx                       ; 当前元素输出完毕，剩余待输出元素数减 1
    jz PrintNo                    ; 若已经输出完所有偶数，则转去输出 no

    ; 还存在后续元素时，先输出一个空格作为分隔，再继续循环。
    push ecx
    mov al, ' '
    call WriteChar
    pop ecx
    jmp PrintLoop

PrintEmpty:
    ; 当 no = 0 时，P 中没有任何偶数，直接显示空数组标记。
    mov edx, OFFSET msgPEmpty
    call WriteString

PrintNo:
    ; 无论 P 是否为空，最后都换行并输出偶数个数 no。
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

    ; 进入子程序后，把各参数装入寄存器，方便后续循环处理：
    ; ESI = 源数组 DAT 当前元素地址
    ; EDI = 目标数组 P 当前写入地址
    ; EDX = 变量 no 的地址
    ; ECX = 待扫描元素个数，供 LOOP 指令使用
    mov esi, pSrc
    mov edi, pDst
    mov edx, pNo
    mov ecx, count

    ; 先把 no 清零，表示初始时还没有找到任何偶数。
    mov WORD PTR [edx], 0
    jecxz Done                    ; 若 count = 0，则没有数据需要处理，直接返回

ScanLoop:
    ; 取出当前源元素到 AX。
    mov ax, [esi]

    ; 检查最低位是否为 1：
    ; 最低位为 1 表示奇数，最低位为 0 表示偶数。
    ; 若不是偶数，则跳过存储步骤，直接看下一个元素。
    test ax, 1
    jnz NextItem

    ; 当前元素是偶数，把它写入目标数组 P，
    ; 然后把目标指针后移，并将 no 加 1。
    mov [edi], ax
    add edi, 2
    inc WORD PTR [edx]

NextItem:
    ; 无论当前元素是否为偶数，源指针都要后移到下一个 WORD 元素。
    ; LOOP 会自动执行 ECX = ECX - 1，并在 ECX != 0 时继续扫描。
    add esi, 2
    loop ScanLoop

Done:
    ret
FilterEven ENDP

END main
