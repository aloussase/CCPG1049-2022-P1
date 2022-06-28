        .data

cost_per_minute_prefix:         .asciiz "El valor por minuto de llamada es de: "
cost_per_minute_suffix:         .asciiz " ctvs\n"

ask_for_phone_number_prompt:    .asciiz "Ingrese el numero a llamar: "
ask_for_phone_number_errmsg:    .asciiz "\033[31mERROR:\033[m Numero invalido\n"

simulate_call_prompt:           .asciiz "Iniciar la llamada? [S/n] "
simulate_call_message:          .asciiz ". Llamada en curso ... Presiona C para colgar\n"

ask_for_balance_prompt:         .asciiz "Ingrese monedas (-1 para terminar): "
ask_for_balance_errmsg:         .asciiz "Moneda incorrecta\n"

balance_report_message:         .asciiz "Su saldo es: "
call_duration_message:          .asciiz "Duracion de la llamada (minutos): "

total_call_cost_message:        .asciiz "Costo total de la llamada: "

change_message:                 .asciiz "Cambio: "

nickel:                         .float  0.05
dime:                           .float  0.10
quarter:                        .float  0.25
half:                           .float  0.50
tolerance:                      .float  0.000001

minus_one:                      .float  -1.0

ask_for_phone_number_buffer:    .byte 12
simulate_call_buffer:           .byte 3

        .text
        .globl main

        # STRLEN
        #
        # Input:
        #   $a0: The string for which to calculate the length.
        # Output:
        #   $v0: The length of the given string.
strlen:
        li   $v0, 0

strlen_loop:
        lb          $t0, 0($a0)
        beqz        $t0, strlen_exit

        addi        $v0, $v0, 1
        addi        $a0, $a0, 1
        j           strlen_loop

strlen_exit:
        jr          $ra
        # READLINE
        #
        # Input:
        #  $a0: A null terminated string to use as prompt
        #  $a1: The address of a buffer to store the line
        #  $a2: The max. number of characters to read
readline:
        li    $v0, 4
        syscall

        # syscall 8 will read max $a1 chars into $a0
        move $a0, $a1
        move $a1, $a2
        li   $v0, 8
        syscall

        jr   $ra
# IS_VALID_COIN
#
# Input:
#   $f0: A floating point number to test for coinness
# Output:
#   $v0: 1 if $a0 is a valid coin, 0 otherwise
is_valid_coin:
        # NOTE: These need to be defined in the including file.
        l.s $f1, nickel
        l.s $f2, dime
        l.s $f3, quarter
        l.s $f4, half

        l.s $f9, tolerance              # accepted error margin

        # Here I am using a different register for each branch to
        # avoid having to reset the same register over and over
        # again.

        sub.s  $f5, $f1, $f0            # if ((0.05 - arg) < 0.000001)
        abs.s  $f5, $f5
        c.lt.s $f5, $f9                 #
        bc1t   is_valid_coin_success    #   return true;

        sub.s  $f6, $f2, $f0            # if ((0.1 - arg) < 0.000001)
        abs.s  $f6, $f6
        c.lt.s $f6, $f9                 #
        bc1t   is_valid_coin_success    #   return true;

        sub.s  $f7, $f3, $f0            # if ((0.25 - arg) < 0.000001)
        abs.s  $f7, $f7
        c.lt.s $f7, $f9                 #
        bc1t   is_valid_coin_success    #   return true;

        sub.s  $f8, $f4, $f0            # if ((0.5 - arg) < 0.000001)
        abs.s  $f8, $f8
        c.lt.s $f8, $f9                 #
        bc1t   is_valid_coin_success    #   return true;

        li $v0, 0                       # return false
        jr $ra

is_valid_coin_success:
        li $v0, 1
        jr $ra
        # IS_VALID_PHONE_NUMBER: checks whether the provided number (as a string)
        #                        is a valid phone number
        # Input:
        #   $a0: The string to validate.
        # Output:
        #   $v0: 1 if the string is a valid phone number, 0 otherwise.
is_valid_phone_number:
        addi $sp, $sp, -8
        sw   $ra, 0($sp)                             # Save return address in stack
        sw   $s0, 4($sp)

        move $s0, $a0                                # Save $a0
        jal  strlen                                  # Calculate the length of the input string.
        move $t1, $v0                                # Save return value of strlen
        move $a0, $s0                                # Restore $a0

        li   $v0, 0
        li   $t0, 11
        bne  $t0, $t1, is_valid_phone_number_exit   # Return 0 if len($a0) != 11

