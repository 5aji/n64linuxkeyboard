# image for building musl-cross-make
#FROM alpine AS builder
#
#RUN apk update \
#	&& apk add --update alpine-sdk
#
#COPY musl-cross-make /musl-cross-make
#COPY config.mak /musl-cross-make/
#RUN cd /musl-cross-make && \
#	make -j$(nproc)
#
# final image
FROM alpine

RUN apk update \
	&& apk add --update alpine-sdk perl flex bison elfutils-dev gcompat bash u-boot-tools xz

COPY musl-cross-make /musl-cross-make
COPY config.mak /musl-cross-make/

RUN cd /musl-cross-make && \
	make -j$(nproc) && \
	make install && \
	cd / && \
	rm -rf /musl-cross-make

RUN mkdir /workdir
WORKDIR /workdir
