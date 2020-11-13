EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_SAMD:ATSAMD11D14A-M U1
U 1 1 5FAD2176
P 4400 4850
F 0 "U1" H 4500 5950 50  0000 C CNN
F 1 "ATSAMD11D14A-M" H 4800 5850 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-24-1EP_4x4mm_P0.5mm_EP2.6x2.6mm" H 4400 3500 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-42363-SAM-D11_Datasheet.pdf" H 4400 3850 50  0001 C CNN
	1    4400 4850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5FAD46E0
P 4200 3750
F 0 "#PWR0101" H 4200 3500 50  0001 C CNN
F 1 "GND" H 4205 3577 50  0000 C CNN
F 2 "" H 4200 3750 50  0001 C CNN
F 3 "" H 4200 3750 50  0001 C CNN
	1    4200 3750
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR0102
U 1 1 5FAD4A02
P 2050 3250
F 0 "#PWR0102" H 2050 3100 50  0001 C CNN
F 1 "VDD" H 2065 3423 50  0000 C CNN
F 2 "" H 2050 3250 50  0001 C CNN
F 3 "" H 2050 3250 50  0001 C CNN
	1    2050 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5FAD684C
P 4200 3600
F 0 "C4" H 4085 3554 50  0000 R CNN
F 1 "100nF" H 4085 3645 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4238 3450 50  0001 C CNN
F 3 "~" H 4200 3600 50  0001 C CNN
	1    4200 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5FAE03B8
P 4400 5850
F 0 "#PWR0103" H 4400 5600 50  0001 C CNN
F 1 "GND" H 4405 5677 50  0000 C CNN
F 2 "" H 4400 5850 50  0001 C CNN
F 3 "" H 4400 5850 50  0001 C CNN
	1    4400 5850
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR0104
U 1 1 5FAE421B
P 4200 3450
F 0 "#PWR0104" H 4200 3300 50  0001 C CNN
F 1 "VDD" H 4215 3623 50  0000 C CNN
F 2 "" H 4200 3450 50  0001 C CNN
F 3 "" H 4200 3450 50  0001 C CNN
	1    4200 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 3450 4400 3450
Wire Wire Line
	4400 3450 4400 3850
Connection ~ 4200 3450
Text GLabel 3800 4450 0    50   Input ~ 0
SWCLK
Text GLabel 3800 4550 0    50   Input ~ 0
SWDIO
Wire Wire Line
	3800 4550 3900 4550
Wire Wire Line
	3800 4450 3900 4450
Text GLabel 1950 5950 2    50   Input ~ 0
RST
$Comp
L Device:R R1
U 1 1 5FAF7E6A
P 1650 5800
F 0 "R1" H 1720 5846 50  0000 L CNN
F 1 "10k" H 1720 5755 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 1580 5800 50  0001 C CNN
F 3 "~" H 1650 5800 50  0001 C CNN
	1    1650 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 5950 1650 5950
$Comp
L Device:C C2
U 1 1 5FAF8D8B
P 1650 6100
F 0 "C2" H 1765 6146 50  0000 L CNN
F 1 "100nF" H 1765 6055 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 1688 5950 50  0001 C CNN
F 3 "~" H 1650 6100 50  0001 C CNN
	1    1650 6100
	1    0    0    -1  
$EndComp
Connection ~ 1650 5950
$Comp
L power:VDD #PWR0105
U 1 1 5FAFB065
P 1650 5650
F 0 "#PWR0105" H 1650 5500 50  0001 C CNN
F 1 "VDD" H 1665 5823 50  0000 C CNN
F 2 "" H 1650 5650 50  0001 C CNN
F 3 "" H 1650 5650 50  0001 C CNN
	1    1650 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5FAF9760
P 1650 6250
F 0 "#PWR0106" H 1650 6000 50  0001 C CNN
F 1 "GND" H 1655 6077 50  0000 C CNN
F 2 "" H 1650 6250 50  0001 C CNN
F 3 "" H 1650 6250 50  0001 C CNN
	1    1650 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 3250 2050 3250
