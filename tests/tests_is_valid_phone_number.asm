        .data
valid_phone_number:   .asciiz "0995764993\n"
invalid_phone_number: .asciiz "12345678910\n"
string_not_a_number:  .asciiz "Hello, World!\n"

valid_phone_number_error:   .asciiz "\033[31mERROR:\033[m valid_phone_number returned false"
invalid_phone_number_error: .asciiz "\033[31mERROR:\033[m invalid_phone_number returned true"
string_not_a_number_error:  .asciiz "\033[31mERROR:\033[m string_not_a_number returned true"

        .text
        .globl main

        @include src/strlen.asm
        @include src/is_valid_phone_number.asm

main:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)

        # Test 1 ("0995764993")
        la   $a0, valid_phone_number
        jal  is_valid_phone_number
        la   $a0, valid_phone_number_error
        beqz $v0, EXIT_ERROR

        # Test 2 ("12345678910")
        la  $a0, invalid_phone_number
        jal is_valid_phone_number
        la  $a0, invalid_phone_number_error
        bne $v0, $zero, EXIT_ERROR

        # Test 3 ("Hello, World!")
        la  $a0, string_not_a_number
        jal is_valid_phone_number
        la  $a0, string_not_a_number_error
        bne $v0, $zero, EXIT_ERROR

        lw   $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra

        # TODO :: end main

EXIT_ERROR:
        li $v0, 4
        syscall

        lw   $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra
