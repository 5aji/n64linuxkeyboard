# n64 linux keyboard driver development repo


## Folder structure

`tools/` - Containers for toolchains go here. There are currently two:
- `libdragon-toolchain`: toolchain for building libdragon and direct n64 binaries
- `musl-cross-make`: toolchain used for linux with `musl` libc

`src/` - source trees for various components go here, like the linux kernel.
- `linux`: the obvious one, a submodule pointing to our linux fork
- `n64bootloader`: patched version of `clbr/n64bootloader`, the bootloader code.
- `teensy`: The code for the teensy controller emulator.

`bin/` - miscellaneous binaries (extracted cpio/squashfs)


## Development workflow

The Makefile in the root directory of the source tree requires the two container images
to be present. It will then build the Linux kernel, the bootloader, and then try and
make a `.z64` rom out of them. By calling the makefiles in the source directories, they will
be rebuilt on a change, thus causing the output file to be rebuilt.

