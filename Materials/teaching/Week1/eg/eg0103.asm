include irvine32.inc

.data
    input_msg   BYTE "Please input a number: ",0
    output_msg  BYTE "The half result is: ",0
    newline     BYTE 13,10,0

.code
main PROC
    ; 提示输入
    mov edx, OFFSET input_msg
    call WriteString

    ; 读入整数，结果存入 EAX
    call ReadInt

    ; 先右移一位
    ; SHR 会把原最低位送入 CF
    ; 如果原来最低位是1，说明原数是奇数
    ; 如果原来最低位是0，说明原数是偶数
    shr eax, 1

    ; 根据 CF 判断奇偶
    jc odd_num          ; CF=1，说明原数是奇数，跳转
    jmp even_num        ; CF=0，说明原数是偶数，跳转

odd_num:
    add eax, 1
    jmp show_result

even_num:
    ; 偶数不用额外处理
    jmp show_result

show_result:
    mov edx, OFFSET output_msg
    call WriteString
    call WriteInt

    mov edx, OFFSET newline
    call WriteString

    exit
main ENDP

END main