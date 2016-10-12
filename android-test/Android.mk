LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := crash.c
LOCAL_MODULE := crash

# test afl-gcc/afl-g++ on ARM/Android
# to build: TEST_GCC_ARM=true mm -B
ifeq ($(TEST_GCC_ARM), true)
export AFL_CC := $(TARGET_CC)
# expoet AFL_CXX := $(TARGET_CXX)
export AFL_AS := $(TARGET_TOOLS_PREFIX)as
LOCAL_CLANG := false
LOCAL_CC := afl-gcc
# LOCAL_CXX := afl-g++
include $(BUILD_EXECUTABLE)
endif

# test afl-gcc/afl-g++ on host
# to build: TEST_GCC_HOST=true mm -B
ifeq ($(TEST_GCC_HOST), true)
export AFL_CC=$(HOST_CC)
# export AFL_CXX=$(HOST_CXX)
LOCAL_MULTILIB := 32
export AFL_AS=$(HOST_TOOLCHAIN_PREFIX)as
LOCAL_CLANG := false
LOCAL_CC := afl-gcc
# LOCAL_CXX := afl-g++
include $(BUILD_HOST_EXECUTABLE)
endif

# test afl-clang/afl-clang++ on ARM/Android
# to build: TEST_CLANG_ARM=true mm -B
ifeq ($(TEST_CLANG_ARM), true)
export AFL_CC=$(CLANG)
# export AFL_CXX=$(CLANG_CXX)
export AFL_AS=$(TARGET_TOOLS_PREFIX)as
LOCAL_CLANG := true
LOCAL_CC := afl-clang
# LOCAL_CC := afl-clang++
include $(BUILD_EXECUTABLE)
endif

# test afl-clang/afl-clang++ on host
# to build: TEST_CLANG_HOST=true mm -B
ifeq ($(TEST_CLANG_HOST), true)
export AFL_CC=$(CLANG)
# export AFL_CXX=$(CLANG_CXX)
export AFL_AS=$(HOST_TOOLCHAIN_PREFIX)as
LOCAL_CLANG := true
LOCAL_CC := afl-clang
# LOCAL_CXX := afl-clang++
include $(BUILD_HOST_EXECUTABLE)
endif

# test afl-clang-fast/afl-clang-fast++ on ARM/Android
# to build: TEST_CLANG_FAST_ARM=true mm -B
ifeq ($(TEST_CLANG_FAST_ARM), true)
export AFL_CC=/usr/bin/clang-3.8
# export AFL_CXX=/usr/bin/clang++-3.8
LOCAL_CLANG := true
LOCAL_CC := afl-clang-fast
# LOCAL_CXX := afl-clang-fast++
LOCAL_LDFLAGS := $(HOST_OUT)/afl/afl-llvm-rt.o
include $(BUILD_EXECUTABLE)
endif

# test afl-clang-fast/afl-clang-fast++ on aarch64/Android
# to build: TEST_CLANG_FAST_AARCH64=true mm -B
ifeq ($(TEST_CLANG_FAST_AARCH64), true)
export AFL_CC=/usr/bin/clang-3.8
# export AFL_CXX=/usr/bin/clang++-3.8
LOCAL_MULTILIB := 64
LOCAL_CLANG := true
LOCAL_CC := afl-clang-fast
# LOCAL_CXX := afl-clang-fast++
LOCAL_LDFLAGS := $(HOST_OUT)/afl/afl-llvm-rt-64.o
include $(BUILD_EXECUTABLE)
endif

# test afl-clang-fast/afl-clang-fast++ on 64bit host
# to build: TEST_CLANG_FAST_HOST=true mm -B
ifeq ($(TEST_CLANG_FAST_HOST), true)
export AFL_CC=/usr/bin/clang-3.8
# export AFL_CXX=/usr/bin/clang++-3.8
LOCAL_MULTILIB := 64
LOCAL_CLANG := true
LOCAL_CC := afl-clang-fast
# LOCAL_CXX := afl-clang-fast++
LOCAL_LDFLAGS := $(HOST_OUT)/afl/afl-llvm-rt-host-64.o
include $(BUILD_HOST_EXECUTABLE)
endif

# test afl-clang-fast/afl-clang-fast++ on 32bit host
# to build: TEST_CLANG_FAST_HOST_32=true mm -B
ifeq ($(TEST_CLANG_FAST_HOST_32), true)
export AFL_CC=/usr/bin/clang-3.8
# export AFL_CXX=/usr/bin/clang++-3.8
LOCAL_MULTILIB := 32
LOCAL_CLANG := true
LOCAL_CC := afl-clang-fast
# LOCAL_CXX := afl-clang-fast++
LOCAL_LDFLAGS := $(HOST_OUT)/afl/afl-llvm-rt-host-32.o
include $(BUILD_HOST_EXECUTABLE)
endif