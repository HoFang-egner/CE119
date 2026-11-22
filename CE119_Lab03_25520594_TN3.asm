# ==============================================================================
# CE119 - Thuc hanh Kien truc May tinh - LAB 03 (TN3)
# File    : CE119_Lab03_25520594_TN3.asm
# Ho ten  : Nguyen Huy Hoang - MSSV: 25520594 (d = 4)
# Mo ta   : Tinh so Fibonacci bang de quy (fib_rec) va vong lap (fib_iter)
# ==============================================================================
.data
    n_val:    .word 20
    prompt_1: .asciiz "F("
    prompt_2: .asciiz ") = "

.text
.globl main
# main: doc n tu .data, goi fib_rec (hoac doi sang fib_iter de do), in F(n) = kq
# Tham so : khong co
# Tra ve  : khong co (thoat bang syscall 10)
# Thanh ghi: $s0 (n), $s1 (F(n)), $a0, $v0
main:
        lw    $s0, n_val
        move  $a0, $s0
        jal   fib_rec

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

# fib_rec: tinh F(n) bang de quy (goi 2 lan voi moi n >= 2)
# Tham so : $a0 = n (n >= 0)
# Tra ve  : $v0 = F(n)
# Thanh ghi: $ra, $s0 (n), $s1 (F(n-1)), $a0, $v0 (khung 12 byte)
fib_rec:
        addi  $sp, $sp, -12
        sw    $s1, 8($sp)
        sw    $s0, 4($sp)
        sw    $ra, 0($sp)

        move  $s0, $a0

        beq   $a0, 0, fib_zero
        beq   $a0, 1, fib_one

        addi  $a0, $s0, -1
        jal   fib_rec
        move  $s1, $v0          # $s1 luu gia tri cua F(n-1)

        addi  $a0, $s0, -2
        jal   fib_rec
        addu  $v0, $s1, $v0

        j     fib_done
fib_zero:
        li    $v0, 0
        j     fib_done
fib_one:
        li    $v0, 1
        j     fib_done
fib_done:
        lw    $s1, 8($sp)
        lw    $s0, 4($sp)
        lw    $ra, 0($sp)
        addi  $sp, $sp, 12

        jr    $ra

# fib_iter: tinh F(n) bang vong lap
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move  $v0, $zero        # a = F(0)
        li    $t0, 1            # b = F(1)
        move  $t1, $zero        # i = 0
fi_loop:
        slt   $t2, $t1, $a0
        beq   $t2, $zero, fi_done
        addu  $t3, $v0, $t0     # a + b
        move  $v0, $t0
        move  $t0, $t3
        addiu $t1, $t1, 1
        j     fi_loop
fi_done:
        jr    $ra
