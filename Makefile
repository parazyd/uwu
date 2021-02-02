.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

include config.mk

BINS = qemu-wrapper install.sh
BOOT_BINS = \
	rpi-boot/upstream/kernel.img \
	rpi-boot/upstream/bcm2835-rpi-zero.dtb \
	rpi-boot/upstream/initramfs.cpio

INIT_BINS = initramfs/bin

all: $(BINS) $(BOOT_BINS)

include alpine.mk
include chroot.mk
include busybox.mk
include kernel.mk

clean:
	rm -rf $(BINS) $(BOOT_BINS) $(INIT_BINS) filesystem.squashfs \
		uwu-$(VERSION).img qemu-wrapper.c

distclean: clean
	rm -rf $(ALPINE_BINS) $(BUSYBOX_BINS) $(CHROOT_BINS) $(KERNEL_BINS)

qemu-wrapper.c: qemu-wrapper.c.in
	sed -e 's,@QEMU_ARM@,$(QEMU_ARM),g' < $@.in > $@

qemu-wrapper: qemu-wrapper.c
	$(CC) -static $@.c -O3 -s -o $@

install.sh: install.sh.in
	sed \
		-e 's,@USERCREDENTIALS@,$(USERCREDENTIALS),g' \
		-e 's,@ROOTCREDENTIALS@,$(ROOTCREDENTIALS),g' \
		< $@.in > $@

initramfs/bin/busybox: $(BUSYBOX_SRC)/busybox
	mkdir -p initramfs/bin
	cp $(BUSYBOX_SRC)/busybox $@

filesystem.squashfs: chroot/usr/bin/electrum
	mksquashfs chroot $@ -comp xz -noappend

rpi-boot/upstream/initramfs.cpio: initramfs/bin/busybox initramfs/init
	( cd initramfs && find -print0 | cpio --null -oV --format=newc > ../$@ )

rpi-boot/upstream/kernel.img: $(KERNEL_SRC)/arch/arm/boot/zImage
	cp $(KERNEL_SRC)/arch/arm/boot/zImage $@

rpi-boot/upstream/bcm2835-rpi-zero.dtb: $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb
	cp $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

.PHONY: all clean distclean
