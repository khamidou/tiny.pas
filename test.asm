# Simple exit program
.section __TEXT,__text

.globl start
start:
  movl $0x2000001, %eax # system call $1 with $0x2000000 offset
  movl $3, %eax
  add %eax, 2
  # movl $0, %ebx         # set the exit code to be $0
  syscall