Text GLabel 5050 5250 2    50   Input ~ 0
SDA_DAC
Wire Wire Line
	5050 5250 4900 5250
Text GLabel 5050 5350 2    50   Input ~ 0
SCL_DAC
Wire Wire Line
	5050 5350 4900 5350
Text GLabel 5050 4850 2    50   Input ~ 0
SDA_EXT
Text GLabel 5050 4950 2    50   Input ~ 0
SCL_EXT
Wire Wire Line
	5050 4850 4900 4850
Wire Wire Line
	5050 4950 4900 4950
Text Notes 7350 7500 0    50   ~ 0
Hargrove Analog / Digital Soft-Takeover
Text Notes 10100 7500 0    50   ~ 0
Designed by Tess Skye, CC0
Text Notes 10600 7650 0    50   ~ 0
0.1
$Comp
L Analog_DAC:MCP4728 U2
U 1 1 5FB47E6B
P 8700 4750
F 0 "U2" H 8800 5000 50  0000 C CNN
F 1 "MCP4728" H 9050 5000 50  0000 C CNN
F 2 "Package_SO:MSOP-10_3x3mm_P0.5mm" H 8700 4150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/22187E.pdf" H 8700 5000 50  0001 C CNN
	1    8700 4750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5FB47E71
P 8700 5150
F 0 "#PWR0107" H 8700 4900 50  0001 C CNN
F 1 "GND" H 8705 4977 50  0000 C CNN
F 2 "" H 8700 5150 50  0001 C CNN
F 3 "" H 8700 5150 50  0001 C CNN
	1    8700 5150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5FB47E77
P 8500 4300
F 0 "#PWR0108" H 8500 4050 50  0001 C CNN
F 1 "GND" H 8505 4127 50  0000 C CNN
F 2 "" H 8500 4300 50  0001 C CNN
F 3 "" H 8500 4300 50  0001 C CNN
	1    8500 4300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5FB47E7D
P 8500 4150
F 0 "C3" H 8700 4150 50  0000 R CNN
F 1 "100nF" H 8750 4250 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8538 4000 50  0001 C CNN
F 3 "~" H 8500 4150 50  0001 C CNN
	1    8500 4150
	-1   0    0    1   
$EndComp
Wire Wire Line
	8500 4000 8700 4000
Wire Wire Line
	8700 4000 8700 4450
Text GLabel 7350 4700 1    50   Input ~ 0
SDA_DAC
$Comp
L Device:R R2
U 1 1 5FB47E8D
P 7950 4500
F 0 "R2" H 8020 4546 50  0000 L CNN
F 1 "5k" H 8020 4455 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7880 4500 50  0001 C CNN
F 3 "~" H 7950 4500 50  0001 C CNN
	1    7950 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 4650 8100 4650
$Comp
L Device:R R3
U 1 1 5FB47E94
P 7500 4600
F 0 "R3" H 7570 4646 50  0000 L CNN
F 1 "5k" H 7570 4555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7430 4600 50  0001 C CNN
F 3 "~" H 7500 4600 50  0001 C CNN
	1    7500 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 4650 7950 4650
Connection ~ 7950 4650
$Comp
L power:VDD #PWR0109
U 1 1 5FB47E9C
P 7950 4350
F 0 "#PWR0109" H 7950 4200 50  0001 C CNN
F 1 "VDD" H 7965 4523 50  0000 C CNN
F 2 "" H 7950 4350 50  0001 C CNN
F 3 "" H 7950 4350 50  0001 C CNN
	1    7950 4350
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR0110
U 1 1 5FB47EA2
P 7500 4450
F 0 "#PWR0110" H 7500 4300 50  0001 C CNN
F 1 "VDD" H 7515 4623 50  0000 C CNN
F 2 "" H 7500 4450 50  0001 C CNN
F 3 "" H 7500 4450 50  0001 C CNN
	1    7500 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 4600 7800 4650
Text GLabel 7800 4600 1    50   Input ~ 0
SCL_DAC
Wire Wire Line
	7350 4700 7350 4750
