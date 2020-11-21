# Copyright (c) 2020 Ivan J. <parazyd@dyne.org>
# This file is part of uwu.
# See LICENSE file for copyright and license details.

KERNEL_TAR = $(KERNEL_SRC).tar
KERNEL_SIG = $(KERNEL_SRC).tar.sign
KERNEL_CFG = $(KERNEL_SRC)/config

KERNEL_BINS = \
	$(KERNEL_SRC) $(KERNEL_TAR) $(KERNEL_SIG) $(KERNEL_CFG) \
	$(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb \
	$(KERNEL_SRC)/arch/arm/boot/Image


$(KERNEL_TAR):
	wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/$@.xz
	xz -dv $@.xz

$(KERNEL_SIG):
	wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/$@

$(KERNEL_SRC): $(KERNEL_TAR) $(KERNEL_SIG)
	gpg --no-default-keyring --keyring=./verification_keyring.gpg \
		--verify $(KERNEL_SIG)
	tar xf $(KERNEL_SRC).tar

$(KERNEL_CFG): $(KERNEL_SRC)
	cp -f uwu_pizero_defconfig $(KERNEL_SRC)/arch/arm/configs/
	$(MAKE) -C $(KERNEL_SRC) ARCH=arm uwu_pizero_defconfig
	# Hacky rule. I don't know how target/depend doesn't work with dotfiles.
	cp -f $(KERNEL_SRC)/.config $@

$(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb: $(KERNEL_CFG)
	$(MAKE) -C $(KERNEL_SRC) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) bcm2835-rpi-zero.dtb

$(KERNEL_SRC)/arch/arm/boot/Image: $(KERNEL_SRC)/arch/arm/boot/dts/bcm2835-rpi-zero.dtb
	$(MAKE) -C $(KERNEL_SRC) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) Image
