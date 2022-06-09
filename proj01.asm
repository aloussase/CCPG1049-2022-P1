    .data
newLine: .asciiz "\n"
testStr: .asciiz "Esto es un test"

    .text
main:

    # echo test
    la $a0, testStr
    li $v0, 4
    syscall

    # newline
    la $a0, newLine
    li $v0, 4
    syscall

    # return
    li $v0, 10
    syscall
