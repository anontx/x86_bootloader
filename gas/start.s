.text
.code32
.global start

start:
  movl $0x9fbff, %esp
  call kmain
1:
  hlt
  jmp 1b
