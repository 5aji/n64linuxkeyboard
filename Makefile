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

.PHONY: all bootloader linux
all: linux.z64

# Bootloader stuff
BOOTLOADER_PATH=src/n64bootloader/bootloader.bin

bootloader:
	$(LIBDRAGON_PREFIX) make -C src/n64bootloader

# linux stuff
# FIXME: needs CPIO integration
LINUX_PATH=src/linux/vmlinux.32
CPIO_PATH ?=bin/extracted.cpio
KCONFIG_PATH ?=bin/Kconfig

linux:
	$(LINUX_PREFIX) make ARCH=mips CROSS_COMPILE=mips64-linux-musln32- \
		CONFIG_INITRAMFS_SOURCE=../../$(CPIO_PATH) \
		KCONFIG_CONFIG=../../$(KCONFIG_PATH) \
		-j$$(nproc) -C src/linux

# size binary files for inclusion into the n64 image
linux_size.bin: $(LINUX_PATH)
	$(LIBDRAGON_PREFIX) size2bin $^ $@

# FIXME: squashFS is hardcoded/incomplete
disk_size.bin: mydisk
	$(LIBDRAGON_PREFIX) size2bin $^ $@


# final z64 output
N64_FLAGS = -l 8M -h header -t "Linux"

linux.z64: bootloader linux
	$(LIBDRAGON_PREFIX) n64tool $(N64_FLAGS) -o $@ $(BOOTLOADER_PATH) \

clean:
	$(LINUX_PREFIX) make clean -C src/linux
