bits	64
section	.text
image	equ	16
gray    equ 8

global	toGray2
; r15 - указатель на серое изображение 
; rdi - указатель на цветное изображение
; rsi - ширина изображения в пикселях
; rdx - высота изображения в пикселях
toGray2:
	push rbp
	mov rbp, rsp
    sub rsp, 16
	mov	r13, rdi
	mov	r14, rsi
	mov r11, rdx
	mov	r12, rcx
	xor	rcx, rcx
	xor	rax, rax
	mov	r8, 3
	xor rsi, rsi
	xor r9, r9
.m0:
	xor rbx,rbx
.m1:
	xor rax, rax
	xor rdx, rdx
	xor rcx, rcx
	mov al, byte[r14]
	mov	cl, byte[r14+1]
	mov dl, byte[r14+2]
	add	eax, ecx
	add	eax, edx
	xor rdx, rdx
	div r8
	mov byte[r13], al
	inc r13
	add r14, r8
	inc	ebx
	cmp	rbx, r11
	jne	.m1
	inc esi
	cmp rsi, r12
	jne	.m0
    add rsp, 16
	leave
	ret