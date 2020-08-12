#!/bin/bash

VERSION="0.13.0"
THRIFT="thrift-"${VERSION}

JOBS=$(($(grep -c ^processor /proc/cpuinfo 2>/dev/null) + 1))


# install library dependencies
sudo apt -y install automake bison flex g++ \
                    git libboost-all-dev \
                    libevent-dev libssl-dev \
                    libtool make pkg-config \
                    libglib2.0-dev zlib1g-dev

# check thrift
if !(type "thrift" > /dev/null 2>&1); then
   if [ ! -e ${THRIFT}.tar.gz ]; then
      curl -OL http://ftp.iij.ad.jp/pub/network/apache/thrift/${VERSION}/${THRIFT}.tar.gz
      tar -xzf ${THRIFT}.tar.gz
   fi
   cd ${THRIFT}

   CFLAGS="-O3 -g3" CXXFLAGS="-O3 -g3" ./configure --enable-silent-rules \
                                                   --disable-static \
                                                   --disable-tests \
                                                   --disable-tutorial \
                                                   --without-nodejs \
                                                   --without-rs && \
   make -j$JOBS && sudo make install

   if [ $? -eq 0 ]; then
      sudo ldconfig
      cd ../ && sudo rm -rf ${THRIFT}*
   fi
fi
