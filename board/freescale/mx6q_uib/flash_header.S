/*
 * Copyright (C) 2012 Freescale Semiconductor, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <asm/arch/mx6.h>

#ifdef	CONFIG_FLASH_HEADER
#ifndef CONFIG_FLASH_HEADER_OFFSET
# error "Must define the offset of flash header"
#endif

#define CPU_2_BE_32(l) \
       ((((l) & 0x000000FF) << 24) | \
	(((l) & 0x0000FF00) << 8)  | \
	(((l) & 0x00FF0000) >> 8)  | \
	(((l) & 0xFF000000) >> 24))

/* EFI UIB DDR DCD header */
#define EFI_MXC_DCD_ITEM(addr, val) \
        .word CPU_2_BE_32(addr) ;     \
        .word CPU_2_BE_32(val) ;

.section ".text.flasheader", "x"
	b	_start
	.org	CONFIG_FLASH_HEADER_OFFSET

ivt_header:       .word 0x402000D1 /* Tag=0xD1, Len=0x0020, Ver=0x40 */
app_code_jump_v:  .word _start
reserv1:          .word 0x0
dcd_ptr:          .word dcd_hdr
boot_data_ptr:	  .word boot_data
self_ptr:         .word ivt_header
#ifdef CONFIG_SECURE_BOOT
app_code_csf:     .word __hab_data
#else
app_code_csf:     .word 0x0
#endif
reserv2:          .word 0x0

boot_data:        .word TEXT_BASE
#ifdef CONFIG_SECURE_BOOT
image_len:        .word __hab_data_end - TEXT_BASE + CONFIG_FLASH_HEADER_OFFSET
#else
image_len:        .word _end_of_copy  - TEXT_BASE + CONFIG_FLASH_HEADER_OFFSET
#endif
plugin:           .word 0x0

#if defined CONFIG_MX6DL_DDR3
#if defined CONFIG_DDR_64BIT
dcd_hdr:          .word 0x40A002D2 /* Tag=0xD2, Len=83*8 + 4 + 4, Ver=0x40 */
write_dcd_cmd:    .word 0x049C02CC /* Tag=0xCC, Len=83*8 + 4, Param=0x04 */

/* //,============================================================================					 */
/* //init script for i.MX6DL DDR3					 */
/* //,============================================================================					 */
/* // Revision History					 */
/* // v01					 */
/* //,============================================================================					 */

/* //,============================================================================					 */
/* // IOMUX					 */
/* //,============================================================================					 */
/* //DDR IO TYPE:					 */
EFI_MXC_DCD_ITEM(	0x020e0774 ,	0x000C0000	/* // IOMUXC_SW_PAD_CTL_GRP_DDR_TYPE 		 */)
EFI_MXC_DCD_ITEM(	0x020e0754 ,	0x00000000	/* // IOMUXC_SW_PAD_CTL_GRP_DDRPKE 		 */)

/* //CLOCK:					 */
EFI_MXC_DCD_ITEM(	0x020e04ac ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_0		 */)
EFI_MXC_DCD_ITEM(	0x020e04b0 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_1		 */)

/* //ADDRESS:					 */
EFI_MXC_DCD_ITEM(	0x020e0464 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_CAS		 */)
EFI_MXC_DCD_ITEM(	0x020e0490 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RAS		 */)
EFI_MXC_DCD_ITEM(	0x020e074c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_ADDDS 		 */)

/* //CONTROL:					 */
EFI_MXC_DCD_ITEM(	0x020e0494 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RESET		 */)

EFI_MXC_DCD_ITEM(	0x020e04a0 ,	0x00000000	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDBA2 - DSE can be configured using Group Control Register: IOMUXC_SW_PAD_CTL_GRP_CTLDS		 */)
EFI_MXC_DCD_ITEM(	0x020e04b4 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT0		 */)
EFI_MXC_DCD_ITEM(	0x020e04b8 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT1		 */)
EFI_MXC_DCD_ITEM(	0x020e076c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_CTLDS 		 */)

/* //DATA STROBE:					 */
EFI_MXC_DCD_ITEM(	0x020e0750 ,	0x00020000	/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE_CTL 		 */)

EFI_MXC_DCD_ITEM(	0x020e04bc ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS0 		 */)
EFI_MXC_DCD_ITEM(	0x020e04c0 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS1 		 */)
EFI_MXC_DCD_ITEM(	0x020e04c4 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS2 		 */)
EFI_MXC_DCD_ITEM(	0x020e04c8 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS3 		 */)
EFI_MXC_DCD_ITEM(	0x020e04cc ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS4 		 */)
EFI_MXC_DCD_ITEM(	0x020e04d0 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS5 		 */)
EFI_MXC_DCD_ITEM(	0x020e04d4 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS6 		 */)
EFI_MXC_DCD_ITEM(	0x020e04d8 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS7 		 */)

