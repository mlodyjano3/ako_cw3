


EncodeBlock PROC
    push esi
    push edi
    push ecx
    push ebx

    xor eax, eax

    petla:
        cmp ecx, 0
        jz koniec

        mov bl, byte ptr [esi]
        add bl, 20h
        jnc dalej

        inc eax


    
    dalej:
        mov byte ptr [edi], bl

        dec ecx
        inc edi
        inc esi
        jmp petla



    koniec:
        pop ebx
        pop ecx
        pop edi
        pop esi
        ret
EncodeBlock ENDP