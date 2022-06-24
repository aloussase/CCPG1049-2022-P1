        .data

four_is_square_of_two: .asciiz "\033[31mERROR:\033[m 2**2 = 4  failed"
three_to_the_cube_27:  .asciiz "\033[31mERROR:\033[m 3**3 = 27 failed"

        .text
        .globl main

@include src/pow.asm

main:
    addi $sp, $sp -4
    sw   $ra, 0($sp)

    li   $a0, 2
    li   $a1, 2
    jal  pow

    la   $a0, four_is_square_of_two
    li   $t0, 4
    bne  $v0, $t0, EXIT_ERROR

    li   $a0, 3
    li   $a1, 3
    jal  pow

    la   $a0, three_to_the_cube_27
    li   $t0, 27
    bne  $v0, $t0, EXIT_ERROR

    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

EXIT_ERROR:
    li $v0, 4
    syscall

    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra
