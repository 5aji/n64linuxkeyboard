# n64 linux keyboard driver development repo


## Folder structure

`tools/` - Containers for toolchains go here. There are currently two:
- `libdragon-toolchain`: toolchain for building libdragon and direct n64 binaries
- `musl-cross-make`: toolchain used for linux with `musl` libc

`src/` - source trees for various components go here, like the linux kernel.
- `linux`: the obvious one, a submodule pointing to our linux fork
- `n64bootloader`: submodule for `clbr/n64bootloader`, the bootloader code.


