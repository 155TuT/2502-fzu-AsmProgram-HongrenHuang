;add2.asm
include irvine32.inc

.data	;数据段
    DAT     DWORD 412F2026h, 11111111h
    SUM     DWORD ?
    zeroStr BYTE "0",0

.code	;代码段
main PROC
    mov eax, DAT          ; EAX <- 第1个32位数
    add eax, DAT+4        ; EAX <- 第1个数 + 第2个数
    mov SUM, eax          ; 保存32位和到 SUM

    mov edx, OFFSET zeroStr
    call WriteString      ; 先输出字符 0

    mov eax, SUM
    call WriteHex         ; 再输出十六进制结果
    call Crlf

    exit                  ; 程序正常结束
main ENDP
END main
