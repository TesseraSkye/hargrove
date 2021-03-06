#include "sam.h"
#include "hg_i2c.h"

void setupI2C(void) {


	// enable sercom peripheral bus mask
	PM->APBCMASK.reg |= HG_SERCOM_APBCMASK;

	//turn on gclk for sercom
	GCLK->CLKCTRL.reg = GCLK_CLKCTRL_CLKEN | HG_I2C_GCLK | HG_I2C_GCLK_CLKCTRL_ID;

	//wait for gclk sync
	while (GCLK->STATUS.bit.SYNCBUSY) {};

	//reset sercom
	HG_SERCOM->I2CM.CTRLA.bit.ENABLE = 0;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.ENABLE) {};
	HG_SERCOM->I2CM.CTRLA.bit.SWRST = 1;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.SWRST || HG_SERCOM->I2CM.SYNCBUSY.bit.ENABLE) {};

	//setup pin mux for i2c lines
	PORT->Group[0].PINCFG[14].reg |= PORT_PINCFG_PMUXEN;
	PORT->Group[0].PINCFG[15].reg |= PORT_PINCFG_PMUXEN;
	

	// set the mode for the I2C Pins
	PORT->Group[0].PMUX[14 >> 1].reg |= PORT_PMUX_PMUXE_C;
	PORT->Group[0].PMUX[15 >> 1].reg |= PORT_PMUX_PMUXO_C;


	//setup sercom - i2c stuff
	HG_SERCOM->I2CM.CTRLA.bit.SWRST = 1;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.SWRST || HG_SERCOM->I2CM.CTRLA.bit.SWRST) {};

	HG_SERCOM->I2CM.CTRLA.reg = SERCOM_I2CM_CTRLA_SPEED(0) |        // 0 is standard/fast mode 100 & 400kHz
	SERCOM_I2CM_CTRLA_SDAHOLD(0) |      // Hold SDA low for 300-600ns
	SERCOM_I2CM_CTRLA_MODE_I2C_MASTER;  // work as master

	//smart mode for autohandling of (n)ack and stuff
	HG_SERCOM->I2CM.CTRLB.reg = SERCOM_I2CM_CTRLB_SMEN | SERCOM_I2CM_CTRLB_QCEN;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.SYSOP) {};

	//set the baudrate with some clean code thx to arduino
	uint32_t baudrate = HG_I2C_BAUD;      // Hz
	uint32_t clock_speed = HG_I2C_GCLK_FREQ;  // Hz
	uint32_t rise_time = HG_I2C_RISE_TIME;    // ns
	HG_SERCOM->I2CM.BAUD.bit.BAUD =
	clock_speed / (2 * baudrate) - 5 - (((clock_speed / 1000000) * rise_time) / (2 * 1000));
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.SYSOP) {};

	//enable sercom
	HG_SERCOM->I2CM.CTRLA.bit.ENABLE = 1;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.ENABLE) {};

	//set bus to idle
	HG_SERCOM->I2CM.STATUS.bit.BUSSTATE = BUSSTATE_IDLE;
	while (HG_SERCOM->I2CM.SYNCBUSY.bit.SYSOP) {};
};

//create func for writing with i2c
enum hg_i2c_res hg_i2c_write(uint8_t address, uint8_t* data, size_t len) {
    /* Before trying to write, check to see if the bus is busy, if it is,
       bail.
    */
    if (HG_SERCOM->I2CM.STATUS.bit.BUSSTATE == BUSSTATE_BUSY) {
        return false;
    }

    /* Address + write flag. */
    HG_SERCOM->I2CM.ADDR.bit.ADDR = (address << 0x1ul) | 0;
    /* TODO: Consider a timeout here. */
    while (!HG_SERCOM->I2CM.INTFLAG.bit.MB) {};

    /* Check for loss of bus or NACK - in either case we can't continue. */
    if (HG_SERCOM->I2CM.STATUS.bit.BUSSTATE != BUSSTATE_OWNER) {
        return HG_I2C_RES_ERR_BUSSTATE;
    }
    if (HG_SERCOM->I2CM.STATUS.bit.RXNACK) {
        return HG_I2C_RES_ERR_ADDR_NACK;
    }

    /* Send data bytes. */
    for (size_t i = 0; i < len; i++) {
        /* Send data and wait for TX complete. */
        HG_SERCOM->I2CM.DATA.bit.DATA = data[i];

        while (!HG_SERCOM->I2CM.INTFLAG.bit.MB) {
            /* Check for loss of arbitration or a bus error. We can't continue if those happen. */
            /* BUSERR is set in addition to ARBLOST if arbitration is lost, so just check that one. */
            if (HG_SERCOM->I2CM.STATUS.bit.BUSERR) {
                return HG_I2C_RES_ERR_BUSERR;
            }
        }

        /* If a nack is received we can not continue sending data. */
        if (HG_SERCOM->I2CM.STATUS.bit.RXNACK) {
            return HG_I2C_RES_ERR_DATA_NACK;
        }
    }

    /* Send STOP command. */
    HG_SERCOM->I2CM.CTRLB.bit.CMD = 3;
    while (HG_SERCOM->I2CM.SYNCBUSY.bit.SYSOP) {};

    return HG_I2C_RES_SUCCESS;
};