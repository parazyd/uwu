# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

UBASE_B = \
	$(UBASE_SRC)/mount \
	$(UBASE_SRC)/umount \
	$(UBASE_SRC)/switch_root

UBASE_BINS = $(UBASE_SRC) $(UBASE_B)

$(UBASE_SRC):
	git clone https://git.suckless.org/ubase

$(UBASE_B): $(UBASE_SRC)
	$(MAKE) -C $(UBASE_SRC) \
		CC=$(CROSS_COMPILE)gcc \
		AR=$(CROSS_COMPILE)ar \
		RANLIB=$(CROSS_COMPILE)ranlib \
		CFLAGS="-Os -static -std=c99 -Wall -Wextra" \
		LDFLAGS="-s -static" \
		-e $(shell basename $@)
