.POSIX:

# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

include config.mk

BINS = qemu-wrapper install-chroot.sh
BOOT_BINS = rpi-boot/Image rpi-boot/bcm2835-rpi-zero.dtb

all: $(BINS) $(BOOT_BINS)

image: all $(IMAGE)

include kernel.mk
include alpine.mk

qemu-wrapper.c:
	sed -e 's,@QEMU_ARM@,$(QEMU_ARM),g' < $@.in > $@

qemu-wrapper: qemu-wrapper.c
	gcc -static $@.c -O3 -s -o $@

install-chroot.sh: install-chroot.sh.in
	sed -e 's,@USERCREDENTIALS@,$(USERCREDENTIALS),g' \
		-e 's,@ROOTCREDENTIALS@,$(ROOTCREDENTIALS),g' \
		< $@.in > $@

rpi-boot/Image: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/Image $@

rpi-boot/bcm2835-rpi-zero.dtb: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

$(IMAGE): $(BINS) $(BOOT_BINS) $(ALPINE_BINS) alpinechroot
	cp -f $(BINS) ./alpinechroot
	sudo cp -f $(QEMU_ARM) ./alpinechroot/$(QEMU_ARM)
	chmod 755 ./alpinechroot/qemu-wrapper
	chmod 755 ./alpinechroot/install-chroot.sh
	sudo mount --types proc /proc ./alpinechroot/proc
	sudo mount --rbind /sys ./alpinechroot/sys
	sudo mount --make-rslave ./alpinechroot/sys
	sudo mount --rbind /dev ./alpinechroot/dev
	sudo mount --make-rslave ./alpinechroot/dev
	sudo chroot ./alpinechroot /install-chroot.sh
	sudo umount -R ./alpinechroot/dev ./alpinechroot/sys ./alpinechroot/proc
	sudo rm -f ./alpinechroot/install-chroot.sh \
		./alpinechroot/qemu-wrapper ./alpinechroot/$(QEMU_ARM)
	sudo mkdir -p ./alpinechroot/boot
	sudo cp -f rpi-boot/* ./alpinechroot/boot
	( cd alpinechroot && sudo find . | \
		sudo cpio -oa --reproducible --format=newc > ../$@)

clean:
	sudo rm -rf $(BINS) $(BOOT_BINS) qemu-wrapper.c $(IMAGE) alpinechroot

distclean: clean
	rm -rf $(KERNEL_BINS) $(ALPINE_BINS)

.PHONY: all image clean distclean
