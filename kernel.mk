.POSIX:

# Copyright (c) 2020-2021 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

KERNEL_SRC = linux-$(KERNEL_VER)
KERNEL_TAR = $(KERNEL_SRC).tar
KERNEL_SIG = $(KERNEL_TAR).sign

KERNEL_BINS = $(KERNEL_SRC) $(KERNEL_TAR) $(KERNEL_SIG)

$(KERNEL_SIG):
	wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/$@

$(KERNEL_TAR):
	wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/$@.xz
	xz -d $@.xz

$(KERNEL_SRC): $(KERNEL_TAR) $(KERNEL_SIG)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(KERNEL_SIG)
	tar xf $(KERNEL_TAR)

$(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb: $(KERNEL_SRC)
	cp uwu_pizero_defconfig $(KERNEL_SRC)/arch/arm/configs
	$(MAKE) -C $(KERNEL_SRC) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) \
		uwu_pizero_defconfig $(shell basename $@)

$(KERNEL_SRC)/arch/arm/boot/zImage: $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb
	$(MAKE) -C $(KERNEL_SRC) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) \
		$(shell basename $@)
