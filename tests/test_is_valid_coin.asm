    .data

five_cents_is_valid:        .asciiz "\033[31mERROR:\033[m test 0.05 is a valid coin failed"
quarter_is_valid:           .asciiz "\033[31mERROR:\033[m test 0.25 is a valid coin failed"
twelve_cents_is_not_valid:  .asciiz "\033[31mERROR:\033[m test 0.12 is not a valid coin failed"

nickel:                     .float  0.05
dime:                       .float  0.10
quarter:                    .float  0.25
half:                       .float  0.50
tolerance:                  .float  0.000001

    .text
    .globl main

@include src/is_valid_coin.asm

main:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)

        li.s $f0, 0.05
        jal  is_valid_coin

        la   $a0, five_cents_is_valid
        beqz $v0, EXIT_ERROR

        li.s $f0, 0.25
        jal  is_valid_coin

        la   $a0, quarter_is_valid
        beqz $v0, EXIT_ERROR

        li.s $f0, 0.12
        jal  is_valid_coin

        la   $a0, twelve_cents_is_not_valid
        bnez $v0, EXIT_ERROR

        lw   $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra

EXIT_ERROR:
        li $v0, 4
        syscall

        lw   $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra
