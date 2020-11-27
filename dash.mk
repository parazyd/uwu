# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

DASH_TAR = $(DASH_SRC).tar.gz
DASH_SHA = $(DASH_TAR).sha256

DASH_BINS = \
	$(DASH_SRC) $(DASH_TAR) $(DASH_SHA) \
	$(DASH_SRC)/src/dash

$(DASH_TAR):
	wget -c https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/$(DASH_TAR)

$(DASH_SHA):
	echo "$(DASH_SUM)  $(DASH_TAR)" > $@

$(DASH_SRC): $(DASH_TAR) $(DASH_SHA)
	sha256sum -c $(DASH_SHA)
	tar xf $(DASH_TAR)

$(DASH_SRC)/src/dash: $(DASH_SRC)
	cd $(DASH_SRC) && ./autogen.sh
	cd $(DASH_SRC) && \
		CC="$(CROSS_COMPILE)gcc" \
		CFLAGS="-Os" \
		./configure \
			--host=$(DASH_HOST_PREFIX) \
			--enable-static \
			--enable-glob
	$(MAKE) -C $(DASH_SRC)
	$(CROSS_COMPILE)strip $@
