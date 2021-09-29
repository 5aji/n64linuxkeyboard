the `mycpio.txt` file contains the specification for the CPIO to be created by the linux build process.

see https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt for more info.

files needed for initramfs should be in the initramfs/ folder. the makefile will be run before the linux
makefile is run, so source files should be compiled then (using linux-toolchain)


