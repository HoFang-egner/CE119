# ==============================================================================
# CE119 - Thuc hanh Kien truc May tinh - LAB 03 (TN2)
# File    : CE119_Lab03_25520594_TN2.asm
# Ho ten  : Nguyen Huy Hoang - MSSV: 25520594 (d = 4)
# Mo ta   : Dao thu tu cac tu trong chuoi tai cho (in-place)
# ==============================================================================
# QUY UOC BAO TOAN THANH GHI (MIPS Calling Convention):
# - Duoc bao toan qua jal (Callee-saved): $s0-$s7, $sp, $ra
# - Khong duoc bao toan (Caller-saved)  : $t0-$t9, $a0-$a3, $v0-$v1
# - Map thanh ghi su dung trong chuong trinh:
#     + main          : $s0 (offset mang tests), $s1 (gioi han 20), $s2 (dia chi chuoi)
#     + strlen        : $a0 (str), $v0 (len), $t0 (p), $t1 (*p)          [la, 0 byte]
#     + rev_range     : $a0 (left), $a1 (right), $t0-$t2 (so sanh/swap) [la, 0 byte]
#     + reverse_words : $a0 (str), $s0 (word_start), $s1 (cur), $ra     [khung 12 byte]
#                       Bo tri stack: 0($sp)=$ra, 4($sp)=$s1, 8($sp)=$s0
# ==============================================================================
.data
    s1:     .asciiz "kien truc may tinh"
    s2:     .asciiz "mips"
    s3:     .asciiz ""
    s4:     .asciiz "a bc def"
    s5:     .asciiz "lenh jal ghi dia chi vao ra"   # S(4)
    bar:    .asciiz "|"
    bar_nl: .asciiz "|\n"
    .align 2
    tests:  .word s1, s2, s3, s4, s5

.text
.globl main
# main: chay lan luot 5 chuoi kiem thu va in ket qua dang |...|
# Tham so : khong co
# Tra ve  : khong co (thoat bang syscall 10)
# Thanh ghi: $s0, $s1, $s2, $t0, $a0, $v0
main:
    move  $s0, $zero              # offset mang tests (0, 4, 8, 12, 16)
    li    $s1, 20                 # 5 chuoi * 4 byte
main_loop:
    beq   $s0, $s1, main_done
    la    $t0, tests
    addu  $t0, $t0, $s0
    lw    $s2, 0($t0)             # $s2 = dia chi chuoi hien tai

    move  $a0, $s2
    jal   reverse_words           # dao thu tu tu tai cho

    li    $v0, 4
    la    $a0, bar                # in "|"
    syscall

    li    $v0, 4
    move  $a0, $s2                # in chuoi ket qua
    syscall

    li    $v0, 4
    la    $a0, bar_nl             # in "|\n"
    syscall

    addiu $s0, $s0, 4
    j     main_loop

main_done:
    li    $v0, 10                 # thoat chuong trinh
    syscall

# strlen: dem so ky tu cua chuoi .asciiz (khong tinh byte 0)
# Tham so : $a0 = dia chi chuoi
# Tra ve  : $v0 = do dai chuoi
# Thanh ghi: $t0, $t1 (thu tuc la, khong dung ngan xep)
strlen:
    move  $t0, $a0
str_loop:
    lbu   $t1, 0($t0)
    beq   $t1, $zero, str_done
    addiu $t0, $t0, 1
    j     str_loop
str_done:
    subu  $v0, $t0, $a0
    jr    $ra

# rev_range: dao tai cho doan [$a0, $a1] (tinh ca hai dau)
# Tham so : $a0 = dia chi ky tu dau (left), $a1 = dia chi ky tu cuoi (right)
# Tra ve  : khong co
# Thanh ghi: $t0, $t1, $t2 (thu tuc la, khong dung ngan xep)
rev_range:
rr_loop:
    sltu  $t0, $a1, $a0
    bne   $t0, $zero, rr_done
    lbu   $t1, 0($a0)
    lbu   $t2, 0($a1)
    sb    $t2, 0($a0)
    sb    $t1, 0($a1)
    addiu $a0, $a0, 1
    addiu $a1, $a1, -1
    j     rr_loop
rr_done:
    jr    $ra

# reverse_words: dao thu tu cac tu trong chuoi tai cho
# Tham so : $a0 = dia chi chuoi
# Tra ve  : khong co
# Thanh ghi: $ra, $s0 (word_start), $s1 (cur), $t0, $t1, $a0, $a1, $v0 (khung 12 byte)
reverse_words:
    addi  $sp, $sp, -12
    sw    $s0, 8($sp)
    sw    $s1, 4($sp)
    sw    $ra, 0($sp)

    move  $s0, $a0
    jal   strlen
    beq   $v0, $zero, rw_done

    move  $a0, $s0
    addu  $a1, $s0, $v0
    addiu $a1, $a1, -1
    jal   rev_range               # dao toan bo chuoi

    move  $s1, $s0
rw_loop:
    lbu   $t0, 0($s1)
    li    $t1, 32
    beq   $t0, $t1, rw_word_end
    beq   $t0, $zero, rw_word_end
    addiu $s1, $s1, 1
    j     rw_loop
rw_word_end:
    move  $a0, $s0
    addiu $a1, $s1, -1
    jal   rev_range               # dao tung tu

    lbu   $t0, 0($s1)
    beq   $t0, $zero, rw_done

    addiu $s1, $s1, 1
    move  $s0, $s1
    j     rw_loop
rw_done:
    lw    $ra, 0($sp)
    lw    $s1, 4($sp)
    lw    $s0, 8($sp)
    addi  $sp, $sp, 12
    jr    $ra
