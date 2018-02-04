# boot.s

.set KERNEL_SIZE, 50
.set KERNEL_ADDRESS, 0x7e00

.text
.code16
.global start

start:
  ljmp $0, $real_start

real_start:
  cli
  xorw %ax, %ax
  movw %ax, %ds
  movw %ax, %es
  movw %ax, %ss
  movw $0x7c00, %sp
  sti

  pushw %dx

  pushw $boot
  call print_string
  
  popw %dx
  movb $0x42, %ah
  movw $dap, %si
  int $0x13
  jnc 2f
  pushw $read_error
  call print_string
1:
  hlt
  jmp 1b
2:
  cli
  lgdt gdt_pointer
  movl %cr0, %eax
  orb $0x1, %al
  movl %eax, %cr0

  ljmp $0b1000, $pmode


.code32
pmode:
  movw $0b10000, %ax
  movw %ax, %ds
  movw %ax, %es
  movw %ax, %fs
  movw %ax, %gs
  movw %ax, %ss

  ljmp $0b1000, $KERNEL_ADDRESS

.code16
print_string:
  pushw %bp
  
  movw %sp, %bp
  movw 4(%bp), %si
  cld

1: 
  lodsb
  testb %al, %al
  jz 2f
  movb $0xe, %ah
  movw $0x7, %bx
  int $0x10
  jmp 1b
2:
  popw %bp
  ret $2

dap:
dap_size:       .byte 0x10
dap_reserved:   .byte 0x00
dap_blocks:     .word KERNEL_SIZE
dap_buffer:     .word KERNEL_ADDRESS, 0x00
dap_lba:        .long 0x1, 0x00

gdt:
  # null
  .long 0, 0
  # code
  .word 0xffff
  .word 0x0000
  .byte 0x00
  .byte 0b10011010
  .byte 0b11001111
  .byte 0x00
  # data
  .word 0xffff
  .word 0x0000
  .byte 0x00
  .byte 0b10010010
  .byte 0b11001111
  .byte 0x00
gdt_end:

gdt_pointer:
  .word gdt_end - gdt -1
  .long gdt

boot:           .asciz "loading kernel..\r\n"
read_error:     .asciz "read error."

.org 0x1fe
.word 0xaa55
