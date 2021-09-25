#clbr libdragon
FROM debian

ENV N64_INST=/usr/local
ENV GCC_V=8.2.0
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
    ./build && \
    cd /workdir && \
    rm -rf /tmp/tools && \
    rm -rf * && \
    find /usr/local/bin -type f | xargs strip && \
    find /usr/local/libexec/gcc/mips64-elf/${GCC_V} -type f | xargs strip && \
    rm -rf /usr/local/share/locale/* && \
    apt autoremove -yq
