# ============================================================================
# File: CE119_Lab02_25520594.asm
# Sinh vien: Nguyen Huy Hoang - 25520594
# Lop: VMTN2025
# Muc dich: Tong hop Lab 02 - Mang, Chuoi, Thu tuc va Ngan xep
# ============================================================================

.data
    scores:      .word 10, 7, 1, 2, 6, 9, 0, 4, 10, 2, 8, 7
    length:      .word 12
    hist:        .word 0, 0, 0, 0
    grade_tab:   .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3

    .align 2
    str_min:     .asciiz "\nmin="
    str_max:     .asciiz " max="
    
    str_g0:      .asciiz "\ng0="
    str_g1:      .asciiz " g1="
    str_g2:      .asciiz " g2="
    str_g3:      .asciiz " g3=\n"
    
    strP:        .asciiz "([{([{()}])}])"
    .align 2
    str_v0:      .asciiz "\n(v0="
    str_comma:   .asciiz ", v1="
    str_close:   .asciiz ")\n"

.text
.globl main

main:
    la      $a0, scores
    lw      $a1, length
    jal     stats
    
    move    $s0, $v0            
    move    $s1, $v1            

    li      $v0, 4
    la      $a0, str_min
    syscall
    li      $v0, 1
    move    $a0, $s0
    syscall
    
    li      $v0, 4
    la      $a0, str_max
    syscall
    li      $v0, 1
    move    $a0, $s1
    syscall

    la      $a0, scores
    lw      $a1, length
    la      $a2, grade_tab
    la      $a3, hist
    jal     histogram

    la      $s2, hist
    li      $v0, 4
    la      $a0, str_g0
    syscall
    lw      $a0, 0($s2)
    li      $v0, 1
    syscall

    li      $v0, 4
    la      $a0, str_g1
    syscall
    lw      $a0, 4($s2)
    li      $v0, 1
    syscall

    li      $v0, 4
    la      $a0, str_g2
    syscall
    lw      $a0, 8($s2)
    li      $v0, 1
    syscall

    li      $v0, 4
    la      $a0, str_g3
    syscall
    lw      $a0, 12($s2)
    li      $v0, 1
    syscall
    
    li      $v0, 11
    li      $a0, 10
    syscall

    la      $a0, hist
    li      $a1, 4
    jal     draw_hist

    la      $a0, strP
    jal     check_brackets
    
    move    $s0, $v0            
    move    $s1, $v1            
    
    li      $v0, 4
    la      $a0, str_v0
    syscall
    li      $v0, 1
    move    $a0, $s0
    syscall
    
    li      $v0, 4
    la      $a0, str_comma
    syscall
    li      $v0, 1
    move    $a0, $s1
    syscall
    
    li      $v0, 4
    la      $a0, str_close
    syscall

    li      $v0, 10
    syscall

# ----------------------------------------------------------------------------
# Thu tuc: stats
# Tham so: $a0 = dia chi mang word, $a1 = n
# Tra ve: $v0 = min, $v1 = max
# Thanh ghi su dung: $t0 = i, $t1 = dia chi a[i], $t2 = a[i]
# ----------------------------------------------------------------------------
stats:
    lw      $v0, 0($a0)
    lw      $v1, 0($a0)
    li      $t0, 1              
    addi    $t1, $a0, 4         
   
stats_loop:
    bge     $t0, $a1, stats_end 
    lw      $t2, 0($t1)
   
    bgt     $t2, $v1, stats_greater
    blt     $t2, $v0, stats_less
    j       stats_next

stats_greater:
    move    $v1, $t2
    j       stats_next
   
stats_less:
    move    $v0, $t2
   
stats_next:
    addi    $t0, $t0, 1
    addi    $t1, $t1, 4
    j       stats_loop
   
stats_end:
    jr      $ra
   
# ----------------------------------------------------------------------------
# Thu tuc: histogram
# Tham so: $a0 = mang scores, $a1 = n, $a2 = grade_tab, $a3 = hist
# Tra ve: Khong
# Thanh ghi su dung: $t0 = i, $t1 = dia chi scores[i], $t2 = scores[i]
#                    $t3 = dia chi grade_tab[scores[i]], $t4 = nhom
#                    $t5 = dia chi hist[nhom], $t6 = gia tri hist[nhom]
# ----------------------------------------------------------------------------
histogram:
    li      $t0, 0              
    move    $t1, $a0            
   
