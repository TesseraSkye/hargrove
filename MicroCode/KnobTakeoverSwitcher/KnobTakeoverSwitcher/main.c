/* 
Created by Tessera Skye. 
Massive thanks to Thea "Stargirl" at Winterbloom for all her help.
Much of her amazing work can be found at https://github.com/theacodes/
and on her website at https://thea.codes/
*/

#include "sam.h"

#include "hg_takeover.h"



int main(void)
{
    /* Initialize the SAM system */
    SystemInit();
	
	//user init
	setupADC();
	setupI2C();

    /* Replace with your application code */
    while (1) 
    {
		//
		uint8_t isLayerActive = 0;
    }
}
