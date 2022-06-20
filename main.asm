        .data

ask_for_phone_number_prompt:    .asciiz "Ingrese el numero a llamar: "
ask_for_phone_number_errmsg:    .asciiz "\033[31mERROR:\033[m Numero invalido\n"
ask_for_phone_number_buffer:    .byte 11

        .text
        .globl main

@include src/strlen.asm
@include src/readline.asm
@include src/is_valid_phone_number.asm

ask_for_phone_number:
        add $sp, $sp, -12
        sw  $ra, 0($sp)
        sw  $s0, 4($sp)
        sw  $s1, 8($sp)

        la  $s0, ask_for_phone_number_prompt
        la  $s1, ask_for_phone_number_buffer

        move  $a0, $s0
        move  $a1, $s1
        li    $a2, 11
        jal readline

ask_for_phone_number_loop:
        move $a0, $s1
        jal  is_valid_phone_number                      # Check whether the input is a valid phone number.

        bne  $v0, $zero, ask_for_phone_number_exit      # Exit if the number is valid.

        la $a0, ask_for_phone_number_errmsg             # Print an error message.
        li $v0, 4
        syscall

        move  $a0, $s0                                  # Ask for input again.
        move  $a1, $s1
        li    $a2, 11
        jal readline

        j    ask_for_phone_number_loop                  # Loop.

ask_for_phone_number_exit:
        lw  $ra, 0($sp)
        lw  $s0, 4($sp)
        lw  $s1, 8($sp)
        add $sp, $sp, 12

        jr $ra

main:
        add $sp, $sp, -4
        sw  $ra, 0($sp)

        jal ask_for_phone_number

        lw  $ra, 0($sp)
        add $sp, $sp, 4

        jr $ra
