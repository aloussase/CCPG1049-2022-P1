    .data
# STDIN
askCoinStr:     .asciiz "Ingrese moneda: "
askNumStr:      .asciiz "Ingrese el número a llamar: "
askCallInitStr: .asciiz "¿Iniciar llamada? "

logBalanceStr:      .asciiz "Saldo: $ "
logCallCostStr:     .asciiz "Costo de llamada: $ "
logOngoingCallStr:  .asciiz "Llamada en curso . . . Presiona 'C' para colgar"
logCallDurationStr: .asciiz "Duración de la llamada: "
logExchangeStr:     .asciiz "Cambio: $ "

# Costo mínimo y máximo de la llamada en enteros
CALL_MIN_COST_INT: .word 10
CALL_MAX_COST_INT: .word 40

balanceFloat:      .float 0.0 # balance inicial en 0 (sin fondos)
callCostFloat:     .float 0.0
callExchangeFloat: .float 0.0
callDurationStr: .asciiz "hh:mm:ss"

# otro
newLine:  .asciiz "\n"
dnewLine: .asciiz "\n\n"
tmp:      .word 0

    .text
main:
    # ************************************************************ LOOP-MONEDAS
    # STD{OUT/IN}: "Ingrese moneda: "
    la $a0, askCoinStr
    li $v0, 4
    syscall
    li $v0, 6
    syscall
    # ************************************************************ LOOP-MONEDAS

    # newline
    la $a0, newLine
    li $v0, 4
    syscall

    # STDOUT: "Saldo: $x.yz"
    la $a0, logBalanceStr
    li $v0, 4
    syscall
    lw $a0, balanceFloat
    li $v0, 2
    syscall

    # newline
    la $a0, newLine
    li $v0, 4
    syscall

    # TODO :: check num.lenght == 100
    # STD{OUT/IN}: "Ingrese el número a llamar: "
    la $a0, askNumStr
    li $v0, 4
    syscall
    li $v0, 5
    syscall

    # newline
    la $a0, newLine
    li $v0, 4
    syscall

    # STDOUT: "Costo de la llamada: $x.yz"
    la $a0, logCallCostStr
    li $v0, 4
    syscall
    lw $a0, callCostFloat
    li $v0, 2
    syscall

    # newline
    la $a0, dnewLine
    li $v0, 4
    syscall

    # STD{OUT/IN}: "¿Iniciar llamada? "
    la $a0, askCallInitStr
    li $v0, 4
    syscall
    li $v0, 8
    syscall

    # newline
    la $a0, newLine
    li $v0, 4
    syscall

    # ************************************************************ LOOP-LLAMADA
    # STDOUT: "Llamada en curso . . . Presiona 'C' para colgar"
    la $a0, logOngoingCallStr
    li $v0, 4
    syscall
    # ************************************************************ LOOP-LLAMADA

    # newline
    la $a0, dnewLine
    li $v0, 4
    syscall

    # STDOUT: "Duración de la llamada: hh:mm:ss"
    la $a0, logCallDurationStr
    li $v0, 4
    syscall
    la $a0, callDurationStr # REVIEW :: str? int?
    li $v0, 4
    syscall

    # newline
    la $a0, dnewLine
    li $v0, 4
    syscall

    # STDOUT: "Costo de la llamada: $x.yz"
    la $a0, logCallCostStr
    li $v0, 4
    syscall
    lw $a0, callCostFloat
    li $v0, 2
    syscall

    # newline
    la $a0, dnewLine
    li $v0, 4
    syscall

    # STDOUT: "Cambio: $ x.yz"
    la $a0, logExchangeStr
    li $v0, 4
    syscall
    lw $a0, callExchangeFloat
    li $v0, 2
    syscall

    # return
    li $v0, 10
    syscall

die:
    # return
    li $v0, 10
    syscall
