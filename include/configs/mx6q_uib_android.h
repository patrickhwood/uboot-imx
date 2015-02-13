/*
 * Copyright (C) 2010-2013 Freescale Semiconductor, Inc.
 *
 * Configuration settings for the MX6Q UIB EFI board.
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

#ifndef MX6Q_UIB_ANDROID_H
#define MX6Q_UIB_ANDROID_H

#include <asm/arch/mx6.h>
#include "mx6q_sabresd.h"

#undef PHYS_SDRAM_1_SIZE
#define PHYS_SDRAM_1_SIZE	(2u * 1024 * 1024 * 1024)

#ifdef CONFIG_CMD_I2C
	#undef CONFIG_SYS_I2C_PORT
	#define CONFIG_SYS_I2C_PORT             I2C2_BASE_ADDR
	#undef CONFIG_SYS_I2C_SLAVE
	#define CONFIG_SYS_I2C_SLAVE            0x0
	#undef CONFIG_I2C_MXC
	#define CONFIG_I2C_MXC	1
#endif

#undef CONFIG_MXC_FEC
#undef CONFIG_CMD_NET
#undef CONFIG_NET_MULTI

#define CONFIG_MX6Q_UIB
#define CONFIG_USB_DEVICE
#define CONFIG_IMX_UDC		       1
#define CONFIG_FASTBOOT		       1
#define CONFIG_FASTBOOT_STORAGE_EMMC_SATA
#define CONFIG_FASTBOOT_VENDOR_ID      0x18d1
#define CONFIG_FASTBOOT_PRODUCT_ID     0x0d02
#define CONFIG_FASTBOOT_BCD_DEVICE     0x311
#define CONFIG_FASTBOOT_MANUFACTURER_STR  "EFI"
#define CONFIG_FASTBOOT_PRODUCT_NAME_STR "i.mx6q UIB"
#define CONFIG_FASTBOOT_INTERFACE_STR	 "Android fastboot"
#define CONFIG_FASTBOOT_CONFIGURATION_STR  "Android fastboot"
#define CONFIG_FASTBOOT_SERIAL_NUM	"12345"
#define CONFIG_FASTBOOT_SATA_NO		 0

/*  For system.img growing up more than 256MB, more buffer needs
*   to receive the system.img*/
#define CONFIG_FASTBOOT_TRANSFER_BUF	0x2c000000
#define CONFIG_FASTBOOT_TRANSFER_BUF_SIZE 0x20000000 /* 512M byte */


#define CONFIG_CMD_BOOTI
#define CONFIG_ANDROID_RECOVERY
/* which mmc bus is your main storage ? */
#define CONFIG_ANDROID_MAIN_MMC_BUS 1

#undef CONFIG_SYS_FSL_USDHC_NUM
#define CONFIG_SYS_FSL_USDHC_NUM 2

#undef CONFIG_DYNAMIC_MMC_DEVNO
#undef CONFIG_SYS_MMC_ENV_DEV
#define CONFIG_SYS_MMC_ENV_DEV 1

#undef CONFIG_MMC_8BIT_PORTS
#define CONFIG_MMC_8BIT_PORTS 0x8

#define CONFIG_ANDROID_BOOT_PARTITION_MMC 1
#define CONFIG_ANDROID_SYSTEM_PARTITION_MMC 5
#define CONFIG_ANDROID_RECOVERY_PARTITION_MMC 2
#define CONFIG_ANDROID_CACHE_PARTITION_MMC 6

/* enable NAND FLASH on UIB */
#define CONFIG_CMD_NAND

#define CONFIG_NAND_GPMI
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

#define CONFIG_ANDROID_RECOVERY_BOOTARGS_MMC NULL
#define CONFIG_ANDROID_RECOVERY_BOOTCMD_MMC  \
	"booti mmc3 recovery"
#define CONFIG_ANDROID_RECOVERY_BOOTCMD_SD  \
	"booti mmc1 recovery"
#define CONFIG_ANDROID_RECOVERY_CMD_FILE "/recovery/command"
#define CONFIG_INITRD_TAG

#undef CONFIG_LOADADDR
#undef CONFIG_RD_LOADADDR
#undef CONFIG_EXTRA_ENV_SETTINGS
#undef CONFIG_BOOTDELAY

#define CONFIG_BOOTDELAY 1
#define CONFIG_LOADADDR		0x10800000	/* loadaddr env var */
#define CONFIG_RD_LOADADDR      0x11000000

#define CONFIG_INITRD_TAG
#define	CONFIG_EXTRA_ENV_SETTINGS											\
		"netdev=eth0\0"														\
		"ethprime=FEC0\0"													\
		"uboot=u-boot.bin\0"												\
		"kernel=uImage\0"													\
		"nfsroot=/opt/eldk/arm\0"											\
		"bootargs_base=setenv bootargs console=ttymxc0,115200 init=/init "	\
		"video=mxcfb0:dev=ldb,LDB-WSVGA,bpp=32,if=RGB24 ldb=sin0 "			\
		"video=mxcfb1:off video=mxcfb2:off fbmem=10M "						\
		"fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc0 "		\
		"androidboot.hardware=freescale androidboot.serialno=0a01234567890abc\0" \
		"bootargs_nfs=setenv bootargs ${bootargs} root=/dev/nfs "			\
			"ip=dhcp nfsroot=${serverip}:${nfsroot},v3,tcp\0"				\
		"bootcmd_net=run bootargs_base bootargs_nfs; "						\
			"tftpboot ${loadaddr} ${kernel}; bootm\0"						\
		"bootargs_mmc=setenv bootargs ${bootargs}\0"			\
		"bootcmd_mmc=run bootargs_base bootargs_mmc; "   					\
		"mmc dev 1; "														\
		"booti mmc1\0"														\
		"bootcmd=run bootcmd_mmc\0"                             			\
		"fastboot_dev=mmc1\0"												\
		"splashimage=0x30000000\0"											\
		"splashpos=m,m\0"													\
		"lvds_num=0\0"														\


#endif
