# ==============================================================================
# CE119 - Thuc hanh Kien truc May tinh - LAB 03 (TN2)
# File    : CE119_Lab03_25520594_TN2.asm
# Ho ten  : Nguyen Huy Hoang - MSSV: 25520594 (d = 4)
# Mo ta   : Dao thu tu cac tu trong chuoi tai cho (in-place)
# ==============================================================================
# QUY UOC BAO TOAN THANH GHI (MIPS Calling Convention):
# - Duoc bao toan qua jal (Callee-saved): $s0-$s7, $sp, $ra
#     -> Thu tuc nao lam thay doi phai cat vao stack va tra lai truoc jr $ra
# - Khong duoc bao toan (Caller-saved)  : $t0-$t9, $a0-$a3, $v0-$v1
#     -> Thu tuc la chi dung nhom nay nen khong can cap khung ngan xep
# - Map thanh ghi su dung trong chuong trinh:
#     + main          : $s0 (offset mang tests), $s1 (gioi han 20), $s2 (dia chi chuoi)
#     + strlen        : $a0 (str), $v0 (len), $t0 (p), $t1 (*p)          [la, 0 byte]
#     + rev_range     : $a0 (left), $a1 (right), $t0-$t2 (so sanh/swap) [la, 0 byte]
#     + reverse_words : $a0 (str), $s0 (word_start), $s1 (cur), $ra     [khung 12 byte]
#                       Bo tri stack: 0($sp)=$ra, 4($sp)=$s1, 8($sp)=$s0
# ==============================================================================
.data
    s5:     .asciiz "lenh jal ghi dia chi vao ra"   # S(4)
    bar:    .asciiz "|"
    bar_nl: .asciiz "|\n"
    .align 2

.text
.globl main
main:
    la   $a0, s5
    jal  reverse_word
    li   $v0, 10
    syscall
   
   
# strlen: dem so ky tu cua chuoi .asciiz (khong tinh byte 0)
# Tham so : $a0 = dia chi chuoi
# Tra ve  : $v0 = do dai chuoi
# Thanh ghi: $t0, $t1 (thu tuc la, khong dung ngan xep)
strlen: 
    move $t0, $a0
str_loop:
    lbu $t1, 0($t0)
    beq $t1, $zero, str_done
    addi $t0, $t0, 1
    j str_loop
str_done:
    subu $v0, $t0, $a0
    jr $ra
    
# rev_range: dao tai cho doan [$a0, $a1] (tinh ca hai dau)
# Tham so : $a0 = dia chi ky tu dau (left), $a1 = dia chi ky tu cuoi (right)
# Tra ve  : khong co
# Thanh ghi: $t0, $t1, $t2 (thu tuc la, khong dung ngan xep)

rev_range:
rr_loop:
    sltu $t0, $a1, $a0
    bne $t0, $zero, rr_done
    lbu $t1, 0($a0)
    lbu $t2, 0($a1)
    sb $t2, 0($a0)
    sb $t1, 0($a1)
    addi $a0, $a0, 1
    addi $a1, $a1, -1
    j rr_loop
rr_done:
    jr $ra
    
# reverse_words: dao thu tu cac tu trong chuoi tai cho
# Tham so : $a0 = dia chi chuoi
# Tra ve  : khong co
# Thanh ghi: $ra, $s0 (word_start), $s1 (cur), $t0, $t1 (khung 12 byte)

reverse_word:
    addi $sp, $sp, -12
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $ra, 0($sp)
    
    move $s0, $a0
    jal strlen
    beq $v0, $zero, rw_done
    
    move $a0, $s0
    add $a1, $s0, $v0
    addi $a1, $a1, -1
    jal rev_range     # chuan bi cac tham so de goi ham
    
    move $s1, $s0
rw_loop:
    lbu $t0, 0($s1)
    li $t1, 32
    beq $t0, $t1, rw_word_end
    beq $t0, $zero, rw_word_end
    addi $s1, $s1, 1
    j rw_loop
rw_word_end:
    move $a0, $s0
    move $a1, $s1
    addi $a1, $a1, -1
    jal rev_range
    
    lbu $t0, 0($s1)
    beq $t0, $zero, rw_done
    
    addi $s1, $s1, 1
    move $s0, $s1
    j rw_loop
rw_done:
    lw $ra, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
    
    
