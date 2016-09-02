# android-afl

Fuzzing Android program with [american fuzzy lop (AFL)][american-fuzzy-lop]

## android-afl: Android-enabled version of AFL

android-afl is a modified version of AFL that supports fuzzing on Android, the SHM has been replaced with ASHMEM because of Android disable SHM in the kernel. Extra codes have been added in afl-gcc.c, afl-as.c and afl-as.h to support arm arch. Android.mk has been added to support Android build system and llvm_mode, Please refer to the [android-afl.patch][android-afl.patch] for more details.

## Requirements
* Android source code(e.g. 6.0.1) is needed.
* llvm-3.8 and clang-3.8 are needed to support llvm_mode on Android, you can install using `apt-get install llvm-3.8 clang-3.8` on Ubuntu.

## Build
first, download and build the [Android open-source project (AOSP)][Android open-source project].
then, download all the android-afl source code to AOSP folder:
`cd AOSP`
`git clone https://github.com/ele7enxxh/android-afl`
to build:
`cd android-afl`
`mm -B`
this will produce all afl binaries that you can use on host(e.g. Linux) or Android.

## Usage

afl-gcc/afl-g++, afl-clang/afl-clang++ and afl-clang-fast/afl-clang-fast++ are all supported in android-afl.

### recompile with afl-gcc and afl-g++

first, add this code in Android.mk which you want to fuzz:
`LOCAL_CLANG := false`
`LOCAL_CC := afl-gcc`
`LOCAL_CXX := afl-g++`
if the targeted binary is a shared library, you also need do that in the Android.mk like:
`LOCAL_LDLIBS := -Wl,--no-warn-shared-textrel`
then you can recompile the Android program to produce the binary on arm arch:
`AFL_CC=arm-linux-androideabi-gcc AFL_CXX=arm-linux-androideabi-g++ AFL_AS=arm-linux-androideabi-as mm -B`
else, if you want to fuzz on host:
`AFL_CC=gcc AFL_AS=as mm -B`

### recompile with afl-clang and afl-clang++

first, add this code in Android.mk which you want to fuzz:
`LOCAL_CLANG := true`
`LOCAL_CC := afl-clang`
`LOCAL_CXX := afl-clang++`
if the target binary is a shared library, you also need do that in the Android.mk like:
`LOCAL_LDLIBS := -Wl,--no-warn-shared-textrel`
then you can recompile the Android program to produce the binary on arm arch:
`AFL_CC=/usr/bin/clang-3.8 AFL_CXX=/usr/bin/clang++-3.8 AFL_AS=arm-linux-androideabi-as mm -B`
else, if you want to fuzz on host:
`AFL_CC=/usr/bin/clang-3.8 AFL_CXX=/usr/bin/clang++-3.8 AFL_AS=as mm -B`

### recompile with afl-clang-fast and afl-clang-fast++

first, add this code in Android.mk which you want to fuzz:
`LOCAL_CLANG := true`
`LOCAL_CC := afl-clang`
`LOCAL_CXX := afl-clang++`
if you want get the binary on arm arch, you need add this code in the Android.mk:
`LOCAL_LDFLAGS := $(HOST_OUT)/lib/afl/afl-llvm-rt.o`
else on 64-bit host:
`LOCAL_LDFLAGS := $(HOST_OUT)/lib/afl/afl-llvm-rt-host.o`
else on 32-bit host:
`LOCAL_LDFLAGS := $(HOST_OUT)/lib/afl/afl-llvm-rt-host-32.o`
now you can recompile Android program:
`AFL_CC=/usr/bin/clang-3.8 AFL_CXX=/usr/bin/clang++-3.8 mm -B`

### To fuzz

if you want fuzz on host, you should use the afl-fuzz in the \$(HOST\_OUT)/bin folder, otherwise you need to use the afl-fuzz in the \$(target\_OUT)/bin folder. To ingore `bind_to_free_cpu`, the `AFL_NO_AFFINITY=1` should been set. Please refer to [AFl README][AFL README] for more details.

## Note
not all of the AFL tools have been tested on Android, but afl-fuzz has been working great on android-6.0.1 for me.

[american-fuzzy-lop]: http://lcamtuf.coredump.cx/afl/
[android-afl.patch]: https://github.com/ele7enxxh/android-afl/blob/master/android-patch/android-afl.patch
[Android open-source project]: https://source.android.com/
[AFL README]: lcamtuf.coredump.cx/afl/README.txt




