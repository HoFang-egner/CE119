.data
prompt:      .asciiz "Nhap so kWh (0..9999): "
err_msg:     .asciiz "Gia tri khong hop le, nhap lai.\n"
res_prefix:  .asciiz "Tien dien: "
res_suffix:  .asciiz " dong\n"

upto:   .word 50, 100, 200, 300, 400, 9999
price:  .word 1680, 1740, 2030, 2580, 2930, 3080

.text
main:
input_loop:
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0

    sltiu $t0, $s0, 10000
    bne  $t0, $zero, valid
    li   $v0, 4
    la   $a0, err_msg
    syscall
    j    input_loop

valid:
    li   $s1, 0
    move $s2, $s0
    li   $s3, 0
    la   $t0, upto          
    la   $t2, price         

loop:
    blez $s2, done
    lw   $t1, 0($t0)
    lw   $t3, 0($t2)
    sub  $t4, $t1, $s3
    slt  $t6, $s2, $t4
    beq  $t6, $zero, use_full
    move $t7, $s2
    j    add_amount
use_full:
    move $t7, $t4
add_amount:
    mul  $t8, $t7, $t3
    add  $s1, $s1, $t8
    sub  $s2, $s2, $t7
    move $s3, $t1
    addi $t0, $t0, 4
    addi $t2, $t2, 4
    j    loop

done:
    li   $v0, 4
    la   $a0, res_prefix
    syscall
    move $a0, $s1
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, res_suffix
    syscall
    li   $v0, 10
    syscall
