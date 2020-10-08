#include "hg_i2c.h"

#include "sam.h"

//macro replacements

#define BUSSTATE_UNKNOWN 0
#define BUSSTATE_IDLE 1
#define BUSSTATE_OWNER 2
#define BUSSTATE_BUSY 3

#define HG_SERCOM SERCOM0
#define HG_SERCOM_APBCMASK PM_APBCMASK_SERCOM0
#define HG_I2C_GCLK GCLK_CLKCTRL_GEN_GCLK0
#define HG_I2C_GCLK_CLKCTRL_ID GCLK_CLKCTRL_ID_SERCOM0_CORE
#define HG_I2C_BAUD 400000								// bus speed (400k for fast)
#define HG_I2C_GCLK_FREQ 8000000						// master clock
#define HG_I2C_RISE_TIME 300							// rise time. Needs tweaks.
#define HG_I2C_SLAVE_ADDR 0x30							// address of reader

#define HG_ADC_NUM_SAMPS ADC_AVGCTRL_SAMPLENUM_8		// number of samps for better averaging (MAKE SURE TO UPDATE ADJRES) {Power of 2!}
#define HG_ADC_ADJRES ADC_AVGCTRL_ADJRES(3)				// compensate for the new sample number
#define HG_ADC_RESSEL ADC_CTRLB_RESSEL_16BIT			// has to be 16 bit if multiple samps are being taken
#define HG_ADC_PRESCALER_DIV ADC_CTRLB_PRESCALER_DIV4	// Prescaler on clock

#define HG_CTRL_TOLERANCE 5								// tolerance for CTRL CHANGE


//setup

void setupADC(void) {
  
	/* Enable the APB clock for the ADC. */
	PM->APBCMASK.reg |= PM_APBCMASK_ADC;
  
	/* Enable GCLK0 (48Mhz) for the ADC */
	GCLK->CLKCTRL.reg = GCLK_CLKCTRL_CLKEN |
                      GCLK_CLKCTRL_GEN_GCLK0 |
                      GCLK_CLKCTRL_ID_ADC;
  
	/* Wait for bus synchronization. */
	while (GCLK->STATUS.bit.SYNCBUSY) {};

	/* Reset the ADC. */
	ADC->CTRLA.bit.ENABLE = 0;
	while (ADC->STATUS.bit.SYNCBUSY) {};
	ADC->CTRLA.bit.SWRST = 1;
	while (ADC->CTRLA.bit.SWRST || ADC->STATUS.bit.SYNCBUSY) {};

  /* Load factory calibration. */
	uint32_t bias = (*((uint32_t *) ADC_FUSES_BIASCAL_ADDR) & ADC_FUSES_BIASCAL_Msk) >> ADC_FUSES_BIASCAL_Pos;
	uint32_t linearity = (*((uint32_t *) ADC_FUSES_LINEARITY_0_ADDR) & ADC_FUSES_LINEARITY_0_Msk) >> ADC_FUSES_LINEARITY_0_Pos;
	linearity |= ((*((uint32_t *) ADC_FUSES_LINEARITY_1_ADDR) & ADC_FUSES_LINEARITY_1_Msk) >> ADC_FUSES_LINEARITY_1_Pos) << 5;
  
  /* Wait for bus synchronization. */
	while (ADC->STATUS.bit.SYNCBUSY) {};
  
  /* Write the calibration data. */
	ADC->CALIB.reg = ADC_CALIB_BIAS_CAL(bias) | ADC_CALIB_LINEARITY_CAL(linearity);
  
  /* Wait for bus synchronization. */
	while (ADC->STATUS.bit.SYNCBUSY) {};
  
  /* Use the internal VCC reference. This is 1/2 of what's on VCCA.
     since VCCA is typically 3.3v, this is 1.65v.
  */
	ADC->REFCTRL.reg = ADC_REFCTRL_REFSEL_INTVCC1;
  

	ADC->AVGCTRL.reg = HG_ADC_NUM_SAMPS | HG_ADC_ADJRES; //tweak later for N/R if it's an issue
  
	// prescale div and resolution
	ADC->CTRLB.reg = HG_ADC_PRESCALER_DIV |
					HG_ADC_RESSEL;

  /* Configure the input parameters.
  
     - GAIN_DIV2 means that the input voltage is halved. This is important
       because the voltage reference is 1/2 of VCCA. So if you want to
       measure 0-3.3v, you need to halve the input as well.
  
     - MUXNEG_GND means that the ADC should compare the input value to GND.
  
     - MUXPOS_PIN2 means that the ADC should read from AIN2, or PB04.
       This is A2 on the Feather M0 board.
	*/
	ADC->INPUTCTRL.reg = 
		ADC_INPUTCTRL_GAIN_DIV2 |
		ADC_INPUTCTRL_MUXNEG_GND |
		ADC_INPUTCTRL_MUXPOS_PIN2;
	  
	//set sample time to change input impedance
	ADC->SAMPCTRL.reg = ADC_SAMPCTRL_SAMPLEN(1);
  
	/* Set  __ as an input pin. */
	PORT->Group[0].DIRCLR.reg = PORT_PA04;
  
	/* Enable the peripheral multiplexer for PB04. */
	PORT->Group[0].PINCFG[4].reg |= PORT_PINCFG_PMUXEN;
  
	/* Set PB04 to function B which is analog input. */
	PORT->Group[0].PMUX[4 >> 1].reg = PORT_PMUX_PMUXE_B;

  
	/* Wait for bus synchronization. */
	while (ADC->STATUS.bit.SYNCBUSY) {};
  
	/* Enable the ADC. */
	ADC->CTRLA.bit.ENABLE = 1;
};

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

//conv funcs

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

//func to read ADC
uint32_t readADC (void) {
	/* Wait for bus synchronization. */
	while (ADC->STATUS.bit.SYNCBUSY) {};
		
	/* Start the ADC using a software trigger. */
	ADC->SWTRIG.bit.START = 1;
		
	/* Wait for the result ready flag to be set. */
	while (ADC->INTFLAG.bit.RESRDY == 0);
		
	/* Clear the flag. */
	ADC->INTFLAG.reg = ADC_INTFLAG_RESRDY;
		
	/* Read the value. */
	return ADC->RESULT.reg;
}

void setup() {
	setupADC();
	setupI2C();
};

int main(void) {
	setup();
	
	while(1) {
		uint16_t res = readADC();
		uint16_t temp = readADC();
		int16_t tol = abs(res - temp); //signed so it actually works
		
		/*
		compare two readings. To reduce noise and bandwidth, they're measured against a threshold,
		and set to only emit i2c if larger than a specific amount.
		In principle, this reduces bitdepth quite a bit, and would cause sliding, but in practice it seems like there's enough noise that it doesn't matter.
		*/
		if (tol > HG_CTRL_TOLERANCE) {
			hg_i2c_write(HG_I2C_SLAVE_ADDR, &res, 2); // target address, data, length in bytes of payload
		}
		
	}
	
	};