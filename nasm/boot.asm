[org 0x7c00]

  jmp start


[bits 16]

  INITSEG    equ 0x7e00

;messages
;--------------------------------
  MSG_DISK_READ_ERROR  db "disk read error!", 0
  MSG_LOADING          db "system loading..", 0
  MSG_PROT_MODE        db "switched into 32-bit Protected Mode"

;global descriptor table
;--------------------------------
gdt_start:

gdt_null:
  dd 0x0
  dd 0x0

gdt_code:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10011010b
  db 11001111b
  db 0x0

gdt_data:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1
  dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

;functions
;--------------------------------
print_string:
  push ax
  push si

  _loop:
    lodsb
    cmp al, 0
    je _end

    mov ah, 0x0e
    int 0x10
    jmp _loop

  _end:

  pop si
  pop ax
  ret


read_from_disk:
  pusha

  mov ah, 0x02

  mov ch, 0
  mov cl, 2
  mov dh, 0

  push bx
  mov bx, 0
  mov es, bx
  pop bx

  int 0x13

  jc disk_read_error

  popa
  ret


disk_read_error:
  mov si, MSG_DISK_READ_ERROR
  call print_string
  jmp $


switch_to_prot_mode:
  cli

  lgdt [gdt_descriptor]

  mov eax, cr0
  or eax, 0x1
  mov cr0, eax

  jmp CODE_SEG:init_prot_mode


[bits 32]

init_prot_mode:
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000
  mov esp, ebp
  
  jmp INITSEG

[bits 16]

start:
  
  mov bp, 0xffff
  mov sp, bp

  mov si, MSG_LOADING
  call print_string

  mov al, 9
  mov bx, INITSEG
  call read_from_disk
    
  call switch_to_prot_mode

  jmp $
    
  times 510-($-$$) db 0x0
  db 0x55, 0xaa
