uwu
===

uwu is a build system and the software for the uwu Bitcoin hardware
wallet.

Table of Contents
=================

   * [uwu](#uwu)
      * [Concept](#concept)
      * [Building uwu](#building-uwu)
         * [Environment setup](#environment-setup)
         * [Compiling](#compiling)

Concept
-------

TODO


Building uwu
------------

This build system's goal is to create a cpio archive that can be
extracted on a microSD card to be used on the Raspberry Pi Zero.

The following sections will explain how to set up the build environment
and will show the necessary configurations. Personally, I have this set
up on Gentoo, so the steps will mostly reflect Gentoo environments, but
it shouldn't be a problem to adapt for any other Linux distribution.

### Environment setup

First, clone this repository

```
$ git clone https://github.com/parazyd/uwu
```

After we have it, we can start configuring things. The entire
configuration is done in `config.mk`. We simply need to insert a valid
path to a static `qemu-arm` binary that can be used in the ARM chroot,
and a valid (cross)compiler prefix. The Raspberry Pi Zero needs an armv6
architecture compiler. The rest of the variables will be updated as new
software versions are released.

Further on, we need to setup `binfmt_misc`. Your system's kernel config
should contain `CONFIG_BINFMT_MISC=m` or `CONFIG_BINFMT_MISC=y`.

Mount the `binfmt_misc` handler if it's not already:

```
# [ -d /proc/sys/fs/binfmt_misc ] || modprobe binfmt_misc
# [ -f /proc/sys/fs/binfmt_misc/register ] || mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
```

After we have this, we need to register our format with procfs:

```
# echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/qemu-wrapper:' > /proc/sys/fs/binfmt_misc/register
```

Once done, usually you should have an initscript to (re)start the binfmt
service.

On Gentoo/OpenRC:

```
# /etc/init.d/qemu-binfmt start
```

If all went well, we're done with our build environment and we can start
compiling uwu!


### Compiling

To compile uwu and get the resulting cpio archive, we can issue

```
$ make -j$(nproc) image
```

Some commands need sudo permissions, so be sure the user you're building
with is able to use sudo. Do not build as root!

This will probably take a little bit. When this is issued, the build
system will start downloading the necessary source code and binaries. It
will be compiling the Linux kernel, and setting up and configuring an
Alpine Linux chroot. Once done, the chroot will be packed and compressed
into a cpio archive which can then be extracted on a microSD card we can
use with our Raspberry Pi Zero.