

MOUNT_DIR=/workdir
LIBDRAGON_PREFIX=docker run --rm -v ${PWD}:${MOUNT_DIR} libdragon-toolchain

LINUX_PREFIX=docker run --rm -v ${PWD}:${MOUNT_DIR} linux-toolchain 

.PHONY: all bootloader linux
all: linux.z64


BOOTLOADER_PATH=src/n64bootloader/bootloader.bin

bootloader:
	${LIBDRAGON_PREFIX} make -C src/n64bootloader

LINUX_PATH=src/linux/vmlinux.32

linux:
	${LINUX_PREFIX} make -C src/linux

linux.z64: bootloader linux
	${LIBDRAGON_PREFIX} n64tool yada yada
