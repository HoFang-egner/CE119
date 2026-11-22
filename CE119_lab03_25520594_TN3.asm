.data
    n_val: .word 20
    prompt_1: .asciiz "F("
    prompt_2: .asciiz ") = "
.text
.globl main
main:
        lw $s0, n_val
        move $a0, $s0
        jal fib_rec
        
        move $s1, $v0
        
        la $a0, prompt_1
        li $v0, 4
        syscall
        
        li $v0, 1
        move $a0, $s0
        syscall
        
        la $a0, prompt_2
        li $v0, 4
        syscall
        
        li $v0, 1
        move $a0, $s1
        syscall
        
        li $v0, 10
        syscall
fib_rec:
        addi $sp, $sp, -12
        sw $s1, 8($sp)
        sw $s0, 4($sp)
        sw $ra, 0($sp)
        
        move $s0, $a0
        
        beq $a0, 0, fib_zero
        beq $a0, 1, fib_one       
        
        addi $a0, $s0, -1
        jal fib_rec
        move $s1, $v0   # $s1 luu gia tri cua f(n-1) 
        
        addi $a0, $s0, -2
        jal fib_rec
        addu $v0, $s1, $v0
        
        j fib_done
fib_zero:
        li $v0, 0
        j fib_done
fib_one:
        li $v0, 1
        j fib_done
fib_done:
        lw $s1, 8($sp)
        lw $s0, 4($sp)
        lw $ra, 0($sp)
        addi $sp, $sp ,12
        
        jr $ra
