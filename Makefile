# Build everything makefile

# where the containers start pwd
WORKDIR=/workdir

# use sudo if docker is present else use podman
ifneq (, $(@shell which podman))
	DOCKER_BASE = podman
else
	DOCKER_BASE = sudo docker
endif
DOCKER_BASE +=run --rm -v ${PWD}:${WORKDIR} # mount pwd and rm container after finish

LIBDRAGON_PREFIX = ${DOCKER_BASE} libdragon-toolchain 
LINUX_PREFIX = ${DOCKER_BASE} linux-toolchain 

.PHONY: all bootloader linux cpio clean
all: linux.z64

# CPIO stuff
CPIO_PATH = src/cpio/mycpio.txt
cpio:
	$(LINUX_PREFIX) make -C src/cpio

# Bootloader stuff
BOOTLOADER_PATH=src/n64bootloader/bootloader.bin

bootloader:
	$(LIBDRAGON_PREFIX) make -C src/n64bootloader

# linux stuff
LINUX_PATH=src/linux/vmlinux.32
# variables for linux kernel
CONFIG_INITRAMFS_SOURCE ?= $(CPIO_PATH)
KCONFIG_PATH ?=bin/Kconfig

linux: cpio
	$(LINUX_PREFIX) make ARCH=mips CROSS_COMPILE=mips64-linux-musln32- \
		CONFIG_INITRAMFS_SOURCE=../../$(CONFIG_INITRAMFS_SOURCE) \
		KCONFIG_CONFIG=../../$(KCONFIG_PATH) \
		-j$$(nproc) -C src/linux

# size binary files for inclusion into the n64 image
linux_size.bin: linux
	$(LIBDRAGON_PREFIX) size2bin $(LINUX_PATH) $@

### SQUASHFS CONFIGURATION
SQUASHFS_PATH = bin/extracted.squashfs
disk_size.bin: $(SQUASHFS_PATH)
	$(LIBDRAGON_PREFIX) size2bin $^ $@


# final z64 output
N64_HEADER = bin/header.n64
N64_FLAGS = -l 8M -h $(N64_HEADER) -t "Linux"

linux.z64: bootloader linux linux_size.bin disk_size.bin
	DISKOFF=$$(ls -l $(LINUX_PATH) | awk '{print $$5}'); \
	DISKOFF=$$((((DISKOFF + 4095) & ~4095) + 1048576)); \
	$(LIBDRAGON_PREFIX) n64tool $(N64_FLAGS) -o $@ $(BOOTLOADER_PATH) \
		-s 1048568B disk_size.bin \
		-s 1048572B linux_size.bin \
		-s 1M $(LINUX_PATH) \
		-s $${DISKOFF}B $(SQUASHFS_PATH)
	$(LIBDRAGON_PREFIX) chksum64 $@


clean:
	$(LINUX_PREFIX) make clean -C src/linux
	$(LINUX_PREFIX) make clean -C src/cpio
	$(LIBDRAGON_PREFIX) make clean -C src/n64bootloader
	rm *.bin

