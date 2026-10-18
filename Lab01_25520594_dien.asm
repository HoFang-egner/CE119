# Quy uoc thanh ghi:
#   $s0 = x   : so kWh nguoi dung nhap (da kiem tra hop le)
#   $s1 = total  : tong tien dien dang tinh (dong)
#   $s2 = remain : so kWh con lai chua tinh tien
#   $s3 = prevTop : can tren cua bac truoc (bien chay theo vong lap)
#   $s4 = idx4  : offset byte vao 2 mang upto[] va price[] (= i*4)

.data
prompt:     .asciiz "Nhap so kWh (0..9999): "
err_msg:    .asciiz "Gia tri khong hop le, nhap lai.\n"
res_prefix:  .asciiz "Tien dien: "
res_suffix:  .asciiz " dong\n"

upto:   .word 50, 100, 200, 300, 400, 9999   # can tren tung bac (kWh)
price:  .word 1680, 1740, 2030, 2580, 2930, 3080  # don gia tung bac (dong/kWh)

.text
main:
input_loop:
  li $v0, 4
  la $a0, prompt
  syscall 
  
  li $v0, 5
  syscall
  move $s0, $v0 
  
  slti $t0, $s0, 10000
  bne  $t0, $zero, valid
  li $v0, 4
  la $a0, err_msg
  syscall  
  j input_loop
  
valid: 
  li $s1, 0
  add $s2, $s0, $zero
  li $s3, 0
  li $s4, 0
  
loop: 
  blez $s2, done
  
  la $t0, upto
  add $t0, $t0, $s4
  lw $t1, 0($t0)          # $t1 = can tren cua bac hien tai (upto[i])
  
  la $t2, price
  add $t2, $t2, $s4
  lw $t3, 0($t2)        # $t3 = don gia (price[i])
  
  sub  $t4, $t1, $s3  # $t4 = chieu rong cua bac = upto[i] - prevTop

  slt  $t6, $s2, $t4   # Kiem tra xem remain < chieu rong bac khong      
  beq  $t6, $zero, use_full
  move $t7, $s2         # amount = remain       
  j    add_amount
  
use_full:
  move $t7, $t4         # amount = chieu rong bac
  
add_amount:
  mul  $t8, $t7, $t3   # t8 = amount * price[i]
  add  $s1, $s1, $t8   # total += amount*price
  sub  $s2, $s2, $t7    # remain -= amount
  move $s3, $t1        # prevTop = upto[i]
  addi $s4, $s4, 4     #qua bac ke tiep (4 bytes)
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
