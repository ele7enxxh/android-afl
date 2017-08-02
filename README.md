# android-afl

Fuzzing Android program with [american fuzzy lop (AFL)][american-fuzzy-lop]

## android-afl: Android-enabled version of AFL

android-afl is a modified version of AFL that supports fuzzing on Android, the SHM has been replaced with ASHMEM because of Android disable SHM in the kernel. Extra codes have been added in afl-gcc.c, afl-as.c and afl-as.h to support arm arch. Android.mk has been added to support Android build system and llvm_mode. Please refer to the [android-afl.patch][android-afl.patch] for more details.

## Requirements
* Android source code(e.g. 6.0.1) is needed.
* llvm-5.0 and clang-5.0 are needed to provide support for llvm_mode on Android, you can install using `apt-get install llvm clang` on Ubuntu.

## Build
first, download and build the [Android open-source project (AOSP)][Android open-source project].
then, download all the android-afl source code to AOSP folder:
```
cd AOSP
git clone https://github.com/ele7enxxh/android-afl
```
to build:
```
. build/envsetup.sh
cd android-afl
mm
```
this will produce all afl binaries that you can use on host(e.g. Linux) or Android.

## Usage

afl-gcc/afl-g++, afl-clang/afl-clang++ and afl-clang-fast/afl-clang-fast++ are all supported in android-afl. Please refer to [android-afl-test][android-afl-test] for more details.

### To fuzz

if you want fuzz on host, you should use the afl-fuzz in the $(HOST\_OUT)/bin folder, otherwise you need to use the afl-fuzz in the $(target\_OUT)/bin folder. To ingore `bind_to_free_cpu`, the `AFL_NO_AFFINITY=1` should been set. Please refer to [AFl README][AFL README] for more details.

## Note
not all of the AFL tools have been tested on Android, but afl-fuzz has been working great on android-6.0.1 for me.

[american-fuzzy-lop]: http://lcamtuf.coredump.cx/afl/
[android-afl.patch]: https://github.com/ele7enxxh/android-afl/blob/master/android-patch/afl-2.33b-android.patch
[Android open-source project]: https://source.android.com/
[android-afl-test]: https://github.com/ele7enxxh/android-afl/tree/master/android-test
[AFL README]: http://lcamtuf.coredump.cx/afl/README.txt


```
adb devices
adb push ../out/target/product/generic/system/bin/ /data/local/tmp

```
