/*
 * Copyright (C) 2010-2013 Freescale Semiconductor, Inc.
 * Copyright (C) 2013 High Technology Devices LLC.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
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

#include <common.h>
#include <asm/io.h>
#include <asm/arch/mx6.h>
#include <asm/arch/mx6_pins.h>
#include <asm/arch/mx6dl_pins.h>
#if defined(CONFIG_SECURE_BOOT)
#include <asm/arch/mx6_secure.h>
#endif
#include <asm/arch/iomux-v3.h>
#include <asm/arch/regs-anadig.h>
#include <asm/errno.h>
#include <imx_wdog.h>
#ifdef CONFIG_MXC_FEC
#include <miiphy.h>
#endif

#ifdef CONFIG_CMD_MMC
#include <mmc.h>
#include <fsl_esdhc.h>
#endif

#ifdef CONFIG_MXC_GPIO
#include <asm/gpio.h>
#include <asm/arch/gpio.h>
#endif

#ifdef CONFIG_ANDROID_RECOVERY
#include <recovery.h>
#endif

#if CONFIG_I2C_MXC
#include <i2c.h>
#endif

DECLARE_GLOBAL_DATA_PTR;

static enum boot_device boot_dev;

#define FEC_RMII_RST 	IMX_GPIO_NR(3, 31)
#define FEC_RMII_INT 	IMX_GPIO_NR(3, 30)
#define FEC_RMII_LED1 	IMX_GPIO_NR(3, 23)
#define GPIO_I2C2_SCL 	IMX_GPIO_NR(4, 12)
#define GPIO_I2C2_SDA 	IMX_GPIO_NR(4, 13)
#define GPIO_I2C3_SCL 	IMX_GPIO_NR(1, 3)
#define GPIO_I2C3_SDA 	IMX_GPIO_NR(1, 6)
#define I2C2_SDA_GPIO4_13_BIT_MASK (1 << 13)
#define I2C3_SDA_GPIO1_6_BIT_MASK  (1 << 6)

static inline void setup_boot_device(void)
{
	uint soc_sbmr = readl(SRC_BASE_ADDR + 0x4);
	uint bt_mem_ctl = (soc_sbmr & 0x000000FF) >> 4 ;
	uint bt_mem_type = (soc_sbmr & 0x00000008) >> 3;

	switch (bt_mem_ctl) {
	case 0x0:
		if (bt_mem_type)
			boot_dev = ONE_NAND_BOOT;
		else
			boot_dev = WEIM_NOR_BOOT;
		break;
	case 0x2:
			boot_dev = SATA_BOOT;
		break;
	case 0x3:
		if (bt_mem_type)
			boot_dev = I2C_BOOT;
		else
			boot_dev = SPI_NOR_BOOT;
		break;
	case 0x4:
	case 0x5:
		boot_dev = SD_BOOT;
		break;
	case 0x6:
	case 0x7:
		boot_dev = MMC_BOOT;
		break;
	case 0x8 ... 0xf:
		boot_dev = NAND_BOOT;
		break;
	default:
		boot_dev = UNKNOWN_BOOT;
		break;
	}
}

enum boot_device get_boot_device(void)
{
	return boot_dev;
}

u32 get_board_rev(void)
{
	return fsl_system_rev;
}

int dram_init(void)
{
	gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
	gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;

	return 0;
}

static void setup_uart(void)
{
	mxc_iomux_v3_setup_pad(MX6Q_PAD_KEY_COL0__UART4_TXD);
	mxc_iomux_v3_setup_pad(MX6Q_PAD_KEY_ROW0__UART4_RXD);
}

#ifdef CONFIG_NET_MULTI
int board_eth_init(bd_t *bis)
{
	int rc = -ENODEV;

	return rc;
}
#endif

#ifdef CONFIG_CMD_MMC
struct fsl_esdhc_cfg usdhc_cfg[1] = {
	{USDHC1_BASE_ADDR, 1, 1, 1, 1},
};

iomux_v3_cfg_t usdhc1_pads[] = {
	/* 4 bit SD */
	MX6Q_PAD_SD1_CLK__USDHC1_CLK,
	MX6Q_PAD_SD1_CMD__USDHC1_CMD,
	MX6Q_PAD_SD1_DAT0__USDHC1_DAT0,
	MX6Q_PAD_SD1_DAT1__USDHC1_DAT1,
	MX6Q_PAD_SD1_DAT2__USDHC1_DAT2,
	MX6Q_PAD_SD1_DAT3__USDHC1_DAT3,
	MX6Q_PAD_KEY_COL1__USDHC1_VSELECT,
};

