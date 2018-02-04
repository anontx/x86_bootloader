AS = nasm
ASFLAG = -f elf64
LD = ld
LDFLAG = -n 
CC = gcc
CCFLAG = -g -ffreestanding -m64

KERNEL.BIN = kernel.bin
KERNEL.ISO = os.iso
QEMU = qemu-system-x86_64

OBJS = multiboot_header.o boot.o kmain.o

.PHYTON = all run clean

all: $(KERNEL.ISO)

%.o: %.asm
	$(AS) $(ASFLAG) $^

%.o: %.c
	$(CC) $(CCFLAG) -o $@ -c $^

$(KERNEL.BIN): $(OBJS)
	$(LD) $(LDFLAG) -o $(KERNEL.BIN) -T linker.ld $^

$(KERNEL.ISO): $(KERNEL.BIN)
	-mkdir -p ./iso_files/boot/grub
	-mv ./$(KERNEL.BIN) ./iso_files/boot/
	-cp ./grub.cfg ./iso_files/boot/grub/
	-grub-mkrescue -o $(KERNEL.ISO) ./iso_files

run: $(KERNEL.ISO)
	$(QEMU) -cdrom $<

clean:
	-rm -f *.bin *.o *.iso
	-rm -rf ./iso_files
