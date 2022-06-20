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
