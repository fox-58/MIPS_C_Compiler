O_RDONLY = 0
BASE_DATA_OFFSET = 0x1001
TOKEN_BUFFER_OFFSET = 4096
INSIDE_STRING_OFFSET = 8192
FILE_NAME_OFFSET = 8193

  .text
  # s0: byte num
  # s1: file descriptor
  # s2: curr length of token
main:
main__prologue:
  sub   $sp, $sp, 4
  sw    $fp, ($sp)
  move  $fp, $sp
  sub   $sp, $sp, 16
  sw    $ra, -4($fp)
  sw    $s0, -8($fp)
  sw    $s1, -12($fp)
  sw    $s2, -16($fp)
  
main__body:
  addi  $s2, $zero, 0
  addi  $v0, $zero, 13          # li  $v0, 13

  lui   $a0, BASE_DATA_OFFSET   # la  $a0, file_name
  ori   $a0, $a0, FILE_NAME_OFFSET
  addi  $a1, $zero, O_RDONLY    # li  $a1, O_RDONLY
  addi  $a2, $zero, 0           # li  $a2, 0
  syscall                       # syscall

  addu  $s1, $zero, $v0         # move $s1, $v0

main__scan_loop_init:
  addi  $s0, $zero, 0           # li   $s0, 0

main__scan_loop_body:
  addi  $v0, $zero, 14          # li   $v0, 14
  addu  $a0, $zero, $s1         # move $a0, $s1
  lui   $a1, BASE_DATA_OFFSET
  addu  $a1, $a1, $s0           # la   $a1, buffer($s0)
  addi  $a2, $zero, 1           # li   $a2, 1
  syscall                       # syscall

main__scan_loop_cond:
  beq   $v0, $zero, main__scan_loop_end

  lb    $a0, ($a1)              # lb   $a0, buffer()
  addu  $a1, $zero, $s2
  jal   process_character

  beq   $v0, 1, main__scan_loop_next_character
  beq   $v0, $zero, main__scan_loop_parse_token

main__scan_loop_parse_token:
  jal   parse_token
  addi  $s2, $zero, 0
  j     main__scan_loop_iter

main__scan_loop_next_character:
  addi  $s2, $s2, 1
  j     main__scan_loop_iter

main__scan_loop_iter:
  addi  $s0, $s0, 1
  j     main__scan_loop_body

main__scan_loop_end:
  addi  $t0, $zero, 0           # li  $t0, '\0'
  lui   $t2, BASE_DATA_OFFSET
  addu  $t2, $t2, $s0
  sb    $t0, ($t2)              # sb  $t0, buffer($t1)
  
  addi  $v0, $zero, 4           # li  $v0, 4
  lui   $a0, 0x1001             # la  $a0, buffer
  syscall

  lw    $s2, -16($fp)
  lw    $s1, -12($fp)
  lw    $s0, -8($fp)
  lw    $ra, -4($fp)
  add   $sp, $sp, 4
  lw    $fp, ($sp)
  add   $sp, $sp, 4
  addi  $v0, $zero, 0           # li   $v0, 0
  jr    $ra

process_character:
  # adds the next character to the token buffer
  #
  # arguments:
  #   a0: character
  #   a1: offset into buffer
  # return:
  #   v0: new offset into buffer
  #       0: the token is ready for pasing
  #       1: otherwise
process_character__prologue:
process_character__body:
  bne   $a0, ' ', process_character__next_letter
  lui   $t0, BASE_DATA_OFFSET
  ori   $t0, $t0, INSIDE_STRING_OFFSET
  lb    $t0, ($t0)
  beq   $t0, 1, process_character__next_letter

process_character__end_token:
  addi  $v0, $zero, 0
  j     process_character__epilogue

process_character__next_letter:
  lui   $t0, BASE_DATA_OFFSET
  ori   $t0, $t0, TOKEN_BUFFER_OFFSET
  addu  $t0, $t0, $a1
  sb    $a0, ($t0)

  addi  $v0, $zero, 1

process_character__epilogue:
  jr    $ra

  # parses the token in the buffer
  #
  # arguments
  #   a0: length of token
parse_token:
  jr    $ra


# buffers set to c99 standard for the "minimum" of
# the allowed maximum of a string length
  .data
buffer:
  .space    4096
token_buffer:
  .space    4096
inside_string:
  .byte     0
file_name:
  .asciiz   "../cfile.c"

