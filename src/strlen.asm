        # STRLEN
        #
        # Input:
        #   $a0: The string for which to calculate the length.
        # Output:
        #   $v0: The length of the given string.
strlen:
        li          $v0, 0
strlen1:
        lb          $t0, 0($a0)
        beqz        $t0, strlen2
        addi        $v0, $v0, 1
        addi        $a0, $a0, 1
        j           strlen1
strlen2:
        jr          $ra