/* //DATA:					 */
EFI_MXC_DCD_ITEM(	0x020e0760 ,	0x00020000	/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE		 */)

EFI_MXC_DCD_ITEM(	0x020e0764 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B0DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e0770 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B1DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e0778 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B2DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e077c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B3DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e0780 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B4DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e0784 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B5DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e078c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B6DS 		 */)
EFI_MXC_DCD_ITEM(	0x020e0748 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_GRP_B7DS 		 */)

EFI_MXC_DCD_ITEM(	0x020e0470 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM0		 */)
EFI_MXC_DCD_ITEM(	0x020e0474 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM1		 */)
EFI_MXC_DCD_ITEM(	0x020e0478 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM2		 */)
EFI_MXC_DCD_ITEM(	0x020e047c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM3		 */)
EFI_MXC_DCD_ITEM(	0x020e0480 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM4		 */)
EFI_MXC_DCD_ITEM(	0x020e0484 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM5		 */)
EFI_MXC_DCD_ITEM(	0x020e0488 ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM6		 */)
EFI_MXC_DCD_ITEM(	0x020e048c ,	0x00000030	/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM7		 */)

/* //,============================================================================					 */
/* // DDR Controller Registers					 */
/* //,============================================================================					 */
/* // Manufacturer:	Micron				 */
/* // Device Part Number:	MT41K256M16HA-125E				 */
/* // Clock Freq.: 	400MHz				 */
/* // Density per CS in Gb: 	16				 */
/* // Chip Selects used:	1				 */
/* // Number of Banks:	8				 */
/* // Row address:    	15				 */
/* // Column address: 	10				 */
/* // Data bus width	64				 */
/* //,============================================================================					 */
EFI_MXC_DCD_ITEM(	0x021b0800 ,	0xa1390003 	/* // DDR_PHY_P0_MPZQHWCTRL, enable both one-time & periodic HW ZQ calibration.	0x00000002	0xa1390003  */)

/* // write leveling, based on Freescale board layout and T topology					 */
/* // For target board, may need to run write leveling calibration 					 */
/* // to fine tune these settings					 */
/* // If target board does not use T topology, then these registers					 */
/* // should either be cleared or write leveling calibration can be run					 */
EFI_MXC_DCD_ITEM(	0x021b080c , 	0x001F001F			)
EFI_MXC_DCD_ITEM(	0x021b0810 , 	0x001F001F			)
EFI_MXC_DCD_ITEM(	0x021b480c , 	0x001F001F			)
EFI_MXC_DCD_ITEM(	0x021b4810 , 	0x001F001F			)

/* //######################################################					 */
/* //calibration values based on calibration compare of 0x00ffff00:					 */
/* //Note, these calibration values are based on Freescale's board					 */
/* //May need to run calibration on target board to fine tune these 					 */
/* //######################################################					 */

/* //Read DQS Gating calibration					 */
EFI_MXC_DCD_ITEM(	0x021b083c ,	0x42300230	/* // MPDGCTRL0 PHY0	0x00320000	0x4220021F */)
EFI_MXC_DCD_ITEM(	0x021b0840 ,	0x02240224	/* // MPDGCTRL1 PHY0	0x00000000	0x0207017E */)
EFI_MXC_DCD_ITEM(	0x021b483c ,	0x421C0228	/* // MPDGCTRL0 PHY1	0x00000000	0x4201020C */)
EFI_MXC_DCD_ITEM(	0x021b4840 ,	0x02140214	/* // MPDGCTRL1 PHY1	0x02000000	0x01660172 */)

/* //Read calibration					 */
EFI_MXC_DCD_ITEM(	0x021b0848 ,	0x40424444	/* // MPRDDLCTL PHY0	0x00000100	0x4A4D4E4D */)
EFI_MXC_DCD_ITEM(	0x021b4848 ,	0x46464844	/* // MPRDDLCTL PHY1	0x02400040	0x4A4F5049 */)

/* //Write calibration					 */
EFI_MXC_DCD_ITEM(	0x021b0850 ,	0x34322A30	/* // MPWRDLCTL PHY0	0x01000000	0x3F3C3D31 */)
EFI_MXC_DCD_ITEM(	0x021b4850 ,	0x3634342E	/* // MPWRDLCTL PHY1	0x0a000100	0x3238372B */)

