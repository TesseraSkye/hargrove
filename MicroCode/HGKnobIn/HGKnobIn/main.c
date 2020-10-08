#include <atmel_start.h>

int main(void)
{
	/* Initializes MCU, drivers and middleware */
	atmel_start_init();

	//int32_t adcInitStatus;
	//adcInitStatus = adc_sync_init(&ADC_0);


	uint8_t buffer[2];
	adc_sync_enable_channel(&ADC_0, 0);
	
	//if(adcInitStatus == adcInitStatus) {};
	
	while (1) {		
		
		adc_sync_read_channel(&ADC_0, 0, buffer, 2);
		  
		adc_sync_read_channel(&ADC_0, 0, buffer, 2);
		
		adc_sync_read_channel(&ADC_0, 0, buffer, 2);
	
	}
}