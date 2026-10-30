O_RDONLY = 0
  .text
  # t0 = file descriptor
  # t1 = byte num
main:
main__prologue:
  addi  $v0, $zero, 13          # li  $v0, 13

  lui   $a0, 0x1001             # la  $a0, file_name
  addi  $a1, $zero, O_RDONLY    # li  $a1, O_RDONLY
  addi  $a2, $zero, 0           # li  $a2, 0
  syscall                       # syscall

  addu  $t0, $zero, $v0         # move $t0, $v0

main__scan_loop_init:
  addi  $t1, $zero, 0           # li   $t1, 0

main__scan_loop_body:
  addi  $v0, $zero, 14          # li   $v0, 14
  addu  $a0, $zero, $t0         # move $a0, $t0
  lui   $a1, 0x1001
  ori   $a1, 8
  addu  $a1, $a1, $t1           # la   $a1, buffer($t1)
  addi  $a2, $zero, 1           # li   $a2, 1
  syscall                       # syscall

main__scan_loop_cond:
  beq   $v0, $zero, main__scan_loop_end

main__scan_loop_iter:
  addi  $t1, $t1, 1
  j     main__scan_loop_body

main__scan_loop_end:
  addi  $t0, $zero, 0           # li  $t0, '\0'
  lui   $t2, 0x1001
  ori   $t2, 8
  addu  $t2, $t2, $t1
  sb    $t0, ($t2)              # sb  $t0, buffer($t1)
  
  addi  $v0, $zero, 4           # li  $v0, 4
  lui   $a0, 0x1001             # la  $a0, buffer
  ori   $a0, 8
  syscall

  addi  $v0, $zero, 0           # li   $v0, 0
  jr    $ra

  .data
file_name:
  .asciiz   "cfile.c"
buffer:
  .space    4096

