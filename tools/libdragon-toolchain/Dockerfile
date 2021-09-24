#clbr libdragon
FROM debian

ENV N64_INST=/usr/local

WORKDIR /workdir

COPY . ./libdragon-source

RUN apt-get update && \
    apt-get install -yq wget bzip2 gcc g++ make file libmpfr-dev libmpc-dev libpng-dev zlib1g-dev texinfo git gcc-multilib && \
    apt-get clean && \
    cd ./libdragon-source && \
    cp -r ./tools /tmp/tools && \
    cd .. && \
    cd /tmp/tools && \
	export JOBS=${JOBS:-`getconf _NPROCESSORS_ONLN`} && \
	export GCC_V=8.2.0 && \
    ./build && \
    cd /workdir && \
    rm -rf /tmp/tools && \
    rm -rf * && \
    find /usr/local/bin -type f | xargs strip && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/plugin/gengtype && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/liblto_plugin.so.0.0.0 && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/liblto_plugin.so.0 && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/lto-wrapper && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/collect2 && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/cc1plus && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/cc1 && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/install-tools/fixincl && \
    strip /usr/local/libexec/gcc/mips64-elf/8.2.0/lto1 && \
    rm -rf /usr/local/share/locale/* && \
    apt autoremove -yq