Wire Wire Line
	7350 4750 7500 4750
Wire Wire Line
	7500 4750 8100 4750
Connection ~ 7500 4750
$Comp
L power:GND #PWR0111
U 1 1 5FB47EAE
P 7800 5100
F 0 "#PWR0111" H 7800 4850 50  0001 C CNN
F 1 "GND" H 7805 4927 50  0000 C CNN
F 2 "" H 7800 5100 50  0001 C CNN
F 3 "" H 7800 5100 50  0001 C CNN
	1    7800 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 5100 7800 4850
Wire Wire Line
	7800 4850 8100 4850
Wire Wire Line
	5050 4350 4900 4350
Wire Wire Line
	5050 4250 4900 4250
Wire Wire Line
	5050 4150 4900 4150
Wire Wire Line
	5050 4050 4900 4050
NoConn ~ 4900 5150
NoConn ~ 4900 5650
Text GLabel 5050 5450 2    50   Input ~ 0
SW_0
Text GLabel 5050 5550 2    50   Input ~ 0
SW_1
Text GLabel 5050 4650 2    50   Input ~ 0
SW_2
Text GLabel 5050 4750 2    50   Input ~ 0
SW_3
Wire Wire Line
	5050 5450 4900 5450
Wire Wire Line
	4900 5550 5050 5550
Wire Wire Line
	5050 4650 4900 4650
Wire Wire Line
	5050 4750 4900 4750
$Comp
L Analog_Switch:ADG734 U3
U 5 1 5FB1BAFD
P 9900 2100
F 0 "U3" H 10180 2146 50  0000 L CNN
F 1 "ADG734" H 10180 2055 50  0000 L CNN
F 2 "Package_SO:TSSOP-20_4.4x6.5mm_P0.65mm" H 9900 2100 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADG733_734.pdf" H 9900 2100 50  0001 C CNN
	5    9900 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 5FB3C1BD
P 9950 2600
F 0 "#PWR0112" H 9950 2350 50  0001 C CNN
F 1 "GND" H 9955 2427 50  0000 C CNN
F 2 "" H 9950 2600 50  0001 C CNN
F 3 "" H 9950 2600 50  0001 C CNN
	1    9950 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 2600 9950 2600
Connection ~ 9950 2600
Wire Wire Line
	9950 2600 10000 2600
$Comp
L power:VDD #PWR0113
U 1 1 5FB3F7CF
P 9900 1600
F 0 "#PWR0113" H 9900 1450 50  0001 C CNN
F 1 "VDD" H 9915 1773 50  0000 C CNN
F 2 "" H 9900 1600 50  0001 C CNN
F 3 "" H 9900 1600 50  0001 C CNN
	1    9900 1600
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG734 U3
U 4 1 5FBB998A
P 8500 2350
F 0 "U3" V 8546 2455 50  0000 L CNN
F 1 "ADG734" V 8455 2455 50  0000 L CNN
F 2 "Package_SO:TSSOP-20_4.4x6.5mm_P0.65mm" H 8500 2350 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADG733_734.pdf" H 8500 2350 50  0001 C CNN
	4    8500 2350
	0    -1   -1   0   
$EndComp
$Comp
L Analog_Switch:ADG734 U3
U 3 1 5FB62899
P 7500 1850
F 0 "U3" V 7546 1955 50  0000 L CNN
F 1 "ADG734" V 7455 1955 50  0000 L CNN
F 2 "Package_SO:TSSOP-20_4.4x6.5mm_P0.65mm" H 7500 1850 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADG733_734.pdf" H 7500 1850 50  0001 C CNN
	3    7500 1850
	0    -1   -1   0   
$EndComp
$Comp
L Analog_Switch:ADG734 U3
U 1 1 5FB4064C
P 5450 1850
F 0 "U3" V 5496 1955 50  0000 L CNN
F 1 "ADG734" V 5405 1955 50  0000 L CNN
F 2 "Package_SO:TSSOP-20_4.4x6.5mm_P0.65mm" H 5450 1850 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADG733_734.pdf" H 5450 1850 50  0001 C CNN
	1    5450 1850
	0    -1   -1   0   
