# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

VERSION = 0.1
IMAGE = uwu-$(VERSION).cpio

# Uncomment to enable certain things useful for debugging
DEBUG = 1

# System path to qemu-arm binary used to emulate ARM ELFs in the chroot
QEMU_ARM = /usr/bin/qemu-arm

# Crosscompiler prefix used to compile the Linux kernel
CROSS_COMPILE = armv6j-unknown-linux-musleabihf-

# Host compiler prefix (necessary to crosscompile dash)
DASH_HOST_PREFIX = x86_64-pc-linux-gnu

# System credentials
USERCREDENTIALS = uwu:uwu
ROOTCREDENTIALS = root:uwu

# Linux kernel version
KERNEL_SRC = linux-5.8.18

# Path to a kernel patch to apply in the mainline source tree.
# Supports multiple filenames. Safe to leave unset.
KERNEL_PATCH =

# Alpine Linux version
ALPINE_MAJ = 3.12
ALPINE_VER = 3.12.1

# Dash shell version
DASH_SRC = dash-0.5.11.2
DASH_SUM = 24b0bfea976df722bc360e782b683c0867f0513d2922fa3c002d8d47a20605ee

# ubase
UBASE_SRC = ubase

# sbase
SBASE_SRC = sbase
