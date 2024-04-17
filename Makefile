K=kernel
U=user

OBJS = \
	$K/entry.o \
	$K/proc.o \
	$K/spinlock.o \
	$K/main.o \
	$K/kernelvec.o \
	$K/start.o \
	$K/trampoline.o \
	$K/trap.o \
	$K/console.o \
	$K/printf.o \
	$K/uart.o \
	$K/string.o \
	$K/file.o

TOOLPREFIX := riscv64-unknown-elf-

QEMU = qemu-system-riscv64

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump


CFLAGS = -Wall -Werror -O0 -fno-omit-frame-pointer -ggdb -gdwarf-2
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += -fno-stack-protector
CFLAGS += -fno-pie -no-pie

LDFLAGS = -z max-page-size=4096

$K/kernel: $(OBJS) $K/kernel.ld $U/initcode 
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel $(OBJS)

$U/initcode: $U/initcode.S
	$(CC) $(CFLAGS) -nostdinc -I. -Ikernel -c $U/initcode.S -o $U/initcode.o
	#$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -Ikernel -c $U/initcode.S -o $U/initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o $U/initcode.out $U/initcode.o

CPUS := 1

QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 

QEMUGDB = -s -S

qemu: $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)


qemu-gdb: $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)  $(QEMUGDB)

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym \
	$U/initcode $U/initcode.out $K/kernel fs.img \
	mkfs/mkfs \
        $U/usys.S \
	$(UPROGS)
mkfs/mkfs: mkfs/mkfs.c $K/include/fs.h $K/include/param.h
	gcc -Werror -Wall -I. -o mkfs/mkfs mkfs/mkfs.c

fs.img: mkfs/mkfs $(UPROGS)
	mkfs/mkfs fs.img $(UPROGS)
