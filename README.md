uwu
===

uwu is a build system and the software for the uwu Bitcoin hardware
wallet.

![uwu](res/uwu.png)

You can donate BTC to support uwu development:
[1Ai71EmjbVBu1QjwKeVEWSG2S1np6VtGEb](bitcoin:1Ai71EmjbVBu1QjwKeVEWSG2S1np6VtGEb)

Talk about uwu on **irc.oftc.net/#uwu**


Table of Contents
=================

   * [uwu](#uwu)
      * [Concept](#concept)
      * [Building uwu](#building-uwu)
         * [Environment setup](#environment-setup)
         * [Compiling](#compiling)
      * [Hardware](#hardware)
         * [Preparation](#preparation)
      * [Using uwu](#using-uwu)
      * [License and copyright](#license-and-copyright)


Concept
-------

uwu is designed as a Bitcoin hardware wallet for people who are
comfortable with the command line. There are no methods to handhold
you with lousy apps and interfaces, instead, everything is available
to the user and you can utilize the full power of the command line
to work with your wallet.

Conceptually, uwu is supposed to run securely on a Raspberry Pi
Zero and provide a serial console by utilizing Linux's USB gadget
subsystem. Upon connecting your uwu device to your computer (or maybe
another device like a mobile phone), uwu will appear as a serial
console you can connect to and issue commands.

uwu's kernel is a minimal build of mainline Linux, with no loadable
module support. Everything that is necessary is compiled in, so
there's no filesystem latency to load modules.

In the userspace, uwu's backend is
[Electrum](https://github.com/spesmilo/electrum). It runs as a daemon
in offline mode and the user can interface with it by using the serial
console. This means a single uwu device can have as many wallets and
as many users(!) as you want.

As further development happens, this concept will evolve, and this
document will contain practical usage examples of uwu. Stay tuned!


Building uwu
------------

This build system's goal is to create a cpio archive that can be
extracted on a microSD card to be used on the Raspberry Pi Zero.
The following sections will explain how to set up the build environment
and will show the necessary configurations.

### Environment setup

First, clone this repository

```
$ git clone https://github.com/parazyd/uwu
```

After we have it, we can start configuring things. The entire
configuration is done in `config.mk`. We simply need to insert a valid
path to a static `qemu-arm` binary that can be used in the ARM chroot,
and a valid (cross)compiler prefix. The Raspberry Pi Zero needs an
`armv6` architecture compiler. The rest of the variables will be
updated as new software versions are released.

Further on, we need to setup `binfmt_misc`. Your system's kernel
config should contain `CONFIG_BINFMT_MISC=m` or `CONFIG_BINFMT_MISC=y`.

On Gentoo/OpenRC:

```
# /etc/init.d/qemu-binfmt start
```

On Devuan/Debian it should be automagic.

If all went well, we're done with our build environment and we can
start compiling uwu!


### Compiling

To compile uwu and get the resulting cpio archive, we can issue

```
$ make -j$(nproc)
$ sudo make -j$(nproc) image
```

This process can take 20 minutes of crunching, depending on your
hardware. When this is issued, the build system will start downloading
the necessary source code and binaries. It will be compiling the Linux
kernel, and setting up and configuring an Alpine Linux chroot. Once
done, the chroot will be packed and compressed into a cpio archive
which can then be extracted on a microSD card we can use with our
Raspberry Pi Zero.


Hardware
--------

* [Raspberry Pi Zero](https://www.raspberrypi.org/products/raspberry-pi-zero/)
* Class 10 microSD card (128M or more)
* Micro USB cable


### Preparation

After you've built the image, you should copy it to your microSD card.
Create a VFAT partition on your microSD card and format it:

```
# parted /dev/mmcblk0 --script -- mklabel msdos 
# parted /dev/mmcblk0 --script -- mkpart primary fat32 2048s 100%
# mkfs.vfat /dev/mmcblk0p1
```

Mount it and extract the cpio archive:

```
# mkdir mnt
# mount /dev/mmcblk0p1 mnt
# cd mnt && cpio -i < ../uwu-*.cpio && cd ..
# umount mnt
```

With this, you've successfully installed uwu and you're ready to boot.


Using uwu
---------

TODO


License and copyright
---------------------

* uwu and its components are licensed with
  [GPL-3](https://www.gnu.org/licenses/gpl-3.0.txt).
* Raspberry Pi firmware is licensed from Broadcom Corporation and
  Raspberry Pi Ltd.
