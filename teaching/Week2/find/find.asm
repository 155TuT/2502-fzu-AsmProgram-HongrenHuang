;find.asm
include irvine32.inc

.data
  TAB byte 1, 2, 137, 4, 5, 6
  DAT byte 137
  NO byte ?

.code
main PROC
  mov dl, 0
  mov ecx, LENGTHOF TAB
  mov esi, 0
  mov al, DAT

AGAIN:
  cmp TAB[esi], al
  je FOUND

  inc esi
  inc dl
  dec ecx
  jz NOTFOUND
  jmp AGAIN

FOUND:
  mov NO, dl
  movzx eax, NO
  call WriteDec
  exit

NOTFOUND:
  mov NO, 0FFh
  movzx eax, NO
  call WriteHex
  exit

main ENDP
END main
