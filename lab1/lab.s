bits 64
; ((a+b)^2 - (c-d)^2) / (a+e^3-c)
section .data
res:
	dq 0
a:
	dd 5
b:
	dd 2
c:
	dd 6
d:
	dd 3
e:
	db 1

section .text
global _start
_start:

	mov eax, dword[a]
	mov ebx, dword[b]
	add rax, rbx
	mul rax
	mov edi, dword[c]
	mov ebx, dword[d]
	sub rdi, rbx
	jc divzero
	mov rcx, rax
	mov rax, rdi
	mul rax
	sub rcx, rax
	jc divzero
	movzx rax, byte[e]
	mul rax
	mul rax
	mul rax
	mov rbx, rax
	mov edi, dword[a]
	mov esi, dword[c]
	add rbx, rdi
	cmp rbx, rsi
	jbe divzero
	sub rbx, rsi
	jc divzero
	mov rax, rcx
	div rbx
	mov qword[res], rax
	mov rax, 60
	mov edi, 0
	syscall


divzero:
	mov rax, 60
	mov edi, 0
	syscall
