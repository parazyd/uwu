# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

VERSION = 0.1
IMAGE = uwu-$(VERSION).cpio.gz

# System path to qemu-arm binary used to emulate ARM ELFs in the chroot
QEMU_ARM = /usr/bin/qemu-arm

# Crosscompiler prefix used to compile the Linux kernel
CROSS_COMPILE = armv6j-unknown-linux-musleabihf-

# System credentials
USERCREDENTIALS = uwu:uwu
ROOTCREDENTIALS = root:uwu

# Linux kernel version
KERNEL_SRC = linux-5.8.18

# Alpine Linux version
ALPINE_MAJ = 3.12
ALPINE_VER = 3.12.1