$EndComp
$Comp
L Analog_Switch:ADG734 U3
U 2 1 5FB6022F
P 6400 2400
F 0 "U3" V 6446 2505 50  0000 L CNN
F 1 "ADG734" V 6355 2505 50  0000 L CNN
F 2 "Package_SO:TSSOP-20_4.4x6.5mm_P0.65mm" H 6400 2400 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADG733_734.pdf" H 6400 2400 50  0001 C CNN
	2    6400 2400
	0    -1   -1   0   
$EndComp
Text GLabel 5850 1850 2    50   Input ~ 0
SW_0
Text GLabel 6800 2400 2    50   Input ~ 0
SW_1
Text GLabel 7900 1850 2    50   Input ~ 0
SW_2
Text GLabel 8900 2350 2    50   Input ~ 0
SW_3
Text GLabel 9400 4750 2    50   Input ~ 0
DAC_1
Text GLabel 9400 4650 2    50   Input ~ 0
DAC_0
Text GLabel 9400 4850 2    50   Input ~ 0
DAC_2
Text GLabel 9400 4950 2    50   Input ~ 0
DAC_3
Wire Wire Line
	9400 4650 9300 4650
Wire Wire Line
	9300 4750 9400 4750
Wire Wire Line
	9400 4850 9300 4850
Wire Wire Line
	9300 4950 9400 4950
Text GLabel 6600 2100 1    50   Input ~ 0
DAC_1
Text GLabel 5650 1550 1    50   Input ~ 0
DAC_0
Text GLabel 7700 1550 1    50   Input ~ 0
DAC_2
Text GLabel 8700 2050 1    50   Input ~ 0
DAC_3
Text GLabel 5450 1550 1    50   Input ~ 0
IN_0
$Comp
L Device:C C1
U 1 1 5FC12197
P 2050 3400
F 0 "C1" H 2250 3400 50  0000 R CNN
F 1 "100nF" H 2300 3500 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2088 3250 50  0001 C CNN
F 3 "~" H 2050 3400 50  0001 C CNN
	1    2050 3400
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5FC128B1
P 2050 3550
F 0 "#PWR0114" H 2050 3300 50  0001 C CNN
F 1 "GND" H 2055 3377 50  0000 C CNN
F 2 "" H 2050 3550 50  0001 C CNN
F 3 "" H 2050 3550 50  0001 C CNN
	1    2050 3550
	1    0    0    -1  
$EndComp
Text GLabel 1800 3250 0    50   Input ~ 0
3v3
Text GLabel 1600 1300 2    50   Input ~ 0
3v3
Text GLabel 1600 1800 2    50   Input ~ 0
SDA_EXT
Text GLabel 1600 1900 2    50   Input ~ 0
SCL_EXT
Text GLabel 1600 1400 2    50   Input ~ 0
IN_0
Text GLabel 1600 1500 2    50   Input ~ 0
IN_1
Text GLabel 1600 1600 2    50   Input ~ 0
IN_2
Text GLabel 1600 1700 2    50   Input ~ 0
IN_3
Connection ~ 2050 3250
Text GLabel 6400 2100 1    50   Input ~ 0
IN_1
Text GLabel 7500 1550 1    50   Input ~ 0
IN_2
Text GLabel 8500 2050 1    50   Input ~ 0
IN_3
Text GLabel 5550 2150 3    50   Input ~ 0
OUT_0
Text GLabel 6500 2700 3    50   Input ~ 0
OUT_1
Text GLabel 7600 2150 3    50   Input ~ 0
OUT_2
Text GLabel 8600 2650 3    50   Input ~ 0
OUT_3
Text GLabel 5050 4050 2    50   Input ~ 0
IN_0
Text GLabel 5050 4150 2    50   Input ~ 0
IN_1
Text GLabel 5050 4250 2    50   Input ~ 0
IN_2
Text GLabel 5050 4350 2    50   Input ~ 0
IN_3
$Comp
L Connector:Conn_01x08_Male J1
U 1 1 5FCD95F9
P 1400 1500
F 0 "J1" H 1508 1981 50  0000 C CNN
F 1 "Conn_01x08_Male" H 1508 1890 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 1400 1500 50  0001 C CNN
F 3 "~" H 1400 1500 50  0001 C CNN
	1    1400 1500
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Male J2
U 1 1 5FCDB26E
P 2650 1500
F 0 "J2" H 2622 1382 50  0000 R CNN
F 1 "Conn_01x08_Male" H 2622 1473 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 2650 1500 50  0001 C CNN
F 3 "~" H 2650 1500 50  0001 C CNN
	1    2650 1500
	-1   0    0    -1  
