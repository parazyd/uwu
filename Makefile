.POSIX:

# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

include config.mk

BINS = qemu-wrapper install-chroot.sh
BOOT_BINS = rpi-boot/zImage rpi-boot/bcm2835-rpi-zero.dtb

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

rpi-boot/zImage: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/zImage $@

rpi-boot/bcm2835-rpi-zero.dtb: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

$(IMAGE): $(BINS) $(BOOT_BINS) $(ALPINE_BINS) alpinechroot
	cp -f $(BINS) ./alpinechroot
	sudo cp -f $(QEMU_ARM) ./alpinechroot/$(QEMU_ARM)
	chmod 755 ./alpinechroot/qemu-wrapper
	chmod 755 ./alpinechroot/install-chroot.sh
	sudo mount --rbind /dev ./alpinechroot/dev
	sudo mount --rbind /sys ./alpinechroot/sys
	sudo mount -t proc /proc ./alpinechroot/proc
	sudo chroot ./alpinechroot /install-chroot.sh
	sudo umount -R ./alpinechroot/dev ./alpinechroot/sys ./alpinechroot/proc
	sudo rm -f ./alpinechroot/install-chroot.sh \
		./alpinechroot/qemu-wrapper ./alpinechroot/$(QEMU_ARM)
	sudo mkdir -p ./alpinechroot/boot
	sudo cp -f rpi-boot/* ./alpinechroot/boot
	( cd alpinechroot && sudo find . | \
		sudo cpio -oa --reproducible --format=newc | xz -v - > ../$@)

clean:
	rm -rf $(BINS) $(BOOT_BINS) qemu-wrapper.c

distclean: clean
	rm -rf $(KERNEL_BINS) $(ALPINE_BINS) $(IMAGE)

mrproper: distclean
	sudo rm -rf alpinechroot

.PHONY: all clean image
