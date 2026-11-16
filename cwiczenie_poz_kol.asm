

wczytaj_do_EAX PROC
    push ebx
    push ecx
    push edx

    ; max ilość znaków wczytywanej liczby
    push dword PTR 12
    push dword PTR OFFSET obszar   ; adres obszaru pamięci
    push dword PTR 0               ; numer urządzenia (0 = klawiatura)
    call __read                    ; (dwa znaki podkreślenia)
    add  esp, 12                   ; usunięcie parametrów ze stosu

    ; bieżąca wartość liczby w EAX, wartość początkowa 0
    mov eax, 0
    mov ebx, OFFSET obszar         ; adres obszaru ze znakami

    pobieraj_znaki:
        mov  cl, [ebx]                 ; kolejna cyfra w ASCII
        inc  ebx                       ; zwiększenie indeksu
        cmp  cl, 10                    ; czy naciśnięto Enter
        je   byl_enter                 ; skok, gdy Enter
        sub  cl, 30H                   ; ASCII → wartość cyfry
        movzx ecx, cl                  ; cyfra do ECX

        mul  dword PTR dziesiec        ; EAX = EAX * 10
        add  eax, ecx                  ; dodanie cyfry
        jmp  pobieraj_znaki

    byl_enter:
        ; wartość liczby jest teraz w EAX
    
    pop edx
    pop ecx
    pop ebx
    ret

wczytaj_do_EAX ENDP