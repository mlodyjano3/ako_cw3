.686
.model flat

extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main


.data

podaj_n db 'Podaj n i wcisnij enter: '
dl_n EQU $ - podaj_n
liczba_n dd ?

podaj_a0 db 'Podaj a0 i wcisnij enter: '
dl_a0 EQU $ - podaj_a0
liczba_a dd ?

podaj_r db 'Podaj R i wcisnij enter: '
dl_r EQU $ - podaj_r
liczba_r dd ?

dekoder db '0123456789ABCDEF'

dziesiec dd 10

obszar db   12 dup (?) ; bufor na znaki wczytywane z klawiatury
znaki   db   12 dup (?) ; bufor na cyfry dziesietne do wyswietlenia



.code

wczytaj_do_EAX PROC
    push ebx
    push ecx
    push edx

    push dword PTR 12
    push dword PTR OFFSET obszar
    push dword PTR 0
    call __read
    add  esp, 12

    mov  eax, 0
    mov  ebx, OFFSET obszar

pobieraj_znaki:
    mov  cl, [ebx]
    inc  ebx
    cmp  cl, 10
    je   byl_enter
    sub  cl, 30H
    movzx ecx, cl

    mul  dword PTR dziesiec
    add  eax, ecx
    jmp  pobieraj_znaki

byl_enter:
    pop  edx
    pop  ecx
    pop  ebx
    ret
wczytaj_do_EAX ENDP



wyswietl_EAX PROC
    pusha

    mov  esi, 10
    mov  ebx, 10

konwersja:
    mov  edx, 0
    div  ebx
    add  dl, 30H
    mov  znaki [esi], dl
    dec  esi
    cmp  eax, 0
    jne  konwersja

wypeln:
    or   esi, esi
    jz   wyswietl
    mov  byte PTR znaki [esi], 20H
    dec  esi
    jmp  wypeln

wyswietl:
    mov  byte PTR znaki [0], 20h ;; 0Ah -> 20h  
    mov  byte PTR znaki [11], 20h 

    push dword PTR 12
    push dword PTR OFFSET znaki
    push dword PTR 1
    call __write
    add  esp, 12

    popa
    ret
wyswietl_EAX ENDP



wyswietl_EAX_hex PROC
    pusha

    sub  esp, 12
    mov  edi, esp

    mov  ecx, 8
    mov  esi, 1

ptl3hex:
    rol  eax, 4

    mov  ebx, eax
    and  ebx, 0000000FH

    mov  dl, dekoder[ebx]

    mov  [edi][esi], dl

    inc  esi
    loop ptl3hex

    ; zera nieznaczace z lewej -> spacje (sprawdzamy 7 pierwszych cyfr)
    mov  ecx, 7
    mov  esi, 1
zmiana:
    cmp  byte ptr [edi+esi], 30h
    jne  niezero

    mov  byte ptr [edi+esi], 20h

    inc  esi
    loop zmiana
niezero:

    mov  byte PTR [edi][0], 20h ;; zmiana 10 -> 20h 
    mov  byte PTR [edi][9], 10

    push 10
    push edi
    push 1
    call __write

    add  esp, 24

    popa
    ret
wyswietl_EAX_hex ENDP


_main PROC

    ;; wczytywanie do odpowiednich etykiet odpowiednych danych

    push dword PTR dl_n
    push OFFSET podaj_n
    push dword PTR 1
    call __write
    add esp, 12

    call wczytaj_do_EAX
    mov liczba_n, eax

    push dword PTR dl_a0
    push OFFSET podaj_a0
    push dword PTR 1
    call __write
    add esp, 12

    call wczytaj_do_EAX
    mov liczba_a, eax

    push dword PTR dl_r
    push OFFSET podaj_r
    push dword PTR 1
    call __write
    add esp, 12

    call wczytaj_do_EAX
    mov liczba_r, eax

    ;; dane wczytane




    ;; wyswietlanie, matematyka, liczenie
    mov eax, liczba_a
    call wyswietl_EAX
    call wyswietl_EAX_hex


    mov ecx, liczba_n
    ptl:
        add eax, liczba_r

        call wyswietl_EAX
        call wyswietl_EAX_hex
        loop ptl


    push 0
    call _ExitProcess@4

_main ENDP

END