        .data
small_string:   .asciiz "Hello, World!"
long_string:    .asciiz "Everything, everywhere, all at once"

small_string_test_failed:  .asciiz "\033[31mERROR:\033[m small_string test failed\n"
long_string_test_failed:        .asciiz "\033[31mERROR:\033[m long_string test failed\n"

        .text
        .globl main

@include src/strlen.asm

main:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)

        # Test 1

        la $a0, small_string
        jal strlen

        li $t0, 13 # Expected length

        la $a0, small_string_test_failed
        bne $v0, $t0, EXIT_ERROR

        # Test 2

        la $a0, long_string
        jal strlen

        li $t0, 35 # Expected length

        la $a0, long_string_test_failed
        bne $v0, $t0, EXIT_ERROR

        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

EXIT_ERROR:
        li $v0, 4 # Print the error message
        syscall

        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
