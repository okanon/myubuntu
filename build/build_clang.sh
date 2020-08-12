#!/bin/bash

JOBS=$(($(grep -c ^processor /proc/cpuinfo 2>/dev/null) + 1))

# check cmake
if !(type "cmake" > /dev/null 2>&1); then
   git clone https://github.com/Kitware/CMake && cd CMake

   ./bootstrap CFLAGS="-O3" CXXFLAGS="-O3"
   make -j$JOBS && sudo make install
   
   cd ..
   if type "cmake" > /dev/null 2>&1; then
      sudo rm -rf CMake
   fi

   sudo ldconfig
fi

# build llvm-clang
if !(type "clang" > /dev/null 2>&1); then
   git clone https://github.com/apple/llvm-project && cd llvm-project
   mkdir llvm.build && cd llvm.build
   
   cmake -DCMAKE_C_FLAGS="-O3" \
         -DCMAKE_CXX_FLAGS="-O3" \
         -DCMAKE_BUILD_TYPE=Release \
         -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt" \
         ../llvm

   make -j$JOBS && sudo make install

   cd ../../
   if type "clang" > /dev/null 2>&1; then
      sudo rm -rf llvm-project
   fi

   sudo ldconfig
fi
