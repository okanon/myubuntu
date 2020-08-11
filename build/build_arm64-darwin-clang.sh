#!/bin/bash

TRIPLE="arm-apple-darwin11"
IPHONEOS_SDK="13.5"
ARCH="arm64" # armv7s arm64 arm64e


# check kernel
if [ $(uname -s) != "Linux" ]; then
   echo "Kernel is not Linux"
   exit 1
fi

# install subversion
if !(type "svn" > /dev/null 2>&1); then
   sudo apt -y install subversion
fi

# check apple/llvm-clang
if !(type "clang" > /dev/null 2>&1); then
   echo "Required clang"
   exit 2
else
   clang --version | grep apple > /dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo "Required apple/llvm-clang (github)"
      exit 2
   fi
fi

# build & install arm-apple-darwin-clang
if !(type "arm-apple-darwin11-clang" > /dev/null 2>&1); then
   if [ ! -e cctools-port ]; then
      git clone https://github.com/tpoechtrager/cctools-port \
         && cd cctools-port/usage_examples/ios_toolchain
   else
      cd cctools-port/usage_examples/ios_toolchain
   fi
   
   if [ ! -e iPhoneOS${IPHONEOS_SDK}.sdk.tar.xz ]; then
      svn checkout https://github.com/xybp888/iOS-SDKs/trunk/iPhoneOS${IPHONEOS_SDK}.sdk
      svn checkout https://github.com/okanon/iPhoneOS.sdk/trunk/iPhoneOS13.2.sdk/usr/include
      mv include/c++ iPhoneOS${IPHONEOS_SDK}.sdk/usr/include/ && rm -rf include
      find . -name ".svn" | xargs rm -rf

      tar -Jcf iPhoneOS${IPHONEOS_SDK}.sdk.tar.xz iPhoneOS${IPHONEOS_SDK}.sdk
   fi

   if [ ! -e target ]; then
      /bin/bash build.sh $PWD/iPhoneOS${IPHONEOS_SDK}.sdk.tar.xz $ARCH
      if [ $? -eq 0 ]; then
         cd target/bin
         ln -s ${TRIPLE}-clang arm-clang
         ln -s ${TRIPLE}-clang++ arm-clang++
         ln -s ${TRIPLE}-otool otool
         ln -s ${TRIPLE}-dyldinfo dyldinfo
         ln -s ${TRIPLE}-ObjectDump ${TRIPLE}-objdump
         cd ../../

         if [ ! -e /usr/local/ios ]; then
            sudo cp -rf target /usr/local/ios
         fi
      fi
   fi
fi
