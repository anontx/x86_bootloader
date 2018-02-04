TARGET=i686-unknown-linux-gnu

SRC=kernel.c

GCC_WARNINGS=-Wall -Wextra
OPTFLAGS=-Os
CFLAGS=-nostdlib -nostdinc -fno-builtin -fno-stack-protector ${GCC_WARNINGS} \
	   ${OPTFLAGS} -pipe -m32 -march=i686

AS=${TARGET}-as
LD=${TARGET}-ld
CC=${TARGET}-gcc
BOCHS=bochs

OBJ=${SRC:.c=.o}

all: os.img

boot.bin: boot.s
	${AS} -o boot.o $<
	${LD} -T link_boot.ld -o $@ boot.o

start.o: start.s
	${AS} -o $@ $<

kernel.bin: start.o ${OBJ}
	${LD} -T link.ld -o $@ start.o ${OBJ}

os.img: boot.bin kernel.bin
	cat $^ > $@
	truncate $@ -s 1032192 #(cyl * heads * spt * 512)

run: os.img
	${BOCHS} -q -f ./bochsrc

clear:
	rm -f *.o
	rm -f *.bin
	rm -f *.img
