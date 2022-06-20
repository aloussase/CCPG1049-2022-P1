        # IS_VALID_PHONE_NUMBER: checks whether the provided number (as a string)
        #                        is a valid phone number
        # Input:
        #   $a0: The string to validate.
        # Output:
        #   $v0: 1 if the string is a valid phone number, 0 otherwise.
is_valid_phone_number:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)                             # Save return address in stack

        jal  strlen                                  # Calculate the length of the input string.
        move $t1, $v0                                # Save return value of strlen

        li   $v0, 0
        li   $t0, 10
        bne  $t0, $t1, is_valid_phone_number_exit   # Return 0 if len($a0) != 10

is_valid_phone_number_loop:
        lb   $t0, 0($a0)                            # $t0 = *$a0;

        li   $v0, 1
        beqz $t0, is_valid_phone_number_exit        # Return true if we reach the end of the string

        li   $v0, 0                                 # Prepare false return value in case any of the following are true

        li   $t1, 48                                # 48 is ascii code for 0
        blt  $t0, $t1, is_valid_phone_number_exit   # *$a0 < 0

        li   $t1, 57                                # 57 is 9
        bgt  $t0, $t1, is_valid_phone_number_exit   # *$a0 > 9

        addi $a0, $a0, 1                            # Increment the string pointer
        j    is_valid_phone_number_loop

is_valid_phone_number_exit:
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra
