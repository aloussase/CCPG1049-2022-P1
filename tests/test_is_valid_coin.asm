    .data

quarter_is_not_valid:   .asciiz "0.25 is not a valid coin"

    .text
    .globl main

@include src/is_valid_coin.asm

main:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    li.s $f0, 0.25
    jal  is_valid_coin

    la   $a0, quarter_is_not_valid
    beqz $v0, EXIT_ERROR

    jr $ra

EXIT_ERROR:
    li $v0, 4
    syscall

    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra
