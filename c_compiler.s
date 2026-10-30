O_RDONLY = 0
  .text
  # t0 = file descriptor
  # t1 = byte num
main:
  li    $v0, 13
  la    $a0, file_name
  li    $a1, O_RDONLY
  li    $a2, 0
  syscall

  move  $t0, $v0

main__scan_loop_init:
  li    $t1, 0

main__scan_loop_body:
  li    $v0, 14
  move  $a0, $t0
  la    $a1, buffer($t1)
  li    $a2, 1
  syscall

main__scan_loop_cond:
  beq   $v0, 0, main__scan_loop_end

main__scan_loop_iter:
  addi  $t1, $t1, 1
  j     main__scan_loop_body

main__scan_loop_end:
  li    $t0, '\0'
  sb    $t0, buffer($t1)

  li    $v0, 4
  la    $a0, buffer
  syscall

  li    $v0, 0
  jr    $ra

  .data
file_name:
  .asciiz "cfile.c"
buffer:
  .space 256