is_valid_phone_number_loop:
        lb   $t0, 0($a0)                            # $t0 = *$a0;

        li   $v0, 1
        beqz $t0, is_valid_phone_number_exit        # Return true if we reach the end of the string
        beq  $t0, 10, is_valid_phone_number_exit    # Or is it's a newline

        li   $v0, 0                                 # Prepare false return value in case any of the following are true

        li   $t1, 48                                # 48 is ascii code for 0
        blt  $t0, $t1, is_valid_phone_number_exit   # *$a0 < '0'

        li   $t1, 57                                # 57 is 9
        bgt  $t0, $t1, is_valid_phone_number_exit   # *$a0 > '9'

        addi $a0, $a0, 1                            # Increment the string pointer
        j    is_valid_phone_number_loop

is_valid_phone_number_exit:
        lw   $ra, 0($sp)
        lw   $s0, 4($sp)
        addi $sp, $sp, 8

        jr   $ra
# POW: raise a number to the nth power
#
# input:
#   $a0: the base
#   $a1: the exponent
# output:
#  $v0: $a0 raised to the $a1
pow:
    li   $t0, 1           # number of iterations
    move $v0, $a0         # start with the initial value of base

pow_loop:
    beq $t0, $a1, pow_exit

    mult $v0, $a0
    mflo $v0

    addi $t0, $t0, 1

    j pow_loop

pow_exit:
    jr $ra
# RAND: get a random number
#
# input:
#   - $a0: previous pseudorandom number returned by this routine or a seed value
# output:
#   - $v0: a 31 bit random number
# requires:
#   - pow
rand:
    addi $sp, $sp, -8
    sw   $ra, 0($sp)
    sw   $a0, 4($sp)

    li  $a0, 2                      # m = 2^31
    li  $a1, 31
    jal pow

    lw  $a0, 4($sp)                 # restore $a0

    li $t0, 1103515245              # a
    li $t1, 12345                   # c

    # Xn = (aX + c) mod m

    mult $t0, $a0                   # aX
    mflo $t0

    add  $t0, $t0, $t1              # aX + c

    div  $t0, $v0                   # (aX + c) mod m
    mfhi $t0

    lw   $ra, 0($sp)
    addi $sp, $sp, 8

    move $v0, $t0
    jr   $ra


ask_for_balance:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)

        l.s  $f15, minus_one                # load -1.0 into $f15 to check exit condition
        li.s $f16, 0.0                      # initialize return value to zero
        li.s $f0,  0.0                      # reset $f0

ask_for_balance_loop:
        add.s $f16, $f16, $f0               # add to the balance

        la   $a0, ask_for_balance_prompt    # print prompt
        li   $v0, 4
        syscall

        li   $v0, 6                         # read a float, result in $f0
        syscall

        c.eq.s $f0, $f15                    # exit if user entered -1
        bc1t   ask_for_balance_exit

        jal  is_valid_coin                  # check if input is a valid coin denomination
                                            # (argument is already in $f0)
        bnez $v0, ask_for_balance_loop      # loop back if it is

        la  $a0, ask_for_balance_errmsg     # else print error message
        li  $v0, 4
        syscall

        sub.s $f16, $f16, $f0               # subtract invalid coin because it will be added at the top of the loop
        j     ask_for_balance_loop          # and loop

ask_for_balance_exit:
        mov.s $f0, $f16                     # move return value to $f0
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4
        jr    $ra

ask_for_phone_number:
        add $sp, $sp, -12
        sw  $ra, 0($sp)
        sw  $s0, 4($sp)
        sw  $s1, 8($sp)

        la  $s0, ask_for_phone_number_prompt
        la  $s1, ask_for_phone_number_buffer

        move  $a0, $s0
        move  $a1, $s1
        li    $a2, 12
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
        li    $a2, 12
        jal readline

        j    ask_for_phone_number_loop                  # Loop.

ask_for_phone_number_exit:
        lw  $ra, 0($sp)
        lw  $s0, 4($sp)
        lw  $s1, 8($sp)
        add $sp, $sp, 12
        jr  $ra