int usdhc_gpio_init(bd_t *bis)
{
	s32 status = 0;

	mxc_iomux_v3_setup_multiple_pads(usdhc1_pads,
		ARRAY_SIZE(usdhc1_pads));

	status |= fsl_esdhc_initialize(bis, &usdhc_cfg[1]);

	return status;
}

int board_mmc_init(bd_t *bis)
{
	if (!usdhc_gpio_init(bis))
		return 0;
	else
		return -1;
}

/* For DDR mode operation, provide target delay parameter for each SD port.
 * Use cfg->esdhc_base to distinguish the SD port #. The delay for each port
 * is dependent on signal layout for that particular port.  If the following
 * CONFIG is not defined, then the default target delay value will be used.
 */
#ifdef CONFIG_GET_DDR_TARGET_DELAY
u32 get_ddr_delay(struct fsl_esdhc_cfg *cfg)
{
	/* No delay required on board SD ports */
	return 0;
}
#endif
#endif

#ifdef CONFIG_MXC_FEC
iomux_v3_cfg_t enet_pads[] = {
	MX6Q_PAD_ENET_MDC__ENET_MDC,
	MX6Q_PAD_ENET_MDIO__ENET_MDIO,
	MX6Q_PAD_ENET_RX_ER__ENET_RX_ER,
	MX6Q_PAD_ENET_TX_EN__ENET_TX_EN,
	MX6Q_PAD_ENET_RXD0__ENET_RDATA_0,
	MX6Q_PAD_ENET_RXD1__ENET_RDATA_1,
	MX6Q_PAD_ENET_TXD0__ENET_TDATA_0,
	MX6Q_PAD_ENET_TXD1__ENET_TDATA_1,
	MX6Q_PAD_ENET_CRS_DV__ENET_RX_EN,
	MX6Q_PAD_GPIO_16__ENET_ANATOP_ETHERNET_REF_OUT,
};

int mx6_rgmii_rework(char *devname, int phy_addr)
{
	/* todo */
}

void enet_board_init(void)
{
	mxc_iomux_v3_setup_multiple_pads(enet_pads,
			ARRAY_SIZE(enet_pads));

	/* keep reset line asserted */
	gpio_direction_output(FEC_RMII_RST, 1);
	/* link led1 on */
	gpio_direction_output(FEC_RMII_LED1, 0);
	/* fec interrupt */
	gpio_direction_input(FEC_RMII_INT);

}

#define ANATOP_PLL_LOCK             0x80000000
#define ANATOP_PLL_PWDN_MASK        0x00001000
#define ANATOP_PLL_BYPASS_MASK      0x00010000
#define ANATOP_FEC_PLL_ENABLE_MASK 	0x00002000

