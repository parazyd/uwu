# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

SBASE_B = \
	$(SBASE_SRC)/basename \
	$(SBASE_SRC)/cat \
	$(SBASE_SRC)/cp \
	$(SBASE_SRC)/cut \
	$(SBASE_SRC)/dirname \
	$(SBASE_SRC)/env \
	$(SBASE_SRC)/grep \
	$(SBASE_SRC)/ls \
	$(SBASE_SRC)/mkdir \
	$(SBASE_SRC)/mktemp \
	$(SBASE_SRC)/printf \
	$(SBASE_SRC)/pwd \
	$(SBASE_SRC)/rm \
	$(SBASE_SRC)/rmdir \
	$(SBASE_SRC)/sed \
	$(SBASE_SRC)/sleep \
	$(SBASE_SRC)/sync \
	$(SBASE_SRC)/touch \
	$(SBASE_SRC)/true \
	$(SBASE_SRC)/xargs \
	$(SBASE_SRC)/yes \

SBASE_BINS = $(SBASE_SRC) $(SBASE_B)

$(SBASE_SRC):
	git clone https://git.suckless.org/sbase

$(SBASE_B): $(SBASE_SRC)
	$(MAKE) -C $(SBASE_SRC) \
		CC=$(CROSS_COMPILE)gcc \
		AR=$(CROSS_COMPILE)ar \
		RANLIB=$(CROSS_COMPILE)ranlib \
		CFLAGS="-Os -static -std=c99 -Wall -pedantic" \
		LDFLAGS="-s -static" \
		-e $(shell basename $@)