/* //read data bit delay: (3 is the reccommended default value, although out of reset value is 0):					 */
EFI_MXC_DCD_ITEM(	0x021b081c ,	0x33333333	/* // DDR_PHY_P0_MPREDQBY0DL3	Original Values (Delete Later)	Difference? */)
EFI_MXC_DCD_ITEM(	0x021b0820 ,	0x33333333	/* // DDR_PHY_P0_MPREDQBY1DL3	0x00009c40	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b0824 ,	0x33333333	/* // DDR_PHY_P0_MPREDQBY2DL3	0x00000000	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b0828 ,	0x33333333	/* // DDR_PHY_P0_MPREDQBY3DL3	0x00000000	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b481c ,	0x33333333	/* // DDR_PHY_P1_MPREDQBY0DL3	0x02000000	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b4820 ,	0x33333333	/* // DDR_PHY_P1_MPREDQBY1DL3	0x01010706	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b4824 ,	0x33333333	/* // DDR_PHY_P1_MPREDQBY2DL3	0x080b0201	0x33333333 */)
EFI_MXC_DCD_ITEM(	0x021b4828 ,	0x33333333	/* // DDR_PHY_P1_MPREDQBY3DL3	0x02000303	0x33333333 */)

/* // Complete calibration by forced measurement:					 */
EFI_MXC_DCD_ITEM(	0x021b08b8 ,	0x00000800 	/* // DDR_PHY_P0_MPMUR0, frc_msr	0x02020101	0x00000800  */)
EFI_MXC_DCD_ITEM(	0x021b48b8 ,	0x00000800 	/* // DDR_PHY_P0_MPMUR0, frc_msr	0x00000000	0x00000800  */)

/* //MMDC init:					 */
EFI_MXC_DCD_ITEM(	0x021b0004 ,	0x0001002D	/* // MMDC0_MDPDC 	0x00000100	0x0001002D */)
EFI_MXC_DCD_ITEM(	0x021b0008 ,	0x00333030	/* // MMDC0_MDOTC	0x00050612	0x00333030 */)
EFI_MXC_DCD_ITEM(	0x021b000c ,	0x676B52F3	/* // MMDC0_MDCFG0	0x06030301	0x676B52F3 */)
EFI_MXC_DCD_ITEM(	0x021b0010 ,	0xB66D8BC3	/* // MMDC0_MDCFG1	0x00000000	0xB66D8BC3 */)
EFI_MXC_DCD_ITEM(	0x021b0014 ,	0x01FF00DB	/* // MMDC0_MDCFG2	0x00000a02	0x01FF00DB */)
EFI_MXC_DCD_ITEM(	0x021b0018 ,	0x00001740	/* // MMDC0_MDMISC	0x015dc002	0x00001740 */)
/* //NOTE about MDMISC RALAT:					 */
/* //MDMISC: RALAT kept to the high level of 5 to ensure stable operation at 528MHz. 					 */
/* //MDMISC: consider reducing RALAT if your 528MHz board design allow that. Lower RALAT benefits: 					 */
/* //a. better operation at low frequency					 */
/* //b. Small performence improvment					 */

EFI_MXC_DCD_ITEM(	0x021b001c ,	0x00008000	/* // MMDC0_MDSCR, set the Configuration request bit during MMDC set up	0x00000606	0x00008000 */)
EFI_MXC_DCD_ITEM(	0x021b002c ,	0x000026d2	/* // MMDC0_MDRWD; recommend to maintain the default values	0x00000003	0x000026d2 */)
EFI_MXC_DCD_ITEM(	0x021b0030 ,	0x006B1023	/* // MMDC0_MDOR	0x00001401	0x006B1023 */)
EFI_MXC_DCD_ITEM(	0x021b0040 ,	0x00000047	/* // CS0_END 	0x0018001b	0x00000047 */)

EFI_MXC_DCD_ITEM(	0x021b0000 ,	0x841A0000	/* // MMDC0_MDCTL	0x00010000	0x841A0000 */)

/* // Mode register writes					 */
EFI_MXC_DCD_ITEM(	0x021b001c ,	0x04008032	/* // MMDC0_MDSCR, MR2 write, CS0	0x00000000	0x04008032 */)
EFI_MXC_DCD_ITEM(	0x021b001c ,	0x00008033	/* // MMDC0_MDSCR, MR3 write, CS0	0x00000000	0x00008033 */)
EFI_MXC_DCD_ITEM(	0x021b001c ,	0x00048031	/* // MMDC0_MDSCR, MR1 write, CS0	0x00000000	0x00048031 */)
EFI_MXC_DCD_ITEM(	0x021b001c ,	0x05208030	/* // MMDC0_MDSCR, MR0 write, CS0	0x02000000	0x05208030 */)
EFI_MXC_DCD_ITEM(	0x021b001c ,	0x04008040	/* // MMDC0_MDSCR, ZQ calibration command sent to device on CS0		 */)

EFI_MXC_DCD_ITEM(	0x021b0020 ,	0x00005800	/* // MMDC0_MDREF	0x00320000	0x00005800 */)

