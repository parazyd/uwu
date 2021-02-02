.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

VERSION = 0.1
IMAGE = uwu-$(VERSION).cpio

# Uncomment to enable certain things useful for debugging
DEBUG = 1

# System path to qemu-arm binary used to emulate Arm ELFs in the chroot
QEMU_ARM = /usr/bin/qemu-arm

# System credentials
USERCREDENTIALS = uwu:uwu
ROOTCREDENTIALS = root:toor

# Crosscompiler prefix for compiling Linux and Busybox
CROSS_COMPILE = armv6j-unknown-linux-musleabihf-

# Linux Kernel version
KERNEL_VER = 5.10.12

# Alpine Linux version
ALPINE_MAJ = 3.13
ALPINE_VER = $(ALPINE_MAJ).1

# Busybox version
BUSYBOX_VER = 1.33.0
