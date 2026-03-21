;add2.asm
include irvine32.inc

.data	;数据段
    DAT     DWORD 52403137h, 11111111h
    SUM     DWORD ?

.code	;代码段
main PROC
    mov eax, DAT          ; EAX <- 第1个32位数
    add eax, DAT+4        ; EAX <- 第1个数 + 第2个数
    mov SUM, eax          ; 保存32位和到 SUM

    call WriteHex         ; 再输出十六进制结果

    exit                  ; 程序正常结束
main ENDP
END main
