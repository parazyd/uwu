.POSIX:

# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

include config.mk

BINS = qemu-wrapper install.sh
BOOT_BINS = rpi-boot/upstream/kernel.img rpi-boot/upstream/bcm2835-rpi-zero.dtb
INIT_BINS = initramfs/bin/sh initramfs/bin/basename initramfs/bin/mount

all: $(BINS) $(BOOT_BINS) $(INIT_BINS)

image: all $(IMAGE)

include alpine.mk
include dash.mk
include kernel.mk
include sbase.mk
include ubase.mk

qemu-wrapper.c:
	sed -e 's,@QEMU_ARM@,$(QEMU_ARM),g' < $@.in > $@

qemu-wrapper: qemu-wrapper.c
	gcc -static $@.c -O3 -s -o $@

install.sh: install.sh.in
	sed -e 's,@USERCREDENTIALS@,$(USERCREDENTIALS),g' \
		-e 's,@ROOTCREDENTIALS@,$(ROOTCREDENTIALS),g' \
		< $@.in > $@

rpi-boot/upstream/kernel.img: $(KERNEL_BINS)
	cp -f $(KERNEL_SRC)/arch/arm/boot/zImage $@

rpi-boot/upstream/bcm2835-rpi-zero.dtb: $(KERNEL_BINS)
	cp -f $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb $@

initramfs/bin/sh: $(DASH_BINS)
	cp -f $(DASH_SRC)/src/dash $@

initramfs/bin/basename: $(SBASE_BINS)
	cp -f $(SBASE_B) initramfs/bin

initramfs/bin/mount: $(UBASE_BINS)
	cp -f $(UBASE_B) initramfs/bin

$(IMAGE): $(BINS) $(BOOT_BINS) $(ALPINE_BINS) $(INIT_BINS) ch
	cp -f $(BINS) ./ch
	sudo cp -f $(QEMU_ARM) ./ch/$(QEMU_ARM)
	chmod 755 ./ch/qemu-wrapper
	chmod 755 ./ch/install.sh
	sudo mount --types proc /proc ./ch/proc
	sudo mount --rbind /sys ./ch/sys  || ( sudo umount -R ./ch/proc ; exit 1 )
	sudo mount --make-rslave ./ch/sys || ( sudo umount -R ./ch/proc ./ch/sys ; exit 1 )
	sudo mount --rbind /dev ./ch/dev  || ( sudo umount -R ./ch/proc ./ch/sys ; exit 1 )
	sudo mount --make-rslave ./ch/dev || ( sudo umount -R ./ch/proc ./ch/sys ./ch/dev ; exit 1 )
	sudo chroot ./ch /install.sh      || ( sudo umount -R ./ch/proc ./ch/sys ./ch/dev ; exit 1 )
	sudo umount -R ./ch/proc ./ch/sys ./ch/dev
	sudo rm -f ./ch/install.sh ./ch/qemu-wrapper ./ch/$(QEMU_ARM)
	sudo mkdir -p ./ch/boot
	sudo cp -r rpi-boot/* ./ch/boot
ifneq ($(DEBUG),)
	sudo sed -e 's/BOOT_UART=0/BOOT_UART=1/' -i ./ch/boot/bootcode.bin
	sudo sed -e 's/enable_uart=0/enable_uart=1/' -i ./ch/boot/config.txt
endif
	( cd ch && sudo find . | sudo cpio -oa --reproducible --format=newc > ../$@)

clean:
	sudo rm -rf $(BINS) $(BOOT_BINS) $(INIT_BINS) qemu-wrapper.c $(IMAGE) ch

distclean: clean
	rm -rf $(KERNEL_BINS) $(ALPINE_BINS) $(DASH_BINS) $(SBASE_BINS) $(UBASE_BINS)

.PHONY: all image clean distclean
