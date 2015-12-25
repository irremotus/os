BOOTNAME := boot
DISKNAME := boot

SRCDIR := src
OBJDIR := obj
BINDIR := bin


all: boot

boot:
	nasm -f bin ${SRCDIR}/boot.asm -o ${BINDIR}/${BOOTNAME}

run:
	qemu-system-i386 ${BINDIR}/${DISKNAME}
