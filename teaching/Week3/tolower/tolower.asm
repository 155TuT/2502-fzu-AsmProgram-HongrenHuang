;tolower.asm
include irvine32.inc

MAX = 80

pString EQU <[ebp+8]>
strLen  EQU <[ebp+12]>

.data
  string BYTE MAX + 1 DUP(?)

.code
main PROC
  mov edx, OFFSET string
  mov ecx, SIZEOF string - 1
  call ReadString

  push eax
  push OFFSET string
  call ToLower

  mov edx, OFFSET string
  call WriteString
  call Crlf

  exit
main ENDP

ToLower PROC
  push ebp
  mov ebp, esp
  push eax
  push ecx
  push esi

  mov esi, pString
  mov ecx, strLen
  jecxz DONE

AGAIN:
  mov al, [esi]
  cmp al, 'A'
  jb NEXT
  cmp al, 'Z'
  ja NEXT
  add BYTE PTR [esi], 20h

NEXT:
  inc esi
  loop AGAIN

DONE:
  pop esi
  pop ecx
  pop eax
  pop ebp
  ret 8
ToLower ENDP

END main
