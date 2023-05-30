bits 64
section .data 
size equ 1024
mess1:
    db "Enter string: "
len1 equ $-mess1
mess2:
    db "Enter name of file: "
len2 equ $-mess1
filename:
    times 100 db 0
lenfile:
    db 0
descript:
    dd 0
errmess:
    db "Error, no file"
errlen equ $-errmess
str:
    times size db 0
res:
    db "Result: "
newstr:
    times size db 0
ressize:
    dw 0
section .text
global _start
_start:
    mov rax, [rsp]
    cmp eax, 1
    je err
    mov rdi, [rsp+16]
    mov rdi, [rdi]
    mov [filename], rdi
    ;create file
    mov eax, 5
    mov ebx, filename
    mov ecx, 0102o
    mov edx, 0666o
    int 80h
    cmp eax, 0
    jle err
    mov [descript], eax
m0:
    mov eax, 1
    mov edi, 1
    mov esi, mess1
    mov edx, len1
    syscall
    xor eax, eax
    xor edi, edi
    mov esi, str
    mov edx, size
    syscall
    or eax, eax
    jl err
    je m5
    cmp eax, size
    je m5
    ;res buffer
    mov word[res], ax
    mov esi, str
    mov edi, newstr
    cmp byte [rsi+rax-1], 10
    jne err
    xor ecx, ecx
    ;pop rbx
    xor rbx, rbx
    mov byte[rdi], "'"
    inc rbx
    jmp m1
skip:
    cmp rbx, 1
    je m4
    mov byte[rdi+rbx], ' '
    inc rbx
m4:
    inc rcx
    cmp byte[rcx+rsi], ' '
    je m4
    cmp byte[rcx+rsi], 9
    je m4
m1:
    cmp byte[rsi+rcx], ' '
    je skip
    cmp byte[rsi+rcx], 9
    je skip
    ;rax - size of string
    ;esi - source
    cmp byte[rsi+rcx], 10
    je m2
    mov dl, [rsi+rcx]
    %ifdef SH
    add dl, SH
    %else
    add dl, 3
    %endif
    mov [rdi+rbx], dl
    inc bx
    inc cx
    jmp m1
m2:
    cmp byte[rdi+rbx-1], ' '
    jne next
    mov byte[rdi+rbx], "'"
    dec rbx
next:
    mov byte[rdi+rbx], "'"
    inc rbx
    mov byte[rdi+rbx], 10
    mov eax, 4
    mov ecx, newstr
    push rbx
    inc rbx
    mov edx, ebx
    mov ebx, [descript]
    int 80h
    jmp m0
err:
    mov eax, 1
    mov edi, 1
    mov esi, errmess
    mov edx, errlen
    syscall
    mov edi, 1
m5:
    ; close
    mov eax, 6
    mov ebx, [descript]
    int 80h
    mov eax, 60
    syscall
