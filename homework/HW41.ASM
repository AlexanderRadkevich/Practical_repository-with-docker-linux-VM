section .data
msg_in db "Input:",10,0
msg_out db "Factorial (iterative):",10,0
space db " ",0
newline db 10,0
buf db 20

section .text
global _start

_start:
mov ax, 6 ;туто міняти щоб змінить число для факторіалу
mov byte [buf], 0
push eax
call print_input
call print_space
pop eax
mov ax, ax
call factorial_iter
push eax
call print_result
call print_newline
pop eax
mov eax,1
xor ebx,ebx
int 0x80

factorial_iter:
push ebp
mov ebp, esp
movzx ecx, ax
cmp cx, 1
jbe .done
mov eax, 1
.loop:
mul ecx
dec ecx
jnz .loop
.done:
pop ebp
ret

print_input:
push ebp
mov ebp, esp
movzx eax, ax
call print_u32
pop ebp
ret

print_result:
push ebp
mov ebp, esp
movzx eax, ax
call print_u32
pop ebp
ret

print_space:
mov eax,4
mov ebx,1
mov ecx,space
mov edx,1
int 0x80
ret

print_newline:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 0x80
ret

print_u32:
push ebp
mov ebp, esp
push ebx
push ecx
push edx
push edi
mov edi, buf
mov ecx, 0
cmp eax, 0
jne .conv
mov byte [edi], '0'
inc edi
jmp .out
.conv:
mov ebx, 10
.next:
xor edx, edx
div ebx
add dl, '0'
push edx
inc ecx
test eax, eax
jnz .next
.print:
pop edx
mov [edi], dl
inc edi
loop .print
.out:
mov eax, 4
mov ebx, 1
mov ecx, buf
mov edx, edi
sub edx, buf
int 0x80
pop edi
pop edx
pop ecx
pop ebx
pop ebp
ret
