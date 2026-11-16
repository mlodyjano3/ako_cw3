.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC

public _main

.data
obszar      db   12 dup (?)
dziesiec    dd   10          ; mnożnik
znaki       db   12 dup (?)

.code


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



wyswietl_EAX PROC
    pusha

    mov esi, 10         ; indeks w tablicy 'znaki'
    mov ebx, 10         ; dzielnik równy 10

konwersja:
    mov edx, 0          ; zerowanie starszej części dzielnej
    div ebx             ; dzielenie przez 10, reszta w EDX, iloraz w EAX
    add dl, 30H         ; zamiana reszty z dzielenia na kod ASCII
    mov znaki [esi], dl ; zapisanie cyfry w kodzie ASCII
    dec esi             ; zmniejszenie indeksu
    cmp eax, 0          ; sprawdzenie czy iloraz = 0
    jne konwersja       ; skok, gdy iloraz niezerowy

; wypełnienie pozostałych bajtów spacjami
wypeln:
    or esi, esi
    jz wyswietl         ; skok, gdy ESI = 0
    mov byte PTR znaki [esi], 20H ; kod spacji
    dec esi
    jmp wypeln

wyswietl:
    mov byte PTR znaki [0], 0AH   ; kod nowego wiersza
    mov byte PTR znaki [11], 0AH  ; kod nowego wiersza

    ; wyświetlenie cyfr na ekranie
    push dword PTR 12                  ; liczba wyświetlanych znaków
    push dword PTR OFFSET znaki        ; adres wyświetlanego obszaru
    push dword PTR 1                   ; numer urządzenia (ekran = 1)
    call __write                       ; wyświetlenie liczby na ekranie
    add esp, 12                        ; usunięcie parametrów ze stosu

    popa
    ret
wyswietl_EAX ENDP


zadanie PROC
    push ecx

    call wczytaj_do_EAX

    mov ecx, eax
    mul ecx


    call wyswietl_EAX

    pop ecx
    ret
zadanie ENDP

_main PROC

    call zadanie
    

    push 0
    call _ExitProcess@4

_main ENDP

END