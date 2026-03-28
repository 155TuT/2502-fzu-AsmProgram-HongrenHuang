;max_in_Xn.asm
include irvine32.inc

.data	;数据段
  DAT WORD 1, -2, 3, -4, 155, -6, 7
  MAX WORD ?

.code	;代码段
main PROC
  mov ecx, LENGTHOF DAT - 1 ; loop symbol
  mov esi, 0                ; index of DAT
  mov ax, DAT[esi]          ; init

AGAIN:
  add esi, 2                ; TYPE DAT = 2
  cmp ax, DAT[esi]          ; compare ax with DAT[esi]
  jge NEXT                  ; jump NEXT if ax greater than DAT[esi](or equal)
  mov ax, DAT[esi]

NEXT:
  dec ecx                   ; (loop symbol)ecx--
  jnz AGAIN                 ; jump AGAIN if ecx not zero(loop)

  mov MAX, ax
  movsx eax, MAX            ; 16bit to 32bit
  call WriteInt             ; output

  exit
main ENDP
END main
