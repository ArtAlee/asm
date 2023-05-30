bits 64
section .data
m:
    dw 5
n:
    dw 3
matrix:
    dw 14, 2, 1, 8, 2
    dw 5, 7, 1, 4, 12
    dw 6, 12, 31, 11, 1
min:
    dw 0, 0, 0, 0, 0

section .text
global _start
_start:
    mov cx, [m]
    cmp cx, 1
    jle final

    mov rbx, matrix

premin:
    xor di, di
    mov ax, [rbx]
    push rcx
    mov cx, [n]
    dec cx
    jrcxz nextcol
findmin:
    add di, [m]
    cmp ax, [rbx+rdi*2]
    cmovg ax, [rbx+rdi*2]
    loop findmin
nextcol:
    add di, [m]
    mov [rbx+rdi*2], ax
    add bx, 2
    pop rcx
    loop premin
    xor bx, bx
    xor rsi, rsi
    mov cx, [m]
    push rcx
pre:
    push rcx
    xor si, si
    mov si, 1
    test cx, 1
    pop rcx
    jz cycle
    mov si, 2

cycle:
    mov ax, [min - 2 + rsi*2]
    mov bx, [min+ rsi*2]
    cmp ax, bx
    %ifidni SORT_ORDER, ASC
    jle cont
    %else
    jge cont
    %endif
    mov [min -2+ rsi*2], bx
    mov [min + rsi*2], ax
    mov rax, matrix
    jmp prechange
cont:
    inc si
    inc si
    cmp si, [m]
    jl cycle
    loop pre
    jmp final
prechange:
    push rcx
    movzx rcx, word [n]
changecol:
    xor rdx, rdx
    xor rbx, rbx
    mov dx, word[rax+ rsi*2]
    mov bx, word[rax-2+rsi*2]
    mov [rax+ rsi*2], bx
    mov [rax-2+rsi*2], dx
    mov dx, [m]
    shl dx, 1
    add ax, dx
    loop changecol
    pop rcx
    jmp cont
final:
    mov eax, 60
    xor edi, edi
    syscall
;x/15hd &matrix - enter in gdb to see values of matrix