static int setup_fec(void)
{
	u32 reg = 0;
	s32 timeout = 100000;

	/* get enet tx reference clk from internal clock from
	 * anatop GPR1[21] = 1;
	 */
	reg =  readl(IOMUXC_BASE_ADDR + 0x4);
	reg |= (0x1 << 21);
	writel(reg, IOMUXC_BASE_ADDR + 0x4);

#ifdef CONFIG_FEC_CLOCK_FROM_ANATOP
	/* Enable Enet PLL, default div select 50Mhz */
	reg = readl(ANATOP_BASE_ADDR + 0xe0); /* ENET PLL */
	if ((reg & ANATOP_PLL_PWDN_MASK) || (!(reg & ANATOP_PLL_LOCK))) {
		reg &= ~ANATOP_PLL_PWDN_MASK;
		writel(reg, ANATOP_BASE_ADDR + 0xe0);
		while (timeout--) {
			if (readl(ANATOP_BASE_ADDR + 0xe0) & ANATOP_PLL_LOCK)
				break;
		}
		if (timeout <= 0)
			return -1;
	}

	/* Enable FEC clock */
	reg |= ANATOP_FEC_PLL_ENABLE_MASK;
	reg &= ~ANATOP_PLL_BYPASS_MASK;
	writel(reg, ANATOP_BASE_ADDR + 0xe0);
#endif
	return 0;
}
#endif

#ifdef CONFIG_I2C_MXC
iomux_v3_cfg_t i2c2_pads[] = {
	MX6Q_PAD_KEY_ROW3__I2C2_SDA,
	MX6Q_PAD_KEY_COL3__I2C2_SCL,
};

iomux_v3_cfg_t i2c3_pads[] = {
	MX6Q_PAD_GPIO_6__I2C3_SDA,
	MX6Q_PAD_GPIO_3__I2C3_SCL,
};

/* Note: udelay() is not accurate for i2c timing */
static void __udelay(int time)
{
	int i, j;

	for (i = 0; i < time; i++) {
		for (j = 0; j < 200; j++) {
			asm("nop");
			asm("nop");
		}
	}
}

static void setup_i2c(unsigned int module_base)
{
	unsigned int reg;

	switch (module_base) {
	case I2C2_BASE_ADDR:
		mxc_iomux_v3_setup_multiple_pads(i2c2_pads,
			ARRAY_SIZE(i2c2_pads));
		/* Enable i2c clock */
		reg = readl(CCM_BASE_ADDR + CLKCTL_CCGR2);
		reg |= 0x300;
		writel(reg, CCM_BASE_ADDR + CLKCTL_CCGR2);
		break;
	case I2C3_BASE_ADDR:
		mxc_iomux_v3_setup_multiple_pads(i2c3_pads,
			ARRAY_SIZE(i2c3_pads));
		/* enable i2c clock */
		reg = readl(CCM_BASE_ADDR + CLKCTL_CCGR2);
		reg |= 0xC00;
		writel(reg, CCM_BASE_ADDR + CLKCTL_CCGR2);
		break;
	default:
		printf("Invalid I2C base: 0x%x\n", module_base);
		break;
	}
}

/* set i2c scl gpio direction */
static void mx6q_i2c_gpio_scl_direction(int bus, int output)
{
	switch (bus) {
	case 2:
		mxc_iomux_v3_setup_pad(MX6Q_PAD_KEY_COL3__GPIO_4_12);
		if (output)
			gpio_direction_output(GPIO_I2C2_SCL, 1);
		else
			gpio_direction_input(GPIO_I2C2_SCL);
		break;
	case 3:
		mxc_iomux_v3_setup_pad(MX6Q_PAD_GPIO_3__I2C3_SCL);
		if (output)
			gpio_direction_output(GPIO_I2C3_SCL, 1);
		else
			gpio_direction_input(GPIO_I2C3_SCL);
		break;
	default:
		printf("Invalid I2C bus id: %d\n", bus);
		break;
	}
}

static void mx6q_i2c_gpio_scl_set_level(int bus, int high)
{
	switch (bus) {
	case 2:
		if (high)
			gpio_direction_output(GPIO_I2C2_SCL, 1);
		else
			gpio_direction_output(GPIO_I2C2_SCL, 0);
		break;
	case 3:
		if (high)
			gpio_direction_output(GPIO_I2C3_SCL, 1);
		else
			gpio_direction_output(GPIO_I2C3_SCL, 0);
		break;
	default:
		break;
	}
}

