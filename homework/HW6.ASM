section .data
    original_array db 5, 1, 4, 2, 3  ; Sample bytes to sort
    sorted_array times 5 db 0         ; Destination buffer
    print_buffer times 6 db 0         ; 5 digits + \n

section .bss

section .text
global _start

_start:
    ; Prepare parameters
    lea rsi, [rel original_array]  ; RSI = address of original array
    lea rdi, [rel sorted_array]    ; RDI = address of sorted array
    mov rcx, 5                     ; RCX = 5 bytes
    mov rbx, 1                     ; RBX = 1 byte elements

    call mysort

    ; Print sorted array (assuming single digits for simplicity)
    lea rsi, [rel sorted_array]
    mov rbx, 0
print_loop:
    mov al, [rsi + rbx]
    add al, '0'
    mov [rel print_buffer + rbx], al
    inc rbx
    cmp rbx, 5
    jl print_loop
    mov byte [rel print_buffer + 5], 10  ; \n

    ; Syscall: write to stdout
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel print_buffer]
    mov rdx, 6
    syscall

    ; Exit with success
    mov rax, 60
    xor rdi, rdi
    syscall

; mysort function
mysort:
    push rbp
    mov rbp, rsp
    push r12
    push r13  ; Need for index calc

    push rcx

    mov rax, [rsp]
    xor rdx, rdx
    div rbx
    mov r9, rax

    pop rcx

    mov r8, rdi
    rep movsb

    mov rdi, r8

    cmp rbx, 1
    je sort_bytes
    cmp rbx, 2
    je sort_words
    cmp rbx, 4
    je sort_dwords
    cmp rbx, 8
    je sort_qwords
    jmp func_end

sort_bytes:
    mov r10, 0
sort_bytes_outer:
    mov r11, r9
    sub r11, r10
    dec r11
    test r11, r11
    jle sort_bytes_outer_end
    mov r12, 0
sort_bytes_inner:
    mov r13, r12
    mov al, byte [rdi + r13]
    mov dl, byte [rdi + r13 + 1]
    cmp al, dl
    jbe sort_bytes_no_swap
    xchg al, dl
    mov byte [rdi + r13], al
    mov byte [rdi + r13 + 1], dl
sort_bytes_no_swap:
    inc r12
    cmp r12, r11
    jl sort_bytes_inner
    inc r10
    cmp r10, r9
    jl sort_bytes_outer
sort_bytes_outer_end:
    jmp func_end

sort_words:
    mov r10, 0
sort_words_outer:
    mov r11, r9
    sub r11, r10
    dec r11
    test r11, r11
    jle sort_words_outer_end
    mov r12, 0
sort_words_inner:
    mov r13, r12
    shl r13, 1
    mov ax, word [rdi + r13]
    mov dx, word [rdi + r13 + 2]
    cmp ax, dx
    jbe sort_words_no_swap
    xchg ax, dx
    mov word [rdi + r13], ax
    mov word [rdi + r13 + 2], dx
sort_words_no_swap:
    inc r12
    cmp r12, r11
    jl sort_words_inner
    inc r10
    cmp r10, r9
    jl sort_words_outer
sort_words_outer_end:
    jmp func_end

sort_dwords:
    mov r10, 0
sort_dwords_outer:
    mov r11, r9
    sub r11, r10
    dec r11
    test r11, r11
    jle sort_dwords_outer_end
    mov r12, 0
sort_dwords_inner:
    mov r13, r12
    shl r13, 2
    mov eax, dword [rdi + r13]
    mov edx, dword [rdi + r13 + 4]
    cmp eax, edx
    jbe sort_dwords_no_swap
    xchg eax, edx
    mov dword [rdi + r13], eax
    mov dword [rdi + r13 + 4], edx
sort_dwords_no_swap:
    inc r12
    cmp r12, r11
    jl sort_dwords_inner
    inc r10
    cmp r10, r9
    jl sort_dwords_outer
sort_dwords_outer_end:
    jmp func_end

sort_qwords:
    mov r10, 0
sort_qwords_outer:
    mov r11, r9
    sub r11, r10
    dec r11
    test r11, r11
    jle sort_qwords_outer_end
    mov r12, 0
sort_qwords_inner:
    mov r13, r12
    shl r13, 3
    mov rax, [rdi + r13]
    mov rdx, [rdi + r13 + 8]
    cmp rax, rdx
    jbe sort_qwords_no_swap
    xchg rax, rdx
    mov [rdi + r13], rax
    mov [rdi + r13 + 8], rdx
sort_qwords_no_swap:
    inc r12
    cmp r12, r11
    jl sort_qwords_inner
    inc r10
    cmp r10, r9
    jl sort_qwords_outer
sort_qwords_outer_end:
    jmp func_end

func_end:
    pop r13
    pop r12
    pop rbp
    ret