EFI_MXC_DCD_ITEM(	0x021b0818 ,	0x00011117	/* // DDR_PHY_P0_MPODTCTRL	0x00000000	0x00011117 */)
EFI_MXC_DCD_ITEM(	0x021b4818 ,	0x00011117	/* // DDR_PHY_P1_MPODTCTRL	0x00000000	0x00011117 */)


EFI_MXC_DCD_ITEM(	0x021b0004 ,	0x0001556D	/* // MMDC0_MDPDC with PWDT bits set		 */)
EFI_MXC_DCD_ITEM(	0x021b0404 , 	0x00011006	/* // MMDC0_MAPSR ADOPT power down enabled, MMDC will enter automatically to self-refresh while the number of idle cycle reached.		 */)

EFI_MXC_DCD_ITEM(	0x021b001c ,	0x00000000	/* // MMDC0_MDSCR, clear this register (especially the configuration bit as initialization is complete)	0x01000202	0x00000000 */)
#elif defined CONFIG_DDR_32BIT
# ifdef CONFIG_MX6DL_UIB_REV_2
dcd_hdr:          .word 0x40A002D2 /* Tag=0xD2, Len=83*8 + 4 + 4, Ver=0x40 */
write_dcd_cmd:    .word 0x049C02CC /* Tag=0xCC, Len=83*8 + 4, Param=0x04 */

/* //,============================================================================ */
/* //init script for i.MX6DL DDR3 */
/* //,============================================================================ */
/* // Revision History */
/* // v01 */
/* //,============================================================================ */

/* //,============================================================================ */
/* // IOMUX */
/* //,============================================================================ */
/* //DDR IO TYPE: */
EFI_MXC_DCD_ITEM(0x020e0774 ,0x000C0000/* // IOMUXC_SW_PAD_CTL_GRP_DDR_TYPE  */)
EFI_MXC_DCD_ITEM(0x020e0754 ,0x00000000/* // IOMUXC_SW_PAD_CTL_GRP_DDRPKE  */)

/* //CLOCK: */
EFI_MXC_DCD_ITEM(0x020e04ac ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_0 */)
EFI_MXC_DCD_ITEM(0x020e04b0 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_1 */)

/* //ADDRESS: */
EFI_MXC_DCD_ITEM(0x020e0464 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_CAS */)
EFI_MXC_DCD_ITEM(0x020e0490 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RAS */)
EFI_MXC_DCD_ITEM(0x020e074c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_ADDDS  */)

/* //CONTROL: */
EFI_MXC_DCD_ITEM(0x020e0494 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RESET */)

EFI_MXC_DCD_ITEM(0x020e04a0 ,0x00000000/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDBA2 - DSE can be configured using Group Control Register: IOMUXC_SW_PAD_CTL_GRP_CTLDS */)
EFI_MXC_DCD_ITEM(0x020e04b4 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT0 */)
EFI_MXC_DCD_ITEM(0x020e04b8 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT1 */)
EFI_MXC_DCD_ITEM(0x020e076c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_CTLDS  */)

/* //DATA STROBE: */
EFI_MXC_DCD_ITEM(0x020e0750 ,0x00020000/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE_CTL  */)

EFI_MXC_DCD_ITEM(0x020e04bc ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS0  */)
EFI_MXC_DCD_ITEM(0x020e04c0 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS1  */)
EFI_MXC_DCD_ITEM(0x020e04c4 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS2  */)
EFI_MXC_DCD_ITEM(0x020e04c8 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS3  */)
EFI_MXC_DCD_ITEM(0x020e04cc ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS4  */)
EFI_MXC_DCD_ITEM(0x020e04d0 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS5  */)
EFI_MXC_DCD_ITEM(0x020e04d4 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS6  */)
EFI_MXC_DCD_ITEM(0x020e04d8 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS7  */)

/* //DATA: */
EFI_MXC_DCD_ITEM(0x020e0760 ,0x00020000/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE */)

EFI_MXC_DCD_ITEM(0x020e0764 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B0DS  */)
EFI_MXC_DCD_ITEM(0x020e0770 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B1DS  */)
EFI_MXC_DCD_ITEM(0x020e0778 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B2DS  */)
EFI_MXC_DCD_ITEM(0x020e077c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B3DS  */)
EFI_MXC_DCD_ITEM(0x020e0780 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B4DS  */)
EFI_MXC_DCD_ITEM(0x020e0784 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B5DS  */)
EFI_MXC_DCD_ITEM(0x020e078c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B6DS  */)
EFI_MXC_DCD_ITEM(0x020e0748 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B7DS  */)

EFI_MXC_DCD_ITEM(0x020e0470 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM0 */)
EFI_MXC_DCD_ITEM(0x020e0474 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM1 */)
EFI_MXC_DCD_ITEM(0x020e0478 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM2 */)
EFI_MXC_DCD_ITEM(0x020e047c ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM3 */)
EFI_MXC_DCD_ITEM(0x020e0480 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM4 */)
EFI_MXC_DCD_ITEM(0x020e0484 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM5 */)
EFI_MXC_DCD_ITEM(0x020e0488 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM6 */)
EFI_MXC_DCD_ITEM(0x020e048c ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM7 */)

