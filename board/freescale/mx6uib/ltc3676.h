/*
 * Copyright 2013 Linear Technology Corp. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef __LINUX_LTC3676_PMIC_H
#define __LINUX_LTC3676_PMIC_H

#define LTC3676_I2C_ADDR	0x3c

#define LTC3676_DCDC_1   0x00
#define LTC3676_DCDC_2   0x01
#define LTC3676_DCDC_3   0x02
#define LTC3676_DCDC_4   0x03
#define LTC3676_LDO_1    0x04
#define LTC3676_LDO_2    0x05
#define LTC3676_LDO_3    0x06
#define LTC3676_LDO_4    0x07
#define LTC3676_REG_NUM  7
#define LTC3676_NUM_REGULATOR	7

/* LTC3676 Registers */
#define LTC3676_REG_BUCK1     0x01
#define LTC3676_REG_BUCK2     0x02
#define LTC3676_REG_BUCK3     0x03
#define LTC3676_REG_BUCK4     0x04
#define LTC3676_REG_LDOA      0x05
#define LTC3676_REG_LDOB      0x06
#define LTC3676_REG_SQD1      0x07
#define LTC3676_REG_SQD2      0x08
#define LTC3676_REG_CNTRL     0x09
#define LTC3676_REG_DVB1A     0x0A
#define LTC3676_REG_DVB1B     0x0B
#define LTC3676_REG_DVB2A     0x0C
#define LTC3676_REG_DVB2B     0x0D
#define LTC3676_REG_DVB3A     0x0E
#define LTC3676_REG_DVB3B     0x0F
#define LTC3676_REG_DVB4A     0x10
#define LTC3676_REG_DVB4B     0x11
#define LTC3676_REG_MSKIRQ    0x12
#define LTC3676_REG_MSKPG     0x13
#define LTC3676_REG_USER      0x14
#define LTC3676_REG_IRQSTAT   0x15
#define LTC3676_REG_PGSTATL   0x16
#define LTC3676_REG_PGSTATRT  0x17
#define LTC3676_REG_HRST      0x1E
#define LTC3676_REG_CLIRQ     0x1F

#endif
