#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum hg_i2c_res {
	HG_I2C_RES_SUCCESS = 0,
	HG_I2C_RES_ERR_ADDR_NACK = -1,
	HG_I2C_RES_ERR_BUSSTATE = -2,
	HG_I2C_RES_ERR_BUSERR = -3,
	HG_I2C_RES_ERR_DATA_NACK = -4,
};

enum hg_i2c_res hg_i2c_write(uint8_t address, uint8_t *data, size_t len);

#define BUSSTATE_UNKNOWN 0
#define BUSSTATE_IDLE 1
#define BUSSTATE_OWNER 2
#define BUSSTATE_BUSY 3

#define HG_SERCOM SERCOM0
#define HG_SERCOM_APBCMASK PM_APBCMASK_SERCOM0
#define HG_I2C_GCLK GCLK_CLKCTRL_GEN_GCLK0
#define HG_I2C_GCLK_CLKCTRL_ID GCLK_CLKCTRL_ID_SERCOM0_CORE
#define HG_I2C_BAUD 400000								// bus speed (400k for fast)
#define HG_I2C_GCLK_FREQ 8000000						// master clock, 8MHz
#define HG_I2C_RISE_TIME 300							// rise time. Needs tweaks.