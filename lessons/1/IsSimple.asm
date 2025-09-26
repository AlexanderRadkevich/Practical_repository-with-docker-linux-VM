section .data
    prompt      db "Enter number: ", 0
    prompt_len  equ $ - prompt

    prime_msg   db "Number is prime", 10, 0
    prime_len   equ $ - prime_msg

    notprime_msg db "Number is not prime", 10, 0
    notprime_len equ $ - notprime_msg

    input       times 16 db 0

section .bss
    num resd 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 16
    int 0x80

    mov esi, input
    xor eax, eax
.convert_loop:
    mov bl, [esi]
    cmp bl, 10
    je .done_convert
    cmp bl, 0
    je .done_convert
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp .convert_loop
.done_convert:
    mov [num], eax


    mov ecx, [num]
    cmp ecx, 2
    jl not_prime
    je is_prime

    test ecx, 1
    jz not_prime

    mov ebx, 3
.check_div:
    mov eax, ebx
    imul eax, ebx
    cmp eax, ecx
    ja is_prime

    mov eax, ecx
    xor edx, edx
    div ebx
    cmp edx, 0
    je not_prime

    add ebx, 2
    jmp .check_div


is_prime:
    mov eax, 4
    mov ebx, 1
    mov ecx, prime_msg
    mov edx, prime_len
    int 0x80
    jmp exit

not_prime:
    mov eax, 4
    mov ebx, 1
    mov ecx, notprime_msg
    mov edx, notprime_len
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80


%macro len 1
    %strlen %1 %1_len
    %define %1 %1
    %define len %1 %1_len
%endmacro


