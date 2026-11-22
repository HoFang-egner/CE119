# ==============================================================================
# CE119 - Thuc hanh Kien truc May tinh - LAB 03 (Mo rong)
# File    : CE119_Lab03_25520594_MR.asm
# Ho ten  : Nguyen Huy Hoang - MSSV: 25520594 (d = 4)
# Mo ta   : Toi uu truong hop co so cua fib_rec (kiem tra n < 2 truoc khi cap khung)
# ==============================================================================
.data
    n_val: .word 20
    prompt_1: .asciiz "F("
    prompt_2: .asciiz ") = "

.text
.globl main
main:
        lw    $s0, n_val
        move  $a0, $s0
        jal   fib_opt

        move  $s1, $v0

        la    $a0, prompt_1
        li    $v0, 4
        syscall

        li    $v0, 1
        move  $a0, $s0
        syscall

        la    $a0, prompt_2
        li    $v0, 4
        syscall

        li    $v0, 1
        move  $a0, $s1
        syscall

        li    $v0, 10
        syscall

# fib_opt: tinh F(n) bang de quy, kiem tra truong hop co so truoc khi cap khung
# Tham so : $a0 = n (n >= 0)
# Tra ve  : $v0 = F(n)
# Thanh ghi: $ra, $s0 (n), $s1 (F(n-1)), $a0, $v0 (khung 12 byte chi cap khi n >= 2)
fib_opt:
        beq   $a0, 0, fib_zero
        beq   $a0, 1, fib_one

        addi  $sp, $sp, -12
        sw    $s1, 8($sp)
        sw    $s0, 4($sp)
        sw    $ra, 0($sp)

        move  $s0, $a0

        addi  $a0, $s0, -1
        jal   fib_opt
        move  $s1, $v0          # $s1 luu gia tri cua F(n-1)

        addi  $a0, $s0, -2
        jal   fib_opt
        addu  $v0, $s1, $v0

        j     fib_return_stack
fib_zero:
        li    $v0, 0
        jr    $ra
fib_one:
        li    $v0, 1
        jr    $ra
fib_return_stack:
        lw    $s1, 8($sp)
        lw    $s0, 4($sp)
        lw    $ra, 0($sp)
        addi  $sp, $sp, 12
        jr    $ra
