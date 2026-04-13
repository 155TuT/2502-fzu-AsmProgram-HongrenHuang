;conv.asm
include irvine32.inc

Decbin PROTO,
  pBuf:PTR WORD,
  pMas:PTR BYTE

.data
  BUF WORD 1234h
  MAS BYTE 4 DUP(?)

.code
main PROC
  INVOKE Decbin, ADDR BUF, ADDR MAS

  mov esi, OFFSET MAS
  mov ecx, LENGTHOF MAS
  mov ebx, TYPE MAS
  call DumpMem

  exit
main ENDP

Decbin PROC USES eax ebx ecx edx esi edi,
  pBuf:PTR WORD,
  pMas:PTR BYTE

  mov ebx, pBuf
  mov edi, pMas
  mov esi, 0
  mov ecx, 4

AGAIN:
  mov dx, [ebx]
  rol dx, 4
  mov [ebx], dx
  and dl, 0Fh
  cmp dl, 0Ah
  jb NUM
  add dl, 7

NUM:
  add dl, 30h
  mov [edi + esi], dl
  movsx eax, BYTE PTR [edi + esi]
  call WriteInt
  call Crlf
  inc esi
  loop AGAIN

  ret
Decbin ENDP

END main