hist_loop:
    bge     $t0, $a1, hist_end
   
    lw      $t2, 0($t1)         
    add     $t3, $t2, $a2       
   
    lbu     $t4, 0($t3)
    sll     $t4, $t4, 2         
    add     $t5, $t4, $a3
   
    lw      $t6, 0($t5)
    addi    $t6, $t6, 1         
    sw      $t6, 0($t5)

    addi    $t1, $t1, 4         
    addi    $t0, $t0, 1
    j       hist_loop
   
hist_end:
    jr      $ra

# ----------------------------------------------------------------------------
# Thu tuc: draw_hist
# Tham so: $a0 = dia chi mang hist, $a1 = so nhom (4)
# Tra ve: Khong
# Thanh ghi su dung: $t0 = i (nhom), $t1 = dia chi hist[i], $t2 = n
#                    $t3 = hist[i], $t4 = j (dem so '|')
# ----------------------------------------------------------------------------
draw_hist:
    move    $t0, $zero      
    move    $t1, $a0        
    move    $t2, $a1        

draw_outer_loop:
    bge     $t0, $t2, draw_end

    li      $v0, 11
    li      $a0, 103          
    syscall

    li      $v0, 1
    move    $a0, $t0          
    syscall

    li      $v0, 11
    li      $a0, 58           
    syscall

    li      $v0, 11
    li      $a0, 32           
    syscall

    lw      $t3, 0($t1)       
    move    $t4, $zero      

draw_inner_loop:
    bge     $t4, $t3, draw_inner_end 

    li      $v0, 11
    li      $a0, 124          
    syscall

    addi    $t4, $t4, 1     
    j       draw_inner_loop

draw_inner_end:
    li      $v0, 11
    li      $a0, 10           
    syscall

    addi    $t0, $t0, 1     
    addi    $t1, $t1, 4     
    j       draw_outer_loop

draw_end:
    jr      $ra

# ----------------------------------------------------------------------------
# Thu tuc: check_brackets
# Tham so: $a0 = dia chi chuoi .asciiz
# Tra ve: $v0 = vi tri loi, $v1 = ma loi (0 neu hop le)
# Thanh ghi su dung: $t9 = $sp goc, $t0 = vi tri, $t1 = con tro chuoi
#                    $t2 = ky tu chuoi, $t3 = ky tu pop, $t4, $t5 = so sanh
# ----------------------------------------------------------------------------
check_brackets:
    move    $t9, $sp           
    li      $t0, 1             
    move    $t1, $a0           
cb_loop:
    lb      $t2, 0($t1)
    beq     $t2, $zero, cb_end_str
    
    li      $t4, '('
    beq     $t2, $t4, cb_push
    li      $t4, '['
    beq     $t2, $t4, cb_push
    li      $t4, '{'
    beq     $t2, $t4, cb_push
    
    li      $t4, ')'
    beq     $t2, $t4, cb_check_round
    li      $t4, ']'
    beq     $t2, $t4, cb_check_square
    li      $t4, '}'
    beq     $t2, $t4, cb_check_curly
    
    j       cb_next
    
cb_push:
    addi    $sp, $sp, -4
    sw      $t2, 0($sp)        
    j       cb_next
    
cb_check_round: 
    li      $t5, '('
    j       cb_pop

cb_check_square:
    li      $t5, '['
    j       cb_pop
    
cb_check_curly:
    li      $t5, '{'
    j       cb_pop
    
cb_pop:
    beq     $sp, $t9, cb_err2     
    
    lw      $t3, 0($sp)
    addi    $sp, $sp, 4
    
    bne     $t3, $t5, cb_err1     
    j       cb_next       
    
cb_end_str:
    bne     $t9, $sp, cb_err3     
    
    li      $v0, 0             
    li      $v1, 0
    jr      $ra

cb_next:
    addi    $t0, $t0, 1
    addi    $t1, $t1, 1
    j       cb_loop

cb_err1:
    move    $v0, $t0
    li      $v1, 1
    j       cb_clean
cb_err2:
    move    $v0, $t0
    li      $v1, 2
    j       cb_clean
cb_err3: 
    move    $v0, $t0
    li      $v1, 3
    j       cb_clean
    
cb_clean:
    move    $sp, $t9           
    jr      $ra