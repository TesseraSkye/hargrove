#pragma once
#include "sam.h"
#include "hg_adc.h"
#include "hg_i2c.h"

#define HG_TOLERANCE 4
#define HG_CONTROL_NUM 4 //number of controls attached to the chip

//i2c

#define HG_I2C_SLAVE_ADDR 0x30							// address of reader