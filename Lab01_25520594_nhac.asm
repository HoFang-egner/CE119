.data
pitch:      .word 64,64,65,67,67,65,64,62,60,60,62,64,64,62,62
length:     .word 2,2,2,2,2,2,2,2,2,2,2,2,3,1,4
nNotes:     .word 15
semitone:   .word 4          # a
msUnit:     .word 240       # 150+10*b
instrument: .word 24        #b mod 4 = 1 -> 24

sep:        .asciiz " "
nl:         .asciiz "\n"
total_msg:  .asciiz "Tong du kien (ms): "
meas_msg:   .asciiz "Thoi gian do duoc (ms): "

.text
main:
    la  $s0, pitch
    la  $s1, length
    lw  $s2, nNotes
    li  $s3, 0
    lw  $s4, instrument
    lw  $s5, msUnit

    li  $v0, 30
    syscall
    move $s6, $a0            # thoi diem bat dau

loop:
    blez $s2, finish

    lw   $t0, 0($s0)         # cao do trong mang
    lw   $t1, 0($s1)          # do dai (don vi nhip)
    addi $t3, $t0, 4       # cao do thuc phat = cao do + a (a=4)
    mul  $t2, $t1, $s5        # thoi luong (ms) = do dai * msUnit

    # In ra "<cao do> <ms>"
    move $a0, $t3
    li   $v0, 1
    syscall
    la   $a0, sep
    li   $v0, 4
    syscall
    move $a0, $t2
    li   $v0, 1
    syscall
    la   $a0, nl
    li   $v0, 4
    syscall

    # Phat not MIDI, cho den khi not ket thuc (syscall 33)
    move $a0, $t3
    move $a1, $t2
    move $a2, $s4
    li   $a3, 100
    li   $v0, 31
    syscall

    add  $s3, $s3, $t2     # cong don tong thoi luong du kien
    addi $s0, $s0, 4
    addi $s1, $s1, 4
    addi $s2, $s2, -1
    j    loop

finish:
    li   $v0, 32
    syscall
    sub  $t9, $a0, $s6        # thoi gian do duoc = ket thuc - bat dau

    la   $a0, total_msg
    li   $v0, 4
    syscall
    move $a0, $s3
    li   $v0, 1
    syscall
    la   $a0, nl
    li   $v0, 4
    syscall

    la   $a0, meas_msg
    li   $v0, 4
    syscall
    move $a0, $t9
    li   $v0, 1
    syscall
    la   $a0, nl
    li   $v0, 4
    syscall

    li   $v0, 10
    syscall
