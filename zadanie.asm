.686
.model flat



extern  _ExitProcess@4 : PROC 
extern  __write : PROC 
extern  __read  : PROC 
extern _MessageBoxA@16 : PROC


public  _main

.data
tekst_pocz    db 10, 'Prosze napisac jakis tekst '
              db 'i nacisnac Enter:', 10
koniec_t      db ?
magazyn       db 80 dup (?)
nowa_linia    db 10 
liczba_znakow dd ? 
tytul         db 'Tytul', 0 ; 

.code 
_main   PROC
    
    mov ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz)

    push ecx
    push OFFSET tekst_pocz
    push 1 


    call __write


    add esp, 12; 

    push    80 
    push OFFSET magazyn 
    push    0  
    call    __read 
    add     esp, 12 

    mov     liczba_znakow, eax 
    mov     ecx, eax 
    mov     ebx, 0  
    ; indeks pocz¹tkowy 

ptl:       
    cmp     ecx, 0
    je      wyswietl 

    mov     dl, magazyn[ebx];ko

    cmp     dl, 10
    je      dalej

    cmp     dl, 13

    je      dalej

    cmp     dl, 'A' 
    jb      zamiana_gwiazdka   

    cmp     dl, 'Z'
    jbe     zamiana_mala ;


    cmp     dl, 'a'
    jb      zamiana_gwiazdka

    cmp     dl, 'z'
    jbe     zamiana_duza ; 
    


    jmp     zamiana_gwiazdka 



zamiana_mala:
    add     dl, 20H ; zamiana na ma³¹ literê (+32)
    mov     magazyn[ebx], dl
    jmp     dalej ; skok, aby nie wykony

zamiana_duza:
    sub     dl, 20H ; zamiana na wielk¹ literê (-32)
    mov     magazyn[ebx], dl
    jmp     dalej

zamiana_gwiazdka:
    mov     dl, '*'
    mov     magazyn[ebx], dl
    jmp     dalej

dalej:
    inc  ebx 
    dec ecx 
    jmp  ptl    

wyswietl:
    push liczba_znakow
    push   OFFSET magazyn
    push  1
    call __write
    add esp, 12 



    mov  edi, liczba_znakow
    mov magazyn[edi-1], 0 


    push    0
    push OFFSET tytul  
    push  OFFSET magazyn 
    push  0 
    call  _MessageBoxA@16


    push 0 
    call _ExitProcess@4      


_main ENDP


END


