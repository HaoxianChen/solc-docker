FROM ubuntu:focal

# Generic packages
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt install -y \
  cmake \
  curl \
  git \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-test-dev \
  python3-pip \
  software-properties-common \
  unzip \
  wget

# Install Z3
ARG z3=z3-4.8.14-x64-glibc-2.31
COPY $z3/bin/z3 /usr/local/bin
COPY $z3/bin/libz3.so /usr/local/lib/
COPY $z3/include/* /usr/local/include/

# Copy solidity sourcecode, instead of cloning it
RUN mkdir solidity
COPY solidity solidity

ARG NTHREADS=16
RUN cd solidity \
        && mkdir -p build \
        && cd build \
        && cmake .. \
        && make -j$NTHREADS\
        && make install

RUN cp /solidity/build/solc/solc /usr/local/bin
