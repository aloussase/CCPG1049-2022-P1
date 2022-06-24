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