/* //,============================================================================ */
/* // DDR Controller Registers */
/* //,============================================================================ */
/* // Manufacturer:Micron */
/* // Device Part Number:MT41K256M16HA-125E */
/* // Clock Freq.: 400MHz */
/* // Density per CS in Gb: 8 */
/* // Chip Selects used:1 */
/* // Number of Banks:8 */
/* // Row address:    15 */
/* // Column address: 10 */
/* // Data bus width32 */
/* //,============================================================================ */
EFI_MXC_DCD_ITEM(0x021b0800 ,0xa1390003 /* // DDR_PHY_P0_MPZQHWCTRL enable both one-time & periodic HW ZQ calibration."0x000000020xa1390003  */)

/* // write leveling based on Freescale board layout and T topology" */
/* // For target board may need to run write leveling calibration " */
/* // to fine tune these settings */
/* // If target board does not use T topology then these registers" */
/* // should either be cleared or write leveling calibration can be run */
EFI_MXC_DCD_ITEM(0x021b080c , 0x001F001F)
EFI_MXC_DCD_ITEM(0x021b0810 , 0x001F001F)
EFI_MXC_DCD_ITEM(0x021b480c , 0x001F001F)
EFI_MXC_DCD_ITEM(0x021b4810 , 0x001F001F)

/* //###################################################### */
/* //calibration values based on calibration compare of 0x00ffff00: */
/* //Note these calibration values are based on Freescale's board" */
/* //May need to run calibration on target board to fine tune these  */
/* //###################################################### */

/* //Read DQS Gating calibration */
EFI_MXC_DCD_ITEM(0x021b083c ,0x4220021F/* // MPDGCTRL0 PHY00x003200000x4220021F */)
EFI_MXC_DCD_ITEM(0x021b0840 ,0x0207017E/* // MPDGCTRL1 PHY00x000000000x0207017E */)
EFI_MXC_DCD_ITEM(0x021b483c ,0x4201020C/* // MPDGCTRL0 PHY10x000000000x4201020C */)
EFI_MXC_DCD_ITEM(0x021b4840 ,0x01660172/* // MPDGCTRL1 PHY10x020000000x01660172 */)

/* //Read calibration */
EFI_MXC_DCD_ITEM(0x021b0848 ,0x4A4D4E4D/* // MPRDDLCTL PHY00x000001000x4A4D4E4D */)
EFI_MXC_DCD_ITEM(0x021b4848 ,0x4A4F5049/* // MPRDDLCTL PHY10x024000400x4A4F5049 */)

/* //Write calibration */
EFI_MXC_DCD_ITEM(0x021b0850 ,0x3F3C3D31/* // MPWRDLCTL PHY00x010000000x3F3C3D31 */)
EFI_MXC_DCD_ITEM(0x021b4850 ,0x3238372B/* // MPWRDLCTL PHY10x0a0001000x3238372B */)

/* //read data bit delay: (3 is the reccommended default value although out of reset value is 0):" */
EFI_MXC_DCD_ITEM(0x021b081c ,0x33333333/* // DDR_PHY_P0_MPREDQBY0DL3Original Values (Delete Later)Difference? */)
EFI_MXC_DCD_ITEM(0x021b0820 ,0x33333333/* // DDR_PHY_P0_MPREDQBY1DL30x00009c400x33333333 */)
EFI_MXC_DCD_ITEM(0x021b0824 ,0x33333333/* // DDR_PHY_P0_MPREDQBY2DL30x000000000x33333333 */)
EFI_MXC_DCD_ITEM(0x021b0828 ,0x33333333/* // DDR_PHY_P0_MPREDQBY3DL30x000000000x33333333 */)
EFI_MXC_DCD_ITEM(0x021b481c ,0x33333333/* // DDR_PHY_P1_MPREDQBY0DL30x020000000x33333333 */)
EFI_MXC_DCD_ITEM(0x021b4820 ,0x33333333/* // DDR_PHY_P1_MPREDQBY1DL30x010107060x33333333 */)
EFI_MXC_DCD_ITEM(0x021b4824 ,0x33333333/* // DDR_PHY_P1_MPREDQBY2DL30x080b02010x33333333 */)
EFI_MXC_DCD_ITEM(0x021b4828 ,0x33333333/* // DDR_PHY_P1_MPREDQBY3DL30x020003030x33333333 */)

