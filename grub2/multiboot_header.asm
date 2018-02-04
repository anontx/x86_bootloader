
section .multiboot_header
header_start:
    ; magic number
    dd 0xe85250d6
    ; arch 0
    dd 0
    ; header length
    dd header_end - header_start
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))
    

    ; type
    dw 0
    ; flags
    dw 0
    ; size
    dd 8
header_end:

