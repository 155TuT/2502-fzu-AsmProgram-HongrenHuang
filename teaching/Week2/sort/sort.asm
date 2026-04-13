;sort.asm
include irvine32.inc

.data
  TAB byte 1, 2, 137, 4, 5, 6
  N = LENGTHOF TAB
  DAT byte N DUP(?)

.code
main PROC
  mov ecx, N
  mov esi, 0

COPY_TAB:
  mov al, TAB[esi]
  mov DAT[esi], al
  inc esi
  loop COPY_TAB ; 循环通过 al 将 TAB 复制到 DAT 中

  mov ecx, N - 1

AGAIN1:
  mov edi, ecx
  mov ebx, 0

AGAIN2:
  mov al, DAT[ebx]
  cmp al, DAT[ebx + 1]
  jae NEXT
  xchg al, DAT[ebx + 1] ; 不手动申请额外寄存器进行交换
  mov DAT[ebx], al

NEXT:
  inc ebx
  dec ecx
  jnz AGAIN2

  mov ecx, edi
  dec ecx
  jnz AGAIN1

  mov ecx, LENGTHOF DAT
  mov esi, 0

PRINT:
  push ecx
  movzx eax, DAT[esi]
  call WriteDec
  mov al, ' '
  call WriteChar ; 数据之间输出空格
  pop ecx
  inc esi
  dec ecx
  jnz PRINT

  exit

main ENDP
END main
