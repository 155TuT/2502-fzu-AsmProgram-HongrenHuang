;eg0101.asm
	include irvine32.inc
.data	;数据段
msg	byte 'Hello, Assembly!',13,10,0	
.code	;代码段
main proc		;主过程定义
	mov edx,offset msg
	call  writestring
	exit 	;程序正常执行结束
main   endp
	end main	;汇编结束
