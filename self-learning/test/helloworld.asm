INCLUDE Irvine32.inc

.data
msg BYTE "Hello, world!", 0Dh, 0Ah, 0

.code
main PROC
    mov edx, OFFSET msg
    call WriteString
    exit
main ENDP

END main