.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

CHROOT_BINS = chroot

chroot/bin/busybox: $(ALPINE_BINS)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(ALPINE_SIG)
	mkdir -p chroot
	( cd chroot && tar xpf ../$(ALPINE_TAR) --xattrs )

chroot/root/electrum: $(ELECTRUM_BINS) chroot/bin/busybox qemu-wrapper
	./devprocsys.sh mount chroot
	cp install.sh chroot/install.sh
	cp qemu-wrapper chroot
	cp -a $(QEMU_ARM) chroot/usr/bin
	chmod 755 chroot/install.sh chroot/qemu-wrapper
	cp -r $(ELECTRUM_SRC) chroot/root/electrum
	chroot chroot /install.sh || ( ./devprocsys.sh umount chroot ; exit 1 )
	./devprocsys.sh umount chroot
	rm -f chroot/usr/bin/$(QEMU_ARM) chroot/qemu-wrapper chroot/install.sh
