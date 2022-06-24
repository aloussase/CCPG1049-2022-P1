# IS_VALID_COIN
#
# Input:
#   $f0: A floating point number to test for coinness
# Output:
#   $v0: 1 if $a0 is a valid coin, 0 otherwise
is_valid_coin:
        li.s $f1, 0.05
        li.s $f2, 0.1
        li.s $f3, 0.25
        li.s $f4, 0.5

        li.s $f9, 0.000001              # accepted error margin

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