/* // Complete calibration by forced measurement: */
EFI_MXC_DCD_ITEM(0x021b08b8 ,0x00000800 /* // DDR_PHY_P0_MPMUR0 frc_msr"0x020201010x00000800  */)
EFI_MXC_DCD_ITEM(0x021b48b8 ,0x00000800 /* // DDR_PHY_P0_MPMUR0 frc_msr"0x000000000x00000800  */)

/* //MMDC init: */
EFI_MXC_DCD_ITEM(0x021b0004 ,0x0001002D/* // MMDC0_MDPDC 0x000001000x0001002D */)
EFI_MXC_DCD_ITEM(0x021b0008 ,0x00333030/* // MMDC0_MDOTC0x000506120x00333030 */)
EFI_MXC_DCD_ITEM(0x021b000c ,0x676B52F3/* // MMDC0_MDCFG00x060303010x676B52F3 */)
EFI_MXC_DCD_ITEM(0x021b0010 ,0xB66D8BC3/* // MMDC0_MDCFG10x000000000xB66D8BC3 */)
EFI_MXC_DCD_ITEM(0x021b0014 ,0x01FF00DB/* // MMDC0_MDCFG20x00000a020x01FF00DB */)
EFI_MXC_DCD_ITEM(0x021b0018 ,0x00001740/* // MMDC0_MDMISC0x015dc0020x00001740 */)
/* //NOTE about MDMISC RALAT: */
/* //MDMISC: RALAT kept to the high level of 5 to ensure stable operation at 528MHz.  */
/* //MDMISC: consider reducing RALAT if your 528MHz board design allow that. Lower RALAT benefits:  */
/* //a. better operation at low frequency */
/* //b. Small performence improvment */

EFI_MXC_DCD_ITEM(0x021b001c ,0x00008000/* // MMDC0_MDSCR set the Configuration request bit during MMDC set up"0x000006060x00008000 */)
EFI_MXC_DCD_ITEM(0x021b002c ,0x000026d2/* // MMDC0_MDRWD; recommend to maintain the default values0x000000030x000026d2 */)
EFI_MXC_DCD_ITEM(0x021b0030 ,0x006B1023/* // MMDC0_MDOR0x000014010x006B1023 */)
EFI_MXC_DCD_ITEM(0x021b0040 ,0x00000027/* // CS0_END 0x0018001b0x00000027 */)

EFI_MXC_DCD_ITEM(0x021b0000 ,0x84190000/* // MMDC0_MDCTL0x000100000x84190000 */)

/* // Mode register writes */
EFI_MXC_DCD_ITEM(0x021b001c ,0x04008032/* // MMDC0_MDSCR MR2 write CS0"0x000000000x04008032 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x00008033/* // MMDC0_MDSCR MR3 write CS0"0x000000000x00008033 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x00048031/* // MMDC0_MDSCR MR1 write CS0"0x000000000x00048031 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x05208030/* // MMDC0_MDSCR MR0 write CS0"0x020000000x05208030 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x04008040/* // MMDC0_MDSCR ZQ calibration command sent to device on CS0" */)

EFI_MXC_DCD_ITEM(0x021b0020 ,0x00005800/* // MMDC0_MDREF0x003200000x00005800 */)

EFI_MXC_DCD_ITEM(0x021b0818 ,0x00011117/* // DDR_PHY_P0_MPODTCTRL0x000000000x00011117 */)
EFI_MXC_DCD_ITEM(0x021b4818 ,0x00011117/* // DDR_PHY_P1_MPODTCTRL0x000000000x00011117 */)


EFI_MXC_DCD_ITEM(0x021b0004 ,0x0001556D/* // MMDC0_MDPDC with PWDT bits set */)
EFI_MXC_DCD_ITEM(0x021b0404 , 0x00011006/* // MMDC0_MAPSR ADOPT power down enabled MMDC will enter automatically to self-refresh while the number of idle cycle reached." */)

EFI_MXC_DCD_ITEM(0x021b001c ,0x00000000/* // MMDC0_MDSCR clear this register (especially the configuration bit as initialization is complete)"0x010002020x00000000 */)

# elif defined CONFIG_MX6DL_UIB_REV_3
dcd_hdr:          .word 0x40E001D2 /* Tag=0xD2, Len=59*8 + 4 + 4, Ver=0x40 */
write_dcd_cmd:    .word 0x04DC01CC /* Tag=0xCC, Len=59*8 + 4, Param=0x04 */

/* //,============================================================================ */
/* //init script for i.MX6Solo DDR3 SabreSD */
/* //,============================================================================ */
/* // Revision History */
/* // v01 */
/* //,============================================================================ */

/* //,============================================================================ */
/* // IOMUX */
/* //,============================================================================ */
/* //DDR IO TYPE: */
EFI_MXC_DCD_ITEM(0x020e0774 ,0x000C0000/* // IOMUXC_SW_PAD_CTL_GRP_DDR_TYPE  */)
EFI_MXC_DCD_ITEM(0x020e0754 ,0x00000000/* // IOMUXC_SW_PAD_CTL_GRP_DDRPKE  */)

