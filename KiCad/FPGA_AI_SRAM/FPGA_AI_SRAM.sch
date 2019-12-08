EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "8 Mbit SRAM Breadboard Adapter"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x22_Male J1
U 1 1 5DEC4858
P 3800 2450
F 0 "J1" H 3908 3631 50  0000 C CNN
F 1 "Conn_01x22_Male" V 3700 3150 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x22_P2.54mm_Vertical" H 3800 2450 50  0001 C CNN
F 3 "~" H 3800 2450 50  0001 C CNN
	1    3800 2450
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x22_Male J2
U 1 1 5DECA18A
P 6550 2750
F 0 "J2" H 6522 2632 50  0000 R CNN
F 1 "Conn_01x22_Male" H 6522 2723 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x22_P2.54mm_Vertical" H 6550 2750 50  0001 C CNN
F 3 "~" H 6550 2750 50  0001 C CNN
	1    6550 2750
	-1   0    0    1   
$EndComp
$Comp
L Device:C C1
U 1 1 5DEDCBD4
P 5500 1250
F 0 "C1" V 5248 1250 50  0000 C CNN
F 1 "0.1uF" V 5339 1250 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5538 1100 50  0001 C CNN
F 3 "~" H 5500 1250 50  0001 C CNN
	1    5500 1250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5DF1A464
P 5100 4650
F 0 "#PWR0101" H 5100 4400 50  0001 C CNN
F 1 "GND" H 5105 4477 50  0000 C CNN
F 2 "" H 5100 4650 50  0001 C CNN
F 3 "" H 5100 4650 50  0001 C CNN
	1    5100 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 4650 5100 4650
Wire Wire Line
	5100 4650 5200 4650
Connection ~ 5100 4650
$Comp
L power:GND #PWR0102
U 1 1 5DF1ED31
P 5650 1300
F 0 "#PWR0102" H 5650 1050 50  0001 C CNN
F 1 "GND" H 5655 1127 50  0000 C CNN
F 2 "" H 5650 1300 50  0001 C CNN
F 3 "" H 5650 1300 50  0001 C CNN
	1    5650 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 1250 5650 1300
$Comp
L power:+3.3V #PWR0103
U 1 1 5DF21331
P 5100 1200
F 0 "#PWR0103" H 5100 1050 50  0001 C CNN
F 1 "+3.3V" H 5115 1373 50  0000 C CNN
F 2 "" H 5100 1200 50  0001 C CNN
F 3 "" H 5100 1200 50  0001 C CNN
	1    5100 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 1250 5350 1250
$Comp
L FPGA_AI_SRAM:CY62157 U1
U 1 1 5DEC2ACD
P 5100 2950
F 0 "U1" H 5100 4031 50  0000 C CNN
F 1 "CY62157" H 5100 3940 50  0000 C CNN
F 2 "Package_SO:TSOP-I-48_18.4x12mm_P0.5mm" H 5050 1750 50  0001 C CNN
F 3 "" H 4600 2400 50  0001 C CNN
	1    5100 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 1200 5100 1250
Connection ~ 5100 1250
Wire Wire Line
	4000 1450 4650 1450
Wire Wire Line
	4650 1550 4000 1550
Wire Wire Line
	4000 1650 4650 1650
Wire Wire Line
	4650 1750 4000 1750
Wire Wire Line
	4000 1850 4650 1850
Wire Wire Line
	4650 1950 4000 1950
Wire Wire Line
	4650 2050 4000 2050
Wire Wire Line
	4000 2150 4650 2150
Wire Wire Line
	4650 2250 4000 2250
Wire Wire Line
	4000 2350 4650 2350
Wire Wire Line
	4650 2450 4000 2450
Wire Wire Line
	4000 2550 4650 2550
Wire Wire Line
	4650 2650 4000 2650
Wire Wire Line
	4000 2750 4650 2750
Wire Wire Line
	4650 2850 4000 2850
Wire Wire Line
	4000 2950 4650 2950
Wire Wire Line
	4000 3050 4650 3050
Wire Wire Line
	4650 3150 4000 3150
Wire Wire Line
	4000 3250 4650 3250
Wire Wire Line
	4650 3350 4000 3350
Wire Wire Line
	4650 4450 4000 4450
Wire Wire Line
	4000 4450 4000 3550
Wire Wire Line
	4650 4350 4100 4350
Wire Wire Line
	4100 4350 4100 3450
Wire Wire Line
	4100 3450 4000 3450
Wire Wire Line
	5550 1650 6350 1650
Wire Wire Line
	6350 1750 5550 1750
Wire Wire Line
	5550 1850 6350 1850
Wire Wire Line
	6350 1950 5550 1950
Wire Wire Line
	5550 2050 6350 2050
Wire Wire Line
	6350 2150 5550 2150
Wire Wire Line
	5550 2250 6350 2250
