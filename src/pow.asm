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
