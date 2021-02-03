.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

$(ELECTRUM_TAR) $(ELECTRUM_SIG):
	wget -c https://download.electrum.org/$(ELECTRUM_VER)/$@

$(ELECTRUM_SRC): $(ELECTRUM_TAR) $(ELECTRUM_SIG)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(ELECTRUM_SIG)
	tar xf $(ELECTRUM_TAR)
