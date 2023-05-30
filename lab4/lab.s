bits	64

section	.data
msg0:
	db	"Input precision", 10, 0
msg1:
	db	"Input a", 10, 0
msg2:
	db	"%lf", 0
msg3:
	db	"Lib result %.10g", 10, 0
msg4:
	db	"Series result %.10g", 10, 0
msg5:
	db	"Input power", 10, 0
errmess:
	db 	"Error opening file", 10, 0
filename:
	db "series.txt", 0
filemode:
	db "w", 0
format:
	db "an=%lf" ,10, 0
descript:
    dw 0
section	.text
one	dq	1.0
mypow:
	movsd	xmm2, [one] ;divisor
	movsd	xmm3, [one] ;cur result
	movsd	xmm4, [one]	;result
	movsd	xmm5, [one] ;one 
	mulsd	xmm6, xmm6 ; square of precision
.m0:
	movsd	xmm7, xmm4 ; prevres
	mulsd	xmm3, xmm0
	mulsd	xmm3, xmm1
	divsd	xmm3, xmm2
	;print to file
	call printfile
	addsd	xmm2, xmm5
	addsd	xmm4, xmm3
	subsd	xmm7, xmm4
	mulsd	xmm7, xmm7
	ucomisd	xmm7, xmm6
	jae	.m0
	movsd	xmm0, xmm4
	ret
x	equ	8
y	equ	16
power equ 24
precision equ 32
extern	printf
extern 	fprintf
extern 	fopen
extern 	fclose
extern	scanf
extern	log
extern	pow
global	main
printfile:
	push rbp
	mov rbp, rsp
	sub rsp, 64
	movsd [rbp-8], xmm0
	movsd [rbp-16], xmm1
	movsd [rbp-24], xmm2
	movsd [rbp-32], xmm3
	movsd [rbp-40], xmm4
	movsd [rbp-48], xmm5
	movsd [rbp-56], xmm6
	movsd [rbp-64], xmm7
	movsd xmm0, xmm3
	mov rdi, [descript]
	mov	rsi, format
	mov rax,1
	and rsp, -16
	call fprintf
	movsd xmm0, [rbp-8]
	movsd xmm1, [rbp-16]
	movsd xmm2, [rbp-24]
	movsd xmm3, [rbp-32]
	movsd xmm4, [rbp-40]
	movsd xmm5, [rbp-48]
	movsd xmm6, [rbp-56]
	movsd xmm7, [rbp-64]

	leave
	ret
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, precision
	;open file
	mov rdi, filename
	mov rsi, filemode
	xor eax, eax
	call fopen
	test rax, rax 
	js .err
	mov [descript], rax
	mov	edi, msg0
	xor	eax, eax
	call	printf

	mov	edi, msg2
	lea	rsi, [rbp-precision]
	xor	eax, eax
	call	scanf
	;
	mov	edi, msg1
	xor	eax, eax
	call	printf
	;
	mov edi, msg2
	lea rsi, [rbp-x]
	xor eax, eax
	call scanf
	;inputing power
	mov	edi, msg5
	xor	eax, eax
	call	printf
	;
	mov edi, msg2
	lea rsi, [rbp-power]
	xor eax, eax
	call scanf
	; lib result
	movsd	xmm0, [rbp-x]
	movsd	xmm1, [rbp-power]
	call	pow
	movsd	[rbp-y], xmm0
	mov	edi, msg3
	;movsd	xmm0, [rbp-x]
	movsd	xmm0, [rbp-y]
	mov	eax, 1
	call	printf

	; precalculate log
	movsd	xmm0, [rbp-x]
	call log
	;
	movsd	xmm1, xmm0
	movsd	xmm0, [rbp-power]
	movsd	xmm6, [rbp-precision]
	call	mypow
	movsd	[rbp-y], xmm0
	mov	edi, msg4
	mov	rax, 1
	call	printf
	mov rdi, [descript]
	xor eax, eax
	call fclose
	leave
	xor	eax, eax
	ret
.err:
	mov	edi, errmess
	xor	eax, eax
	call	printf
	leave
	mov	eax, 1
	ret