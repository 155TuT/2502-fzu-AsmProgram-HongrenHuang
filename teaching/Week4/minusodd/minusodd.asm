; minusodd.asm
include irvine32.inc

N = 8

.data
promptX     BYTE "X = ", 0
promptTitle BYTE "Input 8 signed integers:", 0
promptEach  BYTE "> ", 0
msgAbsMin   BYTE "|Min| = ", 0

TAB SDWORD N DUP(?)
X   DWORD 10
Min SDWORD 0

.code
main PROC
    ; 先显示给定的阈值 X，便于和后面输入的数据进行对照。
    mov edx, OFFSET promptX
    call WriteString
    mov eax, X
    call WriteDec
    call Crlf

    ; 提示用户依次输入 N 个有符号整数，并把它们顺序存入 TAB 数组。
    mov edx, OFFSET promptTitle
    call WriteString
    call Crlf

    mov ecx, LENGTHOF TAB         ; ECX 作为循环次数，表示还要读入多少个数
    mov esi, OFFSET TAB           ; ESI 指向当前要写入的数组元素

ReadLoop:
    ; ReadInt/WriteString 可能会改写寄存器，
    ; 所以先把循环计数和当前数组指针压栈保护起来。
    push ecx
    push esi

    mov edx, OFFSET promptEach
    call WriteString
    call ReadInt                  ; EAX = 当前输入的有符号整数

    pop esi
    pop ecx

    mov [esi], eax                ; 把刚输入的整数写入 TAB 当前单元
    add esi, 4                    ; SDWORD 占 4 字节，转到下一个数组元素
    loop ReadLoop

    ; 先把 Min 清为 0。
    ; 本题约定：若最终 Min 仍为 0，表示没有找到满足条件的负奇数。
    mov Min, 0

    ; 手工压栈传参。
    ; 压栈顺序从右到左，因此最后一个压栈的是第 1 个参数。
    ;
    ; push LENGTHOF TAB  -> [EBP+20]，数组长度 n
    ; push OFFSET TAB    -> [EBP+16]，TAB 首地址
    ; push X             -> [EBP+12]，阈值 X 的值
    ; push OFFSET Min    -> [EBP+8]，Min 的地址
    push LENGTHOF TAB
    push OFFSET TAB
    push X
    push OFFSET Min
    call ODMIN

    ; 子程序返回后，Min 中保存的是“绝对值大于 X 的最小负奇数”。
    ; 终端要求显示它的绝对值，因此若 Min 为负，要先取反。
    mov edx, OFFSET msgAbsMin
    call WriteString

    mov eax, Min
    test eax, eax
    jge PrintAbs
    neg eax

PrintAbs:
    ; 此时 EAX 一定是非负数，直接按无符号十进制输出即可。
    call WriteDec
    call Crlf

    exit
main ENDP

ODMIN PROC
    push ebp
    mov ebp, esp

    ; 进入子程序后通过 EBP+偏移量取参数：
    ; [EBP+8]  = Min 的地址
    ; [EBP+12] = X 的值
    ; [EBP+16] = TAB 首地址
    ; [EBP+20] = TAB 中元素个数 n

    ; 为了后续循环方便，先把参数分别放入常用寄存器中：
    ; ECX = n，供 LOOP 指令自动减 1 使用
    ; ESI = TAB 当前元素地址
    ; EAX = X 的值
    ; EDI = Min 的地址
    mov ecx, DWORD PTR [ebp+20]
    mov esi, DWORD PTR [ebp+16]
    mov eax, DWORD PTR [ebp+12]
    mov edi, DWORD PTR [ebp+8]

    ; 如果 n = 0，就没有数据可处理，直接返回。
    jecxz Done

Again2:
    ; 取出当前数组元素到 EDX。
    ; 后面的奇偶判断、正负判断和比较都围绕这个数进行。
    mov edx, DWORD PTR [esi]

    ; 先判断当前数是不是奇数。
    ; 最低位为 1 表示奇数，最低位为 0 表示偶数。
    ; TEST 不会改写 EDX，只会根据按位与结果设置标志位。
    test edx, 00000001h
    je Next

    ; 再判断当前数是不是负数。
    ; 对 32 位带符号整数来说，最高位是符号位：
    ; 最高位为 1 表示负数，最高位为 0 表示非负数。
    ; 若 ZF = 1，说明最高位与 80000000h 按位与后为 0，即当前数不是负数。
    test edx, 80000000h
    je Next

    ; 走到这里，EDX 已经确定是一个负奇数。
    ; 题目要求它的绝对值必须大于 X，所以先求绝对值。
    neg edx

    ; 比较 |当前值| 和 X。
    ; 若 |当前值| <= X，则不满足条件，跳过当前元素。
    cmp edx, eax
    jbe Next

    ; 若 |当前值| > X，则再取反一次，把 EDX 恢复成原来的负数。
    ; 这样后面才能正确比较“哪个负数更小”。
    neg edx

    ; 这里不再额外设置 found 标志，而是直接利用 Min 的初值 0 来判断。
    ; 因为 Min 的初值是 0，而任何满足条件的负数都一定小于 0，
    ; 所以第一次找到符合条件的数时，必然会更新 Min。
    ; 之后只有当新的负数更小（数值更负）时，才再次更新。
    cmp edx, DWORD PTR [edi]
    jge Next

    ; 当前负奇数更小，用它覆盖原先的 Min。
    mov DWORD PTR [edi], edx

Next:
    ; ESI 后移 4 字节，指向 TAB 的下一个 SDWORD 元素。
    ; LOOP 会自动执行 ECX = ECX - 1，并在 ECX != 0 时跳回 Again2。
    add esi, 4
    loop Again2

Done:
    pop ebp
    ret 16
ODMIN ENDP

END main
