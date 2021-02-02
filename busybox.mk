.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

BUSYBOX_SRC = busybox-$(BUSYBOX_VER)
BUSYBOX_TAR = $(BUSYBOX_SRC).tar.bz2
BUSYBOX_SIG = $(BUSYBOX_TAR).sig

BUSYBOX_BINS = $(BUSYBOX_SRC) $(BUSYBOX_TAR) $(BUSYBOX_SIG)

$(BUSYBOX_SIG) $(BUSYBOX_TAR):
	wget -c https://busybox.net/downloads/$@

$(BUSYBOX_SRC): $(BUSYBOX_SIG) $(BUSYBOX_TAR)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(BUSYBOX_SIG)
	tar xf $(BUSYBOX_TAR)

$(BUSYBOX_SRC)/busybox: $(BUSYBOX_SRC)
	cp busybox.config $(BUSYBOX_SRC)/.config
	$(MAKE) -C $(BUSYBOX_SRC) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE)
