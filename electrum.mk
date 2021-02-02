.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

ELECTRUM_SRC = Electrum-$(ELECTRUM_VER)
ELECTRUM_TAR = $(ELECTRUM_SRC).tar.gz
ELECTRUM_SIG = $(ELECTRUM_TAR).asc

ELECTRUM_BINS = $(ELECTRUM_SRC) $(ELECTRUM_TAR) $(ELECTRUM_SIG)

$(ELECTRUM_TAR) $(ELECTRUM_SIG):
	wget -c https://download.electrum.org/$(ELECTRUM_VER)/$@

$(ELECTRUM_SRC): $(ELECTRUM_TAR) $(ELECTRUM_SIG)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(ELECTRUM_SIG)
	tar xf $(ELECTRUM_TAR)
