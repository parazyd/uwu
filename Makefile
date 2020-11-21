.POSIX:

# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

include config.mk

BINS = qemu-wrapper install.sh
BOOT_BINS = rpi-boot/Image rpi-boot/bcm2835-rpi-zero.dtb

all: $(BINS) $(BOOT_BINS)

image: all $(IMAGE)

include alpine.mk
include kernel.mk

qemu-wrapper.c:
	sed -e 's,@QEMU_ARM@,$(QEMU_ARM),g' < $@.in > $@

qemu-wrapper: qemu-wrapper.c
	gcc -static $@.c -O3 -s -o $@

install.sh: install.sh.in
	sed -e 's,@USERCREDENTIALS@,$(USERCREDENTIALS),g' \
		-e 's,@ROOTCREDENTIALS@,$(ROOTCREDENTIALS),g' \
		< $@.in > $@

rpi-boot/Image: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/Image $@

rpi-boot/bcm2835-rpi-zero.dtb: $(KERNEL_BINS)
	cp -f linux-5.8.18/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

$(IMAGE): $(BINS) $(BOOT_BINS) $(ALPINE_BINS) ch
	cp -f $(BINS) ./ch
	sudo cp -f $(QEMU_ARM) ./ch/$(QEMU_ARM)
	chmod 755 ./ch/qemu-wrapper
	chmod 755 ./ch/install.sh
	sudo mount --types proc /proc ./ch/proc
	sudo mount --rbind /sys ./ch/sys
	sudo mount --make-rslave ./ch/sys
	sudo mount --rbind /dev ./ch/dev
	sudo mount --make-rslave ./ch/dev
	sudo chroot ./ch /install.sh || sudo umount -R ./ch/dev ./ch/sys ./ch/proc
	sudo umount -R ./ch/dev ./ch/sys ./ch/proc
	sudo rm -f ./ch/install.sh \
		./ch/qemu-wrapper ./ch/$(QEMU_ARM)
	sudo mkdir -p ./ch/boot
	sudo cp -f rpi-boot/* ./ch/boot
	( cd ch && sudo find . | \
		sudo cpio -oa --reproducible --format=newc > ../$@)

clean:
	sudo rm -rf $(BINS) $(BOOT_BINS) qemu-wrapper.c $(IMAGE) ch

distclean: clean
	rm -rf $(KERNEL_BINS) $(ALPINE_BINS)

.PHONY: all image clean distclean