Wire Wire Line
	6350 2350 5550 2350
Wire Wire Line
	5550 2450 6350 2450
Wire Wire Line
	6350 2550 5550 2550
Wire Wire Line
	5550 2650 6350 2650
Wire Wire Line
	6350 2750 5550 2750
Wire Wire Line
	5550 2850 6350 2850
Wire Wire Line
	6350 2950 5550 2950
Wire Wire Line
	5550 3050 6350 3050
Text GLabel 4600 3650 0    50   Input ~ 0
~WE
Text GLabel 4400 3750 0    50   Input ~ 0
~OE
Text GLabel 4600 3950 0    50   Input ~ 0
~BYTE
Text GLabel 4350 4050 0    50   Input ~ 0
~BHE
Text GLabel 4600 4150 0    50   Input ~ 0
~BLE
Text GLabel 6300 3150 0    50   Input ~ 0
~WE
Text GLabel 6050 3250 0    50   Input ~ 0
~OE
Text GLabel 6300 3350 0    50   Input ~ 0
~BYTE
Text GLabel 6050 3450 0    50   Input ~ 0
~BHE
Text GLabel 6300 3550 0    50   Input ~ 0
~BLE
$Comp
L power:GND #PWR0104
U 1 1 5DF45F96
P 6300 3750
F 0 "#PWR0104" H 6300 3500 50  0001 C CNN
F 1 "GND" H 6305 3577 50  0000 C CNN
F 2 "" H 6300 3750 50  0001 C CNN
F 3 "" H 6300 3750 50  0001 C CNN
	1    6300 3750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0105
U 1 1 5DF46338
P 5700 3650
F 0 "#PWR0105" H 5700 3500 50  0001 C CNN
F 1 "+3.3V" H 5715 3823 50  0000 C CNN
F 2 "" H 5700 3650 50  0001 C CNN
F 3 "" H 5700 3650 50  0001 C CNN
	1    5700 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 3150 6300 3150
Wire Wire Line
	6350 3250 6050 3250
Wire Wire Line
	6350 3350 6300 3350
Wire Wire Line
	6350 3450 6050 3450
Wire Wire Line
	6350 3550 6300 3550
Wire Wire Line
	6350 3650 5700 3650
Wire Wire Line
	6350 3750 6300 3750
Wire Wire Line
	4650 3650 4600 3650
Wire Wire Line
	4650 3750 4400 3750
Wire Wire Line
	4650 3950 4600 3950
Wire Wire Line
	4650 4050 4350 4050
Wire Wire Line
	4650 4150 4600 4150
Text Label 5950 1650 0    50   ~ 0
IO0
Text Label 5950 1750 0    50   ~ 0
I01
Text Label 5950 1850 0    50   ~ 0
IO2
Text Label 5950 1950 0    50   ~ 0
IO3
Text Label 5950 2050 0    50   ~ 0
IO4
Text Label 5950 2150 0    50   ~ 0
IO5
Text Label 5950 2250 0    50   ~ 0
IO6
Text Label 5950 2350 0    50   ~ 0
IO7
Text Label 5950 2450 0    50   ~ 0
IO8
Text Label 5950 2550 0    50   ~ 0
IO9
Text Label 5950 2650 0    50   ~ 0
IO10
Text Label 5950 2750 0    50   ~ 0
IO11
Text Label 5950 2850 0    50   ~ 0
IO12
Text Label 5950 2950 0    50   ~ 0
IO13
Text Label 5950 3050 0    50   ~ 0
IO14
Text Label 4350 4350 0    50   ~ 0
~CE1
Text Label 4350 4450 0    50   ~ 0
CE2
Text Label 4250 3350 0    50   ~ 0
A19-IO15
Text Label 4250 3250 0    50   ~ 0
A18
Text Label 4250 3150 0    50   ~ 0
A17
Text Label 4250 3050 0    50   ~ 0
A16
Text Label 4250 2950 0    50   ~ 0
A15
Text Label 4250 2850 0    50   ~ 0
A14
Text Label 4250 2750 0    50   ~ 0
A13
Text Label 4250 2650 0    50   ~ 0
A12
Text Label 4250 2550 0    50   ~ 0
A11
Text Label 4250 2450 0    50   ~ 0
A10
Text Label 4250 2350 0    50   ~ 0
A9
Text Label 4250 2250 0    50   ~ 0
A8
Text Label 4250 2150 0    50   ~ 0
A7
Text Label 4250 2050 0    50   ~ 0
A6
Text Label 4250 1950 0    50   ~ 0
A5
Text Label 4250 1850 0    50   ~ 0
A4
Text Label 4250 1750 0    50   ~ 0
A3
Text Label 4250 1650 0    50   ~ 0
A2
Text Label 4250 1550 0    50   ~ 0
A1
Text Label 4250 1450 0    50   ~ 0
A0
$EndSCHEMATC
