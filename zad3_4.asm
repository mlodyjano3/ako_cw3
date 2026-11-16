.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC

public _main

.data
obszar      db   12 dup (?)
dziesiec    dd   10                  ; mnożnik
dekoder     db   '0123456789ABCDEF'  ; tablica cyfr hex

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

    mov eax, 0
    mov ebx, OFFSET obszar

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
    pop edx
    pop ecx
    pop ebx
    ret
wczytaj_do_EAX ENDP


wyswietl_EAX_hex PROC
    ; wyświetlanie zawartości rejestru EAX
    ; w postaci liczby szesnastkowej
    pusha

    ; rezerwacja 12 bajtów na stosie na cyfry hex
    sub esp, 12
    mov edi, esp          ; adres zarezerwowanego obszaru

    ; przygotowanie konwersji
    mov ecx, 8            ; liczba obiegów pętli (8 cyfr hex)
    mov esi, 1            ; indeks początkowy (0 = miejsce na \n)

ptl3hex:
    rol eax, 4            ; obrót EAX o 4 bity w lewo

    mov ebx, eax          ; kopia EAX do EBX
    and ebx, 0000000FH    ; zerowanie bitów 31-4, zostają 4 najmłodsze
    mov dl, dekoder[ebx]  ; pobranie cyfry z tablicy

    mov [edi][esi], dl    ; zapis cyfry do bufora

    inc esi
    loop ptl3hex

    ; znaki nowego wiersza przed i po cyfrach
    mov byte PTR [edi][0], 10
    mov byte PTR [edi][9], 10

    ; wyświetlenie przygotowanych cyfr
    push 10               ; 8 cyfr + 2 znaki nowego wiersza
    push edi              ; adres bufora
    push 1                ; numer urządzenia (ekran)
    call __write

    ; usunięcie 12 bajtów parametrów + 12 bajtów bufora
    add esp, 24

    popa
    ret
wyswietl_EAX_hex ENDP


_main PROC

    call wczytaj_do_EAX

    call wyswietl_EAX_hex

    push 0
    call _ExitProcess@4

_main ENDP

END