/* set i2c sda gpio direction */
static void mx6q_i2c_gpio_sda_direction(int bus, int output)
{
	switch (bus) {
	case 2:
		mxc_iomux_v3_setup_pad(MX6Q_PAD_KEY_ROW3__GPIO_4_13);
		if (output)
			gpio_direction_output(GPIO_I2C2_SCL, 1);
		else
			gpio_direction_input(GPIO_I2C2_SCL);
		break;
	case 3:
		mxc_iomux_v3_setup_pad(MX6Q_PAD_GPIO_6__GPIO_1_6);
		if (output)
			gpio_direction_output(GPIO_I2C3_SCL, 1);
		else
			gpio_direction_input(GPIO_I2C3_SCL);
		break;
	default:
		printf("Invalid I2C bus id: %d\n", bus);
		break;
	}
}

static void mx6q_i2c_gpio_sda_set_level(int bus, int high)
{
	switch (bus) {
	case 2:
		if (high)
			gpio_direction_output(GPIO_I2C2_SDA, 1);
		else
			gpio_direction_output(GPIO_I2C2_SDA, 0);
		break;
	case 3:
		if (high)
			gpio_direction_output(GPIO_I2C3_SDA, 1);
		else
			gpio_direction_output(GPIO_I2C3_SDA, 0);
		break;
	default:
		break;
	}
}

static int mx6q_i2c_gpio_check_sda(int bus)
{
	u32 reg;
	int result = 0;

	switch (bus) {
	case 2:
		reg = readl(GPIO4_BASE_ADDR + GPIO_PSR);
		result = !!(reg & I2C2_SDA_GPIO4_13_BIT_MASK);
		break;
	case 3:
		reg = readl(GPIO1_BASE_ADDR + GPIO_PSR);
		result = !!(reg & I2C3_SDA_GPIO1_6_BIT_MASK);
		break;
	}

	return result;
}

int i2c_bus_recovery(int bus)
{
	int i, result = 0;

	mx6q_i2c_gpio_sda_direction(bus, 0);
	if (mx6q_i2c_gpio_check_sda(bus) == 0) {
		printf("i2c: I2C%d SDA is low, start i2c recovery...\n", bus);
		mx6q_i2c_gpio_scl_direction(bus, 1);
		__udelay(10000);

		for (i = 0; i < 9; i++) {
			mx6q_i2c_gpio_scl_set_level(bus, 1);
			__udelay(5);
			mx6q_i2c_gpio_scl_set_level(bus, 0);
			__udelay(5);
		}
	}

	mx6q_i2c_gpio_sda_direction(bus, 1);
	mx6q_i2c_gpio_sda_set_level(bus, 1);
	__udelay(1); /* Pull up SDA first */
	mx6q_i2c_gpio_scl_set_level(bus, 1);
	__udelay(5); /* plus pervious 1 us */
	mx6q_i2c_gpio_scl_set_level(bus, 0);
	__udelay(5);
	mx6q_i2c_gpio_sda_set_level(bus, 0);
	__udelay(5);
	mx6q_i2c_gpio_scl_set_level(bus, 1);
	__udelay(5);
	/* Here: SCL is high, and SDA from low to high, it's a
	 *  stop condition */
	mx6q_i2c_gpio_sda_set_level(bus, 1);
	__udelay(5);

	mx6q_i2c_gpio_sda_direction(bus, 0);
	if (mx6q_i2c_gpio_check_sda(bus) == 1)
		printf("I2C%d Recovery success\n", bus);
	else {
		printf("I2C%d Recovery failed, I2C1 SDA still low!!!\n", bus);
		result |= 1 << bus;
	}

	switch (bus) {
	case 2:
		setup_i2c(I2C2_BASE_ADDR);
		break;
	case 3:
		setup_i2c(I2C3_BASE_ADDR);
		break;
	default:
		break;
	}

	return result;
}

