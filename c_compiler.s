O_RDONLY = 0
  .text
  # s1 = file descriptor
  # s0 = byte num
main:
main__prologue:
  sub   $sp, $sp, 4
  sw    $fp, ($sp)
  move  $fp, $sp
  sub   $sp, $sp, 4
  sw    $ra, -4($fp)
 
  addi  $v0, $zero, 13          # li  $v0, 13

  lui   $a0, 0x1001             # la  $a0, file_name
  addi  $a1, $zero, O_RDONLY    # li  $a1, O_RDONLY
  addi  $a2, $zero, 0           # li  $a2, 0
  syscall                       # syscall

  addu  $s1, $zero, $v0         # move $s1, $v0

main__scan_loop_init:
  addi  $s0, $zero, 0           # li   $s0, 0

main__scan_loop_body:
  addi  $v0, $zero, 14          # li   $v0, 14
  addu  $a0, $zero, $s1         # move $a0, $s1
  lui   $a1, 0x1001
  ori   $a1, 8
  addu  $a1, $a1, $s0           # la   $a1, buffer($s0)
  addi  $a2, $zero, 1           # li   $a2, 1
  syscall                       # syscall

main__scan_loop_cond:
  beq   $v0, $zero, main__scan_loop_end

  lb    $a0, ($a1)              # lb   $a0, buffer()
  jal   process_character

main__scan_loop_iter:
  addi  $s0, $s0, 1
  j     main__scan_loop_body

main__scan_loop_end:
  addi  $t0, $zero, 0           # li  $t0, '\0'
  lui   $t2, 0x1001
  ori   $t2, 8
  addu  $t2, $t2, $s0
  sb    $t0, ($t2)              # sb  $t0, buffer($t1)
  
  addi  $v0, $zero, 4           # li  $v0, 4
  lui   $a0, 0x1001             # la  $a0, buffer
  ori   $a0, 8
  syscall

  lw    $ra, -4($fp)
  add   $sp, $sp, 4
  lw    $fp, ($sp)
  add   $sp, $sp, 4
  addi  $v0, $zero, 0           # li   $v0, 0
  jr    $ra

process_character:
  jr    $ra

  .data
file_name:
  .asciiz   "cfile.c"
buffer:
  .space    4096

