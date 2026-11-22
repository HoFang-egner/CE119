.data
msg:    .asciiz "Ket qua: "

.text
.globl main
# main: goi outer(5) va in ket qua
# Tham so : khong co
# Tra ve  : khong co (thoat bang syscall 10)
# Thanh ghi: $a0, $v0, $s0
main:
        li    $a0, 5            # x = 5
        jal   outer             # v0 = outer(5)
        move  $s0, $v0
        li    $v0, 4
        la    $a0, msg
        syscall
        move  $a0, $s0
        li    $v0, 1
        syscall
        li    $v0, 10
        syscall

# outer: tinh inner(x) + 1 (thu tuc khong la)
# Tham so : $a0 = x
# Tra ve  : $v0 = 2 * x + 1
# Thanh ghi: $ra (cat tren ngan xep), $a0, $v0
outer:
        addi  $sp, $sp, -4      # mo dau: cap khung 1 word
        sw    $ra, 0($sp)       # cat dia chi tro ve main
        jal   inner             # $v0 = inner(x)
        addi  $v0, $v0, 1       # $v0 = inner(x) + 1
        lw    $ra, 0($sp)       # ket thuc: nap lai $ra
        addi  $sp, $sp, 4       # thu hoi khung
        jr    $ra

# inner: tinh 2 * x (thu tuc la)
# Tham so : $a0 = x
# Tra ve  : $v0 = 2 * x
# Thanh ghi: $a0, $v0
inner:
        add   $v0, $a0, $a0
        jr    $ra