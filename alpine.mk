.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

ALPINE_TAR = alpine-minirootfs-$(ALPINE_VER)-armhf.tar.gz
ALPINE_SIG = $(ALPINE_TAR).asc

ALPINE_BINS = $(ALPINE_TAR) $(ALPINE_SIG)

$(ALPINE_TAR) $(ALPINE_SIG):
	wget -c https://dl-cdn.alpinelinux.org/alpine/v$(ALPINE_MAJ)/releases/armhf/$@
