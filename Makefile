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

all: $(BINS) $(KERNEL_BINS) $(ALPINE_BINS) $(BUSYBOX_BINS) $(ELECTRUM_BINS) $(BOOT_BINS)

include electrum.mk
include alpine.mk
include busybox.mk
include kernel.mk
include chroot.mk

clean:
	rm -rf $(BINS) $(BOOT_BINS) $(INIT_BINS) rpi-boot/filesystem.squashfs \
		$(IMAGE) qemu-wrapper.c

distclean: clean
	rm -rf $(ALPINE_BINS) $(BUSYBOX_BINS) $(CHROOT_BINS) $(KERNEL_BINS) \
		$(ELECTRUM_BINS)

qemu-wrapper.c: qemu-wrapper.c.in
	sed -e 's,@QEMU_ARM@,$(QEMU_ARM),g' < $@.in > $@

qemu-wrapper: qemu-wrapper.c
	$(CC) -static $@.c -O3 -s -o $@

install.sh: install.sh.in
	sed -e 's,@ROOTCREDENTIALS@,$(ROOTCREDENTIALS),g' < $@.in > $@

initramfs/bin/busybox: $(BUSYBOX_SRC)/busybox
	mkdir -p initramfs/bin
	cp $(BUSYBOX_SRC)/busybox $@

rpi-boot/filesystem.squashfs: chroot/root/electrum
	mksquashfs chroot $@ -comp xz -Xbcj arm -noappend

rpi-boot/upstream/initramfs.cpio: initramfs/bin/busybox initramfs/init
	( cd initramfs && find -print0 | cpio --null -oV --format=newc > ../$@ )

rpi-boot/upstream/kernel.img: $(KERNEL_SRC)/arch/arm/boot/zImage
	cp $(KERNEL_SRC)/arch/arm/boot/zImage $@

rpi-boot/upstream/bcm2835-rpi-zero.dtb: $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb
	cp $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

image: $(IMAGE)

$(IMAGE): rpi-boot/filesystem.squashfs $(BOOT_BINS)
	( cd rpi-boot && find -print0 | cpio --null -oV --format=newc > ../$@)

.PHONY: all clean distclean image
