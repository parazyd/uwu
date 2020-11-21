# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

ALPINE_TAR = alpine-minirootfs-$(ALPINE_VER)-armhf.tar.gz
ALPINE_SIG = alpine-minirootfs-$(ALPINE_VER)-armhf.tar.gz.asc
ALPINE_SHA = alpine-minirootfs-$(ALPINE_VER)-armhf.tar.gz.sha256

ALPINE_BINS = $(ALPINE_TAR) $(ALPINE_SIG) $(ALPINE_SHA)

$(ALPINE_TAR):
	wget -c https://nl.alpinelinux.org/alpine/v$(ALPINE_MAJ)/releases/armhf/$(ALPINE_TAR)

$(ALPINE_SIG):
	wget -c https://nl.alpinelinux.org/alpine/v$(ALPINE_MAJ)/releases/armhf/$(ALPINE_SIG)

$(ALPINE_SHA):
	wget -c https://nl.alpinelinux.org/alpine/v$(ALPINE_MAJ)/releases/armhf/$(ALPINE_SHA)

alpinechroot: $(ALPINE_BINS)
	sha256sum -c $(ALPINE_SHA)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(ALPINE_SIG)
	mkdir -p $@
	( cd $@ && sudo tar xf ../$(ALPINE_TAR) )
	sudo chown $(USER):$(USER) $@
