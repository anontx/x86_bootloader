global _start
extern kmain

section .text
bits 32

_start:
    mov dword [0xb8000], 0x2f4b2f4f

    call kmain
    hlt
