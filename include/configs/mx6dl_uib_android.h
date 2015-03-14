/*
 * Copyright (C) 2010-2013 Freescale Semiconductor, Inc.
 *
 * Configuration settings for the MX6DL UIB EFI board.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#ifndef MX6DL_UIB_ANDROID_H
#define MX6DL_UIB_ANDROID_H

#include <asm/arch/mx6.h>
#include "mx6dl_sabresd.h"

#define CONFIG_MX6DL_UIB
#define CONFIG_MX6DL_UIB_REV_1

#undef PHYS_SDRAM_1_SIZE
#define PHYS_SDRAM_1_SIZE	(2u * 1024 * 1024 * 1024)

#undef CONFIG_ENV_IS_IN_MMC
#define CONFIG_ENV_IS_NOWHERE

#define CONFIG_VIDEO_BMP_GZIP
#define CONFIG_SYS_VIDEO_LOGO_MAX_SIZE 640000

#undef CONFIG_MXC_FEC
#undef CONFIG_CMD_NET
#undef CONFIG_NET_MULTI
#undef CONFIG_IPADDR

#define CONFIG_SYS_HUSH_PARSER          1
#define CONFIG_SYS_PROMPT_HUSH_PS2      "> "

#define CONFIG_I2C_MXC                  1
#ifdef CONFIG_I2C_MXC
	#undef CONFIG_CMD_I2C
	#undef CONFIG_SYS_I2C_PORT
	#undef CONFIG_SYS_I2C_SLAVE
	#undef CONFIG_SYS_I2C_SPEED
	#undef CONFIG_HARD_I2C
	#define CONFIG_CMD_I2C
	#define CONFIG_SYS_I2C_PORT         I2C2_BASE_ADDR
	#define CONFIG_SYS_I2C_SLAVE        0x0
	#define CONFIG_HARD_I2C             1
	#define CONFIG_SYS_I2C_SPEED        100000
#else
	#undef CONFIG_CMD_I2C
	#undef CONFIG_SYS_I2C_PORT
	#undef CONFIG_SYS_I2C_SLAVE
	#undef CONFIG_SYS_I2C_SPEED
	#undef CONFIG_HARD_I2C
#endif

#define CONFIG_USB_DEVICE
#ifdef CONFIG_USB_DEVICE
	#define CONFIG_IMX_UDC             1
	#define CONFIG_FASTBOOT		       1
	#define CONFIG_FASTBOOT_STORAGE_EMMC_SATA
	#define CONFIG_FASTBOOT_VENDOR_ID      0x18d1
	#define CONFIG_FASTBOOT_PRODUCT_ID     0x0d02
	#define CONFIG_FASTBOOT_BCD_DEVICE     0x311
	#define CONFIG_FASTBOOT_MANUFACTURER_STR  "EFI"
	#define CONFIG_FASTBOOT_PRODUCT_NAME_STR "UIB"
	#define CONFIG_FASTBOOT_INTERFACE_STR	 "Android fastboot"
	#define CONFIG_FASTBOOT_CONFIGURATION_STR  "Android fastboot"
	#define CONFIG_FASTBOOT_SERIAL_NUM	"12345"
	#define CONFIG_FASTBOOT_SATA_NO		 0

/*  For system.img growing up more than 256MB, more buffer needs
*   to receive the system.img*/
	#define CONFIG_FASTBOOT_TRANSFER_BUF	0x2c000000
	#define CONFIG_FASTBOOT_TRANSFER_BUF_SIZE 0x20000000 /* 512M byte */
#endif

#define CONFIG_CMD_BOOTI
#define CONFIG_ANDROID_RECOVERY
/* which mmc bus is your main storage ? */
#define CONFIG_ANDROID_MAIN_MMC_BUS 1

#undef CONFIG_SYS_FSL_USDHC_NUM
#define CONFIG_SYS_FSL_USDHC_NUM 3

#undef CONFIG_DYNAMIC_MMC_DEVNO
#undef CONFIG_SYS_MMC_ENV_DEV
#define CONFIG_SYS_MMC_ENV_DEV 1

#undef CONFIG_MMC_8BIT_PORTS
#define CONFIG_MMC_8BIT_PORTS 0x1

#define CONFIG_ANDROID_BOOT_PARTITION_MMC 1
#define CONFIG_ANDROID_SYSTEM_PARTITION_MMC 5
#define CONFIG_ANDROID_RECOVERY_PARTITION_MMC 2
#define CONFIG_ANDROID_CACHE_PARTITION_MMC 6

/* disable NAND FLASH on UIB */

#undef CONFIG_NAND_GPMI

#ifdef CONFIG_NAND_GPMI
	#define CONFIG_CMD_NAND
	#define CONFIG_GPMI_NFC_SWAP_BLOCK_MARK
	#define CONFIG_GPMI_NFC_V2

	#define CONFIG_GPMI_REG_BASE	GPMI_BASE_ADDR
	#define CONFIG_BCH_REG_BASE	BCH_BASE_ADDR

	#define CONFIG_SYS_NAND_MAX_CHIPS		8
	#define CONFIG_SYS_NAND_BASE		0x40000000
	#define CONFIG_SYS_MAX_NAND_DEVICE	1

	/* NAND is the only module that uses APBH-DMA */
	#define CONFIG_APBH_DMA
	#define CONFIG_APBH_DMA_V2
	#define CONFIG_MXS_DMA_REG_BASE	ABPHDMA_BASE_ADDR

	/* NAND recovery is TBD */
	#define CONFIG_ANDROID_RECOVERY_BOOTARGS_NAND NULL
	#define CONFIG_ANDROID_RECOVERY_BOOTCMD_NAND ""
#endif

#define CONFIG_ANDROID_RECOVERY_BOOTARGS_MMC NULL
#define CONFIG_ANDROID_RECOVERY_BOOTCMD_MMC  \
	"booti mmc0 recovery"
#define CONFIG_ANDROID_RECOVERY_BOOTCMD_SD  \
	"booti mmc1 recovery"
#define CONFIG_ANDROID_RECOVERY_CMD_FILE "/recovery/command"
#define CONFIG_INITRD_TAG

#undef CONFIG_LOADADDR
#undef CONFIG_RD_LOADADDR
#undef CONFIG_EXTRA_ENV_SETTINGS
#undef CONFIG_BOOTDELAY

#define CONFIG_BOOTDELAY 0
#define CONFIG_LOADADDR		0x10800000	/* loadaddr env var */
#define CONFIG_RD_LOADADDR      0x11000000

#define CONFIG_INITRD_TAG
#define	CONFIG_EXTRA_ENV_SETTINGS											\
		"bootcmd=setenv bootargs console=ttymxc0,115200 init=/init mem=256M;"	\
		"booti 10000000\0"													\
		"splashimage=0x30000000\0"

#endif
