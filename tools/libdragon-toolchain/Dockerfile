#clbr libdragon
FROM docker.io/debian

ENV N64_INST=/usr/local
ENV GCC_V=8.2.0
WORKDIR /workdir

COPY . ./sources

RUN apt-get update && \
	apt-get install -yq wget bzip2 gcc g++ make file libmpfr-dev libmpc-dev libpng-dev zlib1g-dev texinfo git gcc-multilib && \
	apt-get clean && \
	gcc sources/size2bin.c -static -o /usr/bin/size2bin && \
	cp ./sources/build /tmp && \
	cd /tmp && \
	export JOBS=$(nproc) && \
	./build && \
	cd /workdir/sources/libdragon/tools && \
	make && \
	make install && \
	cd /workdir/sources/libdragon && \
	make && \
	make install && \
	cd /workdir && \
	rm -rf /tmp/build * && \
	find ${N64_INST}/bin -type f | xargs strip && \
	rm -rf /usr/local/share/locale/* && \
	apt-get autoremove -yq
