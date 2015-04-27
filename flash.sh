#!/bin/bash
export PATH=$PATH:.

# force board into fastboot mode
imx_usb u-boot.bin

echo fastboot boot format-${1-emmc}.img
fastboot boot format-${1-emmc}.img
# sleep here to make sure the emmc formatting completed, as imx_usb
# fails and exits after a couple of seconds if it can't locate the
# proper USB device
sleep 30
imx_usb u-boot.bin

fastboot update update.zip
