ssection .text

 global _start

 ; 1. entry point
 _start:
     ; 2. prepare parameters to function call
     mov     eax, 123456789
     mov     esi, buffer
     ; 3. call function `int2str`
     call    int2str

     ; 4. prepare parameters to function call
     mov     eax, 4      ; function number: 4-print
     mov     ebx, 1      ; device number:   1-stdout
     mov     ecx, buffer ; buffer to print (updated to use buffer start)
     mov     edx, 11     ; max length of buffer (updated to handle full number)
     ; 5. OS call, print to console
     int     0x80

     ; 6. prepare parameters to function call
     mov     eax, 1
     ; 7. OS call, exit
     int     0x80

 ; EAX - input number
 ; ESI - buffer for output string
 int2str:
     push    ebx         ; save registers
     push    edi

     mov     edi, esi    ; save buffer start for later
     add     esi, 10     ; start from end of buffer (for reverse storage)
     mov     byte [esi], 0 ; null-terminate the string

     ; handle zero case
     cmp     eax, 0
     jne     .loop
     dec     esi
     mov     byte [esi], '0'
     jmp     .done

 .loop:
     cmp     eax, 0      ; check if number is 0
     je      .done       ; if zero, finish

     ; remainder = eax % 10
     xor     edx, edx
     mov     ebx, 10
     div     ebx         ; eax = quotient, edx = remainder

     ; convert remainder to ASCII
     add     dl, 48      ; convert to ASCII ('0' = 48)
     dec     esi         ; move buffer pointer back
     mov     [esi], dl   ; store digit

     jmp     .loop       ; continue with next digit

 .done:
     ; move string to start of buffer if needed
     cmp     esi, edi
     je      .exit       ; already at start, no need to move
     mov     ecx, esi    ; source for copy
     mov     esi, edi    ; destination (buffer start)
 .copy_loop:
     mov     dl, [ecx]   ; get char
     mov     [esi], dl   ; copy to start
     inc     esi
     inc     ecx
     cmp     byte [ecx], 0 ; check for null terminator
     jne     .copy_loop

 .exit:
     pop     edi         ; restore registers
     pop     ebx
     ret

 section .bss
     buffer  resb 11     ; buffer for 10 digits + null terminator