$EndComp
Text GLabel 4650 1700 2    50   Input ~ 0
SWDIO
Text GLabel 4650 1600 2    50   Input ~ 0
SWCLK
Text GLabel 2450 1700 0    50   Input ~ 0
OUT_3
Text GLabel 2450 1600 0    50   Input ~ 0
OUT_2
Text GLabel 2450 1500 0    50   Input ~ 0
OUT_1
Text GLabel 2450 1400 0    50   Input ~ 0
OUT_0
Text GLabel 4650 1400 2    50   Input ~ 0
RST
Text GLabel 5050 5050 2    50   Input ~ 0
LAYER_SEL
Wire Wire Line
	5050 5050 4900 5050
$Comp
L power:VDD #PWR0115
U 1 1 5FD3FE3A
P 8500 4000
F 0 "#PWR0115" H 8500 3850 50  0001 C CNN
F 1 "VDD" H 8515 4173 50  0000 C CNN
F 2 "" H 8500 4000 50  0001 C CNN
F 3 "" H 8500 4000 50  0001 C CNN
	1    8500 4000
	1    0    0    -1  
$EndComp
Text GLabel 2450 1800 0    50   Input ~ 0
LAYER_SEL
NoConn ~ 8100 4950
NoConn ~ 4900 4450
NoConn ~ 4900 4550
Wire Wire Line
	3800 4250 3900 4250
Text GLabel 3800 4250 0    50   Input ~ 0
RST
Text GLabel 2300 2250 0    50   Input ~ 0
3v3
Text GLabel 1600 1200 2    50   Input ~ 0
GND
NoConn ~ 3900 4750
NoConn ~ 3900 4850
NoConn ~ 2450 1900
Text GLabel 2450 1300 0    50   Input ~ 0
3v3
Text GLabel 2450 1200 0    50   Input ~ 0
GND
NoConn ~ 4650 1800
NoConn ~ 4650 1900
$Comp
L power:GND #PWR?
U 1 1 5FE6A4A1
P 4150 2300
F 0 "#PWR?" H 4150 2050 50  0001 C CNN
F 1 "GND" H 4155 2127 50  0000 C CNN
F 2 "" H 4150 2300 50  0001 C CNN
F 3 "" H 4150 2300 50  0001 C CNN
	1    4150 2300
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_ARM_JTAG_SWD_10 J3
U 1 1 5FE64CB5
P 4150 1700
F 0 "J3" H 3707 1746 50  0000 R CNN
F 1 "Conn_ARM_JTAG_SWD_10" H 3707 1655 50  0000 R CNN
F 2 "Connector_PinHeader_1.27mm:PinHeader_2x05_P1.27mm_Vertical" H 4150 1700 50  0001 C CNN
F 3 "http://infocenter.arm.com/help/topic/com.arm.doc.ddi0314h/DDI0314H_coresight_components_trm.pdf" V 3800 450 50  0001 C CNN
	1    4150 1700
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR?
U 1 1 5FE73FCC
P 4150 1100
F 0 "#PWR?" H 4150 950 50  0001 C CNN
F 1 "VDD" H 4165 1273 50  0000 C CNN
F 2 "" H 4150 1100 50  0001 C CNN
F 3 "" H 4150 1100 50  0001 C CNN
	1    4150 1100
	1    0    0    -1  
$EndComp
NoConn ~ 4050 2300
$EndSCHEMATC
