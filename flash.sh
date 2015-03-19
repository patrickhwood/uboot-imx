#!/bin/bash

# for Windows, run MfgTool instead in background as it won't exit
# MfgTool2.exe -noui -c UIB -l UIB-uboot &

# force board into fastboot mode
imx_usb u-boot.bin

echo fastboot boot format-${1-emmc}.img
fastboot boot format-${1-emmc}.img
sleep 30

# note: only needed if SD boot is enabled in bootcfg
# (remove for production boards)
if [ -z "$1" -o "$1" = emmc ]
then
	imx_usb u-boot.bin
fi

fastboot update update.zip