simulate_call:
        addi $sp, $sp, -16
        sw   $ra, 0($sp)
        sw   $s0, 4($sp)
        sw   $s1, 8($sp)
        sw   $s2, 12($sp)

        li $s0, 0                                       # duration of the call in minutes.
        la $s1, simulate_call_buffer                    # store user answer.
        la $s2, simulate_call_message

        la   $a0, simulate_call_prompt                  # ask the user if they want to start the call.
        move $a1, $s1
        li   $a2, 3
        jal  readline

        lb  $t0, 0($s1)                                 # exit is user entered 'S'.
        bne $t0, 83, simulate_call_exit                 # 83 is ascii code for 'S'.

simulate_call_loop:
        addi $s0, $s0, 1                                # increase the number of minutes.

        li   $v0, 1                                     # print call in progress message
        move $a0, $s0
        syscall

        li   $v0, 4
        move $a0, $s2
        syscall

        li $v0, 12                                      # read a character
        syscall

        li  $t0, 67
        li  $t1, 99
        beq $v0, $t0, simulate_call_exit                # exit if the user enters either 'c' or 'C'
        beq $v0, $t1, simulate_call_exit
        j simulate_call_loop

simulate_call_exit:
        move $v0, $s0                                   # return call duration in minutes.
        lw   $ra, 0($sp)
        lw   $s0, 4($sp)
        lw   $s1, 8($sp)
        lw   $s2, 12($sp)
        addi $sp, $sp, 16
        jr   $ra

main:
        add $sp, $sp, -4
        sw  $ra, 0($sp)

        #
        # Ask the user for balance and print it.
        #

        jal     ask_for_balance
        la      $a0, balance_report_message

        mov.s   $f20, $f0                   # Save the balance in $f20.

        li      $v0, 4
        syscall

        mov.s   $f12, $f0
        li      $v0,  2
        syscall

        li      $a0,  10                    # Print a newline.
        li      $v0,  11
        syscall

        #
        # Get a random number to be the per minute cost of the phone call.
        #
        # The seed is fixed so we always get the same random value on
        # every execution of the program. We need a source of entropy.
        #

        li  $a0, 1
        jal rand

        li   $t0, 40                        # Normalize the result to be 0 <= x <= 40.
        div  $v0, $t0
        mfhi $s0

        la   $a0, cost_per_minute_prefix
        li   $v0, 4
        syscall

        move $a0, $s0                       # Print the random number.
        li   $v0, 1
        syscall

        la   $a0, cost_per_minute_suffix
        li   $v0, 4
        syscall

        #
        # Ask for phone number and simulate call.
        #

        jal   ask_for_phone_number      # Ask for a phone number.
        jal   simulate_call             # Simulate call, number of minutes is in $v0.
        move $t0, $v0                   # Save return value in $t0.

        la   $a0, call_duration_message
        li   $v0, 4
        syscall

        move $a0, $t0                   # Print number of minutes.
        li   $v0, 1
        syscall

        li   $a0, 10                    # Print a newline.
        li   $v0, 11
        syscall

        #
        # Calculate and print the final cost of the phone call.
        #

        li.s     $f1, 100.0

        addi     $sp, $sp, -8          # Needed for converting ints to floats.
        sw       $s0, 0($sp)
        sw       $t0, 4($sp)

        lwc1     $f0, 0($sp)           # Price per minute.
        cvt.s.w  $f2, $f0

        lwc1     $f0, 4($sp)           # Call duration.
        cvt.s.w  $f3, $f0

        addi     $sp, $sp, 8           # Pop 2 items off the stack.

        div.s    $f12, $f2,  $f1       # f12 = price_per_minute / 100
        mul.s    $f12, $f12, $f3       # f12 = f12 * call_duration

        la       $a0, total_call_cost_message
        li       $v0, 4
        syscall

        li       $v0, 2                # Print the total cost of the call.
        syscall

        li       $a0, 10               # Print a newline.
        li       $v0, 11
        syscall

        #
        # Calculate and print the change.
        #

        la    $a0, change_message
        li    $v0, 4
        syscall

        sub.s $f12, $f20, $f12
        li    $v0,  2
        syscall

        li    $a0, 10
        li    $v0, 11
        syscall

        #
        # End
        #

        lw  $ra, 0($sp)
        add $sp, $sp, 4

        jr $ra
