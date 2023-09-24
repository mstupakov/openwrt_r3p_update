#!/bin/bash

fw_orig=$1
extracted=_"$fw_orig".extracted
kernel1=kernel.bin

binwalk -e "$fw_orig"
dd if=$fw_orig of=$kernel1 bs=$((0x400000)) count=1

image=$(mktemp openwrt.bin.XXXXXX)

rootfs0="$extracted/"$(ls $extracted | grep ubi)
dd if=/dev/zero  of="$image" bs=4M count=2             > /dev/null 2>&1
dd if="$kernel1" of="$image" bs=4M seek=0 conv=notrunc > /dev/null 2>&1
dd if="$kernel1" of="$image" bs=4M seek=1 conv=notrunc > /dev/null 2>&1
dd if="$rootfs0" of="$image" bs=4M seek=2              > /dev/null 2>&1
mv "$image" "pboot_openwrt.bin"
