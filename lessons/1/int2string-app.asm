section .text
global _start

_start:
    mov eax, 1234512345
    mov esi, buffer
    call int2str


    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, edi
    int 0x80


    mov eax, 1
    xor ebx, ebx
    int 0x80




int2str:
    mov edi, 0
    mov ebx, 10
    mov ecx, esi

.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [esi], dl
    inc esi
    inc edi
    test eax, eax
    jnz .loop

    ; Реверс
    mov eax, edi
    dec esi
    mov ebx, ecx

.reverse:
    cmp ebx, esi
    jge .done
    mov al, [ebx]
    mov dl, [esi]
    mov [ebx], dl
    mov [esi], al
    inc ebx
    dec esi
    jmp .reverse

.done:
    ret

section .bss
buffer resb 11