/* //CLOCK: */
EFI_MXC_DCD_ITEM(0x020e04ac ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_0 */)
EFI_MXC_DCD_ITEM(0x020e04b0 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDCLK_1 */)

/* //ADDRESS: */
EFI_MXC_DCD_ITEM(0x020e0464 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_CAS */)
EFI_MXC_DCD_ITEM(0x020e0490 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RAS */)
EFI_MXC_DCD_ITEM(0x020e074c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_ADDDS  */)

/* //CONTROL: */
EFI_MXC_DCD_ITEM(0x020e0494 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_RESET */)

EFI_MXC_DCD_ITEM(0x020e04a0 ,0x00000000/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDBA2 - DSE can be configured using Group Control Register: IOMUXC_SW_PAD_CTL_GRP_CTLDS */)
EFI_MXC_DCD_ITEM(0x020e04b4 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT0 */)
EFI_MXC_DCD_ITEM(0x020e04b8 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDODT1 */)
EFI_MXC_DCD_ITEM(0x020e076c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_CTLDS  */)

/* //DATA STROBE: */
EFI_MXC_DCD_ITEM(0x020e0750 ,0x00020000/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE_CTL  */)

EFI_MXC_DCD_ITEM(0x020e04bc ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS0  */)
EFI_MXC_DCD_ITEM(0x020e04c0 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS1  */)
EFI_MXC_DCD_ITEM(0x020e04c4 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS2  */)
EFI_MXC_DCD_ITEM(0x020e04c8 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_SDQS3  */)

/* //DATA: */
EFI_MXC_DCD_ITEM(0x020e0760 ,0x00020000/* // IOMUXC_SW_PAD_CTL_GRP_DDRMODE */)

EFI_MXC_DCD_ITEM(0x020e0764 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B0DS  */)
EFI_MXC_DCD_ITEM(0x020e0770 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B1DS  */)
EFI_MXC_DCD_ITEM(0x020e0778 ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B2DS  */)
EFI_MXC_DCD_ITEM(0x020e077c ,0x00000030/* // IOMUXC_SW_PAD_CTL_GRP_B3DS  */)

EFI_MXC_DCD_ITEM(0x020e0470 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM0 */)
EFI_MXC_DCD_ITEM(0x020e0474 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM1 */)
EFI_MXC_DCD_ITEM(0x020e0478 ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM2 */)
EFI_MXC_DCD_ITEM(0x020e047c ,0x00000030/* // IOMUXC_SW_PAD_CTL_PAD_DRAM_DQM3 */)
/* //,============================================================================ */
/* // DDR Controller Registers */
/* //,============================================================================ */
/* // Manufacturer:Micron */
/* // Device Part Number:MT41K256M16HA-125 */
/* // Clock Freq.: 400MHz */
/* // Density per CS in Gb: 16 */
/* // Chip Selects used:1 */
/* // Number of Banks:8 */
/* // Row address:    15 */
/* // Column address: 10 */
/* // Data bus width32 */
/* //,============================================================================ */
EFI_MXC_DCD_ITEM(0x021b0800 ,0xa1390003 /* // DDR_PHY_P0_MPZQHWCTRL enable both one-time & periodic HW ZQ calibration.0x000000020xa1390003  */)

/* // write leveling based on Freescale board layout and T topology */
/* // For target board may need to run write leveling calibration  */
/* // to fine tune these settings */
/* // If target board does not use T topology then these registers */
/* // should either be cleared or write leveling calibration can be run */
EFI_MXC_DCD_ITEM(0x021b080c , 0x001F001F)
EFI_MXC_DCD_ITEM(0x021b0810 , 0x001F001F)

/* //###################################################### */
/* //calibration values based on calibration compare of 0x00ffff00: */
/* //Note these calibration values are based on Freescale's board */
/* //May need to run calibration on target board to fine tune these  */
/* //###################################################### */

/* //Read DQS Gating calibration */
EFI_MXC_DCD_ITEM(0x021b083c ,0x42190219/* // MPDGCTRL0 PHY00x003200000x42190219 */)
EFI_MXC_DCD_ITEM(0x021b0840 ,0x017B0177/* // MPDGCTRL1 PHY00x000000000x017B0177 */)

/* //Read calibration */
EFI_MXC_DCD_ITEM(0x021b0848 ,0x4B4D4E4D/* // MPRDDLCTL PHY00x000001000x4B4D4E4D */)

/* //Write calibration */
EFI_MXC_DCD_ITEM(0x021b0850 ,0x3F3E2D36/* // MPWRDLCTL PHY00x010000000x3F3E2D36 */)