static int setup_pmic_voltages(void)
{
	unsigned char value, rev_id = 0 ;

	i2c_init(CONFIG_SYS_I2C_SPEED, CONFIG_SYS_I2C_SLAVE);
	if (!i2c_probe(0x8)) {
		if (i2c_read(0x8, 0, 1, &value, 1)) {
			printf("Read device ID error!\n");
			return -1;
		}
		if (i2c_read(0x8, 3, 1, &rev_id, 1)) {
			printf("Read Rev ID error!\n");
			return -1;
		}
		printf("Found PFUZE100! deviceid=%x,revid=%x\n", value, rev_id);

	}

	return 0;
}
#endif

int board_init(void)
{
/*
 * need set Power Supply Glitch to 0x41736166
 * and need clear Power supply Glitch Detect bit
 * when POR or reboot or power on Otherwise system
 * could not be power off anymore
 * */
	u32 reg;
	writel(0x41736166, SNVS_BASE_ADDR + 0x64);/*set LPPGDR*/
	udelay(10);
	reg = readl(SNVS_BASE_ADDR + 0x4c);
	reg |= (1 << 3);
	writel(reg, SNVS_BASE_ADDR + 0x4c);/*clear LPSR*/

	mxc_iomux_v3_init((void *)IOMUXC_BASE_ADDR);
	setup_boot_device();

	/* board id for linux */
	gd->bd->bi_arch_number = MACH_TYPE_MX6Q_JUPITER;

	/* address of boot parameters */
	gd->bd->bi_boot_params = PHYS_SDRAM_1 + 0x100;

	wdog_preconfig(WDOG1_BASE_ADDR);

	setup_uart();

#ifdef CONFIG_MXC_FEC
	setup_fec();
#endif

	return 0;
}

int board_late_init(void)
{
#ifdef CONFIG_I2C_MXC
	int ret = 0;
	setup_i2c(CONFIG_SYS_I2C_PORT);
	i2c_bus_recovery(CONFIG_SYS_I2C_BUS);
	ret = setup_pmic_voltages();
	if (ret)
		return -1;
#endif
	return 0;
}

int checkboard(void)
{
	printf("Board: %s-Jupiter: %s Board: 0x%x [",
		mx6_chip_name(),
		mx6_board_rev_name(),
		fsl_system_rev);

	switch (__REG(SRC_BASE_ADDR + 0x8)) {
	case 0x0001:
		printf("POR");
		break;
	case 0x0009:
		printf("RST");
		break;
	case 0x0010:
	case 0x0011:
		printf("WDOG");
		break;
	default:
		printf("unknown");
	}
	printf(" ]\n");

	printf("Boot Device: ");
	switch (get_boot_device()) {
	case WEIM_NOR_BOOT:
		printf("NOR\n");
		break;
	case ONE_NAND_BOOT:
		printf("ONE NAND\n");
		break;
	case PATA_BOOT:
		printf("PATA\n");
		break;
	case SATA_BOOT:
		printf("SATA\n");
		break;
	case I2C_BOOT:
		printf("I2C\n");
		break;
	case SPI_NOR_BOOT:
		printf("SPI NOR\n");
		break;
	case SD_BOOT:
		printf("SD\n");
		break;
	case MMC_BOOT:
		printf("MMC\n");
		break;
	case NAND_BOOT:
		printf("NAND\n");
		break;
	case UNKNOWN_BOOT:
	default:
		printf("UNKNOWN\n");
		break;
	}

#ifdef CONFIG_SECURE_BOOT
	if (check_hab_enable() == 1)
		get_hab_status();
#endif

	return 0;
}

#ifdef CONFIG_ANDROID_RECOVERY
int check_recovery_cmd_file(void)
{
	return check_and_clean_recovery_flag();
}
#endif
