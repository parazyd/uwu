.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

CHROOT_BINS = chroot

chroot/bin/busybox: $(ALPINE_TAR) $(ALPINE_SIG)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(ALPINE_SIG)
	mkdir -p chroot
	( cd chroot && tar xf ../$(ALPINE_TAR) )

chroot/usr/bin/electrum: chroot/bin/busybox qemu-wrapper
	./devprocsys.sh mount chroot
	cp install.sh chroot/install.sh
	cp qemu-wrapper chroot
	cp -a $(QEMU_ARM) chroot/usr/bin
	chmod 755 chroot/install.sh chroot/qemu-wrapper
	chroot chroot /install.sh || ( ./devprocsys.sh umount chroot ; exit 1 )
	./devprocsys.sh umount chroot
	rm -f chroot/usr/bin/$(QEMU_ARM) chroot/qemu-wrapper chroot/install.sh
