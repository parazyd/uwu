.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

VERSION = 0.1
IMAGE = uwu-$(VERSION).cpio

# System path to qemu-arm binary used to emulate Arm ELFs in the chroot
QEMU_ARM = /usr/bin/qemu-arm

# System credentials
ROOTCREDENTIALS = root:toor

# Crosscompiler prefix for compiling Linux and Busybox
CROSS_COMPILE = armv6j-unknown-linux-musleabihf-

# Linux Kernel
KERNEL_VER = 5.10.12
KERNEL_SRC = linux-$(KERNEL_VER)
KERNEL_TAR = $(KERNEL_SRC).tar
KERNEL_SIG = $(KERNEL_TAR).sign
KERNEL_BINS = $(KERNEL_SRC) $(KERNEL_TAR) $(KERNEL_SIG)

# Alpine Linux
ALPINE_MAJ = 3.13
ALPINE_VER = $(ALPINE_MAJ).1
ALPINE_TAR = alpine-minirootfs-$(ALPINE_VER)-armhf.tar.gz
ALPINE_SIG = $(ALPINE_TAR).asc
ALPINE_BINS = $(ALPINE_TAR) $(ALPINE_SIG)

# Busybox
BUSYBOX_VER = 1.33.0
BUSYBOX_SRC = busybox-$(BUSYBOX_VER)
BUSYBOX_TAR = $(BUSYBOX_SRC).tar.bz2
BUSYBOX_SIG = $(BUSYBOX_TAR).sig
BUSYBOX_BINS = $(BUSYBOX_SRC) $(BUSYBOX_TAR) $(BUSYBOX_SIG)

# Electrum
ELECTRUM_VER = 4.0.9
ELECTRUM_SRC = Electrum-$(ELECTRUM_VER)
ELECTRUM_TAR = $(ELECTRUM_SRC).tar.gz
ELECTRUM_SIG = $(ELECTRUM_TAR).asc
ELECTRUM_BINS = $(ELECTRUM_SRC) $(ELECTRUM_TAR) $(ELECTRUM_SIG)
