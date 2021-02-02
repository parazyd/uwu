#!/bin/sh
set -e

[ -n "$2" ] || exit 1

case "$1" in
mount)
	mkdir -p "$2/dev" "$2/proc" "$2/sys"
	mount --types proc /proc "$2/proc"
	mount --rbind /sys "$2/sys"
	mount --make-rslave "$2/sys"
	mount --rbind /dev "$2/dev"
	mount --make-rslave "$2/dev"
	exit 0
	;;
umount)
	umount -R "$2/dev" "$2/proc" "$2/sys"
	exit 0
	;;
esac

exit 1
