TARGET=i686-unknown-linux-gnu

AS=nasm
CC=${TARGET}-gcc
LD=${TARGET}-ld
BOCHS=bochs

all: os.img

boot.bin: boot.asm
	${AS} $< -f bin -o $@

kernel.bin: kernel.c
	${CC} -ffreestanding -c $< -o kernel.o -m32
	${LD} -T link.ld -o $@ kernel.o

os.img: boot.bin kernel.bin
	cat $^ > $@
	truncate $@ -s 10240

run: os.img
	${BOCHS} -q -f ./bochsrc

clear:
	rm *.o
	rm *.bin