/* //read data bit delay: (3 is the reccommended default value although out of reset value is 0): */
EFI_MXC_DCD_ITEM(0x021b081c ,0x33333333/* // DDR_PHY_P0_MPREDQBY0DL3Original Values (Delete Later)Difference? */)
EFI_MXC_DCD_ITEM(0x021b0820 ,0x33333333/* // DDR_PHY_P0_MPREDQBY1DL30x00009c400x33333333 */)
EFI_MXC_DCD_ITEM(0x021b0824 ,0x33333333/* // DDR_PHY_P0_MPREDQBY2DL30x000000000x33333333 */)
EFI_MXC_DCD_ITEM(0x021b0828 ,0x33333333/* // DDR_PHY_P0_MPREDQBY3DL30x000000000x33333333 */)

/* // Complete calibration by forced measurement: */
EFI_MXC_DCD_ITEM(0x021b08b8 ,0x00000800 /* // DDR_PHY_P0_MPMUR0 frc_msr0x020201010x00000800  */)

/* //MMDC init: */
EFI_MXC_DCD_ITEM(0x021b0004 ,0x0002002D/* // MMDC0_MDPDC 0x000001000x0002002D */)
EFI_MXC_DCD_ITEM(0x021b0008 ,0x00333030/* // MMDC0_MDOTC0x000506120x00333030 */)
EFI_MXC_DCD_ITEM(0x021b000c ,0x3F435313/* // MMDC0_MDCFG00x060303010x3F435313 */)
EFI_MXC_DCD_ITEM(0x021b0010 ,0xB66E8B63/* // MMDC0_MDCFG10x000000000xB66E8B63 */)
EFI_MXC_DCD_ITEM(0x021b0014 ,0x01FF00DB/* // MMDC0_MDCFG20x00000a020x01FF00DB */)
EFI_MXC_DCD_ITEM(0x021b0018 ,0x00001740/* // MMDC0_MDMISC0x015dc0020x00001740 */)
/* //NOTE about MDMISC RALAT: */
/* //MDMISC: RALAT kept to the high level of 5 to ensure stable operation at 528MHz.  */
/* //MDMISC: consider reducing RALAT if your 528MHz board design allow that. Lower RALAT benefits:  */
/* //a. better operation at low frequency */
/* //b. Small performence improvment */

EFI_MXC_DCD_ITEM(0x021b001c ,0x00008000/* // MMDC0_MDSCR set the Configuration request bit during MMDC set up0x000006060x00008000 */)
EFI_MXC_DCD_ITEM(0x021b002c ,0x000026d2/* // MMDC0_MDRWD; recommend to maintain the default values0x000000030x000026d2 */)
EFI_MXC_DCD_ITEM(0x021b0030 ,0x00431023/* // MMDC0_MDOR0x000014010x00431023 */)
EFI_MXC_DCD_ITEM(0x021b0040 ,0x00000047/* // CS0_END 0x0018001b0x00000047 */)

EFI_MXC_DCD_ITEM(0x021b0000 ,0x84190000/* // MMDC0_MDCTL0x000100000x84190000 */)

/* // Mode register writes */
EFI_MXC_DCD_ITEM(0x021b001c ,0x04008032/* // MMDC0_MDSCR MR2 write CS00x000000000x04008032 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x00008033/* // MMDC0_MDSCR MR3 write CS00x000000000x00008033 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x00048031/* // MMDC0_MDSCR MR1 write CS00x000000000x00048031 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x05208030/* // MMDC0_MDSCR MR0 write CS00x020000000x05208030 */)
EFI_MXC_DCD_ITEM(0x021b001c ,0x04008040/* // MMDC0_MDSCR ZQ calibration command sent to device on CS0 */)


EFI_MXC_DCD_ITEM(0x021b0020 ,0x00005800/* // MMDC0_MDREF0x003200000x00005800 */)
EFI_MXC_DCD_ITEM(0x021b0818 ,0x00011117/* // DDR_PHY_P0_MPODTCTRL0x000000000x00011117 */)


EFI_MXC_DCD_ITEM(0x021b0004 ,0x0002556D/* // MMDC0_MDPDC with PWDT bits set */)
EFI_MXC_DCD_ITEM(0x021b0404 , 0x00011006/* // MMDC0_MAPSR ADOPT power down enabled MMDC will enter automatically to self-refresh while the number of idle cycle reached. */)

EFI_MXC_DCD_ITEM(0x021b001c ,0x00000000/* // MMDC0_MDSCR clear this register (especially the configuration bit as initialization is complete)0x010002020x00000000 */)
# endif // CONFIG_MX6DL_UIB_REV_3

#endif // CONFIG_DDR_32BIT

#endif // CONFIG_MX6DL_DDR3

#endif // CONFIG_FLASH_HEADER
