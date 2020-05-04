section .data
    tit      db  10, '-----------------',10, '| Calculadora |',10, '| Calculadora |',10 ,0
    ltit     equ $ - tit
    obVal1   db  10,'Valor 1:',0
    lobVal1  equ $ - obVal1  
    obVal2   db  10,'Valor 2:',0
    lobVal2  equ $ - obVal2
    opc1     db  10,'1. Adicionar',0
    lopc1    equ $- opc1
    opc2     db  10,'2. Subtrair',0
    lopc2    equ $- opc2
    opc3     db  10,'3. Multiplicar',0
    lopc3    equ $- opc3
    opc4     db  10,'4. Dividir',0
    lopc4    equ $- opc4
    msgOpc   db  10,'Deseja Realizar?',0
    lmsgOpc  equ $- msgOpc
    msgErro  db  10,'Valor da opção invalida!!',0
    lmsgErro equ $- msgErro
    nLinha   db 10,0
    lLinha   equ $ - nLinha

section .bss
    opc      resb 2
    num1     resb 10
    num2     resb 10
    result   resb 10

section .text
    global _start

_start:
    mov ecx, tit
    mov edx, ltit
    call mst_saida

    mov ecx, obVal1 
    mov edx, lobVal1
    call mst_saida ;printar msg
    mov ecx, num1
    mov edx, 10
    call ler ; ler valor 

    mov ecx, obVal2
    mov edx, lobVal2
    call mst_saida
    mov ecx, num2
    mov edx, 10
    call ler

    mov ecx, opc1 ; opção de adição
    mov edx, lopc1
    call mst_saida

    mov ecx, opc2 ; opção de subtração
    mov edx, lopc2
    call mst_saida
    
    mov ecx, opc3 ; opção de multiplicação
    mov edx, lopc3
    call mst_saida

    mov ecx, opc4 ; opção de divisão
    mov edx, lopc4
    call mst_saida

    mov ecx, msgOpc
    mov edx, lmsgOpc
    call mst_saida
    mov ecx, opc
    mov edx, 2
    call ler

    mov ah, [opc]
    sub ah, '0'

    cmp ah, 1
    je adicionar 
    cmp ah, 2
    je subtrair 
    cmp ah, 3
    je multiplicar 
    cmp ah, 4
    je dividir 
    mov ecx, msgErro
    mov edx, lmsgErro
    call mst_saida
    jmp saida 


adicionar:
    xor eax, eax
    xor ebx, ebx
    lea esi,[num1]
    mov ecx, 1
    call string_to_int ; eax = num1
    lea esi, [num2]
    mov ecx, 1
    call string_to_int2
    add eax, ebx
    call mostrar_valor
    jmp saida



subtrair:
    jmp saida

multiplicar:
    jmp saida

dividir:
    jmp saida


saida:
    mov ecx, nLinha
    mov edx, lLinha
    call mst_saida
    mov eax, 1
    mov ebx, 0
    int 0x80

ler: ; ler msg
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

mst_saida: ;printar msg
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

string_to_int:
    xor ebx, ebx
.prox_digito:
    movzx eax, byte[esi]
    inc esi
    sub al, '0'
    imul ebx, 10
    add ebx, eax ; ebx = ebx*10 + eax
    loop .prox_digito ;while (--ecx)
    mov eax, ebx
    ret 

string_to_int2:
    xor ebx, ebx
.prox_digito:
    movzx eax, byte[esi]
    inc esi
    sub al, '0'
    imul ebx, 10
    add ebx, eax ; ebx = ebx*10 + eax
    loop .prox_digito ;while (--ecx)
    ;mov eax, ebx
    ret 

mostrar_valor:
    lea esi, [result]
    call int_to_string
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80
    ret 


int_to_string:
    add esi, 9
    mov byte[esi], 0
    mov ebx, 10
.prox_digito:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov[esi], dl
    test eax, eax
    jnz .prox_digito ; eax == 0
    mov eax, esi
    ret