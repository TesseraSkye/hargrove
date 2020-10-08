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