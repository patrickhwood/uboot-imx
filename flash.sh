#!/bin/bash
export PATH=$PATH:.

# force board into fastboot mode
if [ "$OS" = Windows_NT ]
then
	# for Windows, run sb_loader
	sb_loader.exe -f u-boot-fb.bin
else
	imx_usb u-boot-fb.bin
fi

echo fastboot boot format-${1-emmc}.img
fastboot boot format-${1-emmc}.img
sleep 30

# note: only needed if SD boot is enabled in bootcfg
# (remove for production boards)
if [ -z "$1" -o "$1" = emmc ]
then
	if [ "$OS" = Windows_NT ]
	then
		sb_loader.exe -f u-boot-fb.bin
	else
		imx_usb u-boot-fb.bin
	fi
fi

fastboot update update.zip
