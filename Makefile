# A basic build file to create executable targets for the various levels
# of optimization for each supported language.

## GLOBAL SETTINGS ##
S            = @

CONFIG       = debug
PLATFORM     = macosx
ARCH         = x86_64
MODULE_NAME  = tool
MACH_O_TYPE  = mh_execute

ROOT_DIR            = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILD_DIR           = $(ROOT_DIR)/build
SRC_DIR             = $(ROOT_DIR)/src

TOOLCHAIN           = Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/$(PLATFORM)
TOOLCHAIN_PATH      = $(shell xcode-select --print-path)/$(TOOLCHAIN)
SDK_PATH            = $(shell xcrun --show-sdk-path -sdk $(PLATFORM))

CLANG				= $(shell which clang)
SWIFT               = $(shell xcrun -f swiftc)
LD                  = $(shell xcrun -f ld)


## LANGUAGE FLAGS ##

ANSIC_SOURCE       = $(SRC_DIR)/main.c
ANSIC_LDFLAGS      = -arch $(ARCH) -std=gnu99 -stdlib=libstdc++

SWIFT_SOURCE       = $(wildcard $(SRC_DIR)/*.swift) $(wildcard $(SRC_DIR)/tests/*.swift)
SWIFT_LDFLAGS      = -sdk $(SDK_PATH) -whole-module-optimization

.PHONY: test
test: clean ansic swift
	$(S)echo
	$(S) $(BUILD_DIR)/ansic_O0

	$(S)echo
	$(S) $(BUILD_DIR)/ansic_Os

	$(S)echo
	$(S) $(BUILD_DIR)/ansic_Ofast

	$(S)echo
	$(S) $(BUILD_DIR)/swift_Onone

	$(S)echo
	$(S) $(BUILD_DIR)/swift_O

	$(S)echo
	$(S) $(BUILD_DIR)/swift_Ounchecked

.PHONY: clean
clean:
	$(S)rm -rf build

.PHONY: build_dir
build_dir:
	$(S)mkdir -p $(BUILD_DIR)


## ANSIC LANGUAGE SETTINGS ##

.PHONY: ansic
ansic: build_dir ansic_O0 ansic_Os ansic_Ofast

ansic_%: build_dir
	$(S)echo "> Building ANSI C -$*"
	$(S)$(CLANG) -DOPT_$*=1 -$* $(ANSIC_LDFLAGS) -o $(BUILD_DIR)/ansic_$* $(ANSIC_SOURCE)


## SWIFT LANGUAGE SETTINGS ##

.PHONY: swift
swift: build_dir swift_Onone swift_O swift_Ounchecked

swift_%:
	$(S)echo "> Building Swift -$*"
	$(S)$(SWIFT) -D OPT_$* -$* $(SWIFT_LDFLAGS) -o $(BUILD_DIR)/swift_$* $(SWIFT_SOURCE)
