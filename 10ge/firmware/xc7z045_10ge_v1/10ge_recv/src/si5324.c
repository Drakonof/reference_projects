/*
 * Copyright (C) 2013 - 2018 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */
/*****************************************************************************/
/**
* @file si5324.c
*
* This file programs si5324 chip which generates clock for the peripherals.
*
* Please refer to Si5324 Datasheet for more information
* http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5324.pdf
*
* Tested on Zynq ZC706 platform
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date	 Changes
* ----- ---- -------- ---------------------------------------------------------
* 1.0   srt  10/19/13 Initial Version
*
* </pre>
*
******************************************************************************/

#define ETH 0

/***************************** Include Files *********************************/
#include "xparameters.h"
#include "xil_printf.h"
#include "xiicps.h"
#include "sleep.h"
#include "xscugic.h"

#include "si5324.h"
/************************** Constant Definitions *****************************/
#define IIC_SLAVE_ADDR		0x68
#define IIC_MUX_ADDRESS		0x74
#define IIC_CHANNEL_ADDRESS	0x10

#define XIIC	XIicPs
#define INTC	XScuGic
/**************************** Type Definitions *******************************/
typedef struct SI324Info
{
	u32 RegIndex;	/* Register Number */
	u32 Value;		/* Value to be Written */
} SI324Info;

typedef struct {
	XIIC I2cInstance;
	INTC IntcInstance;
	volatile u8 TransmitComplete;   /* Flag to check completion of Transmission */
	volatile u8 ReceiveComplete;    /* Flag to check completion of Reception */
	volatile u32 TotalErrorCount;
} XIIC_LIB;
/************************** Function Prototypes *****************************/
int I2cWriteData(XIIC_LIB *I2cLibPtr, u8 *WrBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cReadData(XIIC_LIB *I2cLibPtr, u8 *RdBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cPhyWrite(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 Data, u16 SlaveAddr);
int I2cPhyRead(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 *Data, u16 SlaveAddr);
int I2cSetupHardware(XIIC_LIB *I2cLibPtr);
/************************* Global Definitions *****************************/
/*
 * These configuration values generates 125MHz clock
 * For more information please refer to Si5324 Datasheet.
 */

#if (ETH == 0)
SI324Info InitTable[] =
{
{  0, 0x54},
{  1, 0xE4},
{  2, 0x12},
{  3, 0x55},
{  4, 0x12},
{  5, 0xed},
{  6, 0x3f},
{  7, 0x2a},
{  8, 0x00},
{  9, 0xc0},
{ 10, 0x00},
{ 11, 0x40},
{ 19, 0x29},
{ 20, 0x3e},
{ 21, 0xfe},
{ 22, 0xdf},
{ 23, 0x1f},
{ 24, 0x3f},
{ 25, 0xa0},
{ 31, 0x00},
{ 32, 0x00},
{ 33, 0x03},
{ 34, 0x00},
{ 35, 0x00},
{ 36, 0x03},
{ 40, 0xc0},
{ 41, 0x92},
{ 42, 0x7b},
{ 43, 0x00},
{ 44, 0x1d},
{ 45, 0xc2},
{ 46, 0x00},
{ 47, 0x1d},
{ 48, 0xc2},
{ 55, 0x00},
{131, 0x1f},
{132, 0x02},
{137, 0x01},
{138, 0x0f},
{139, 0xff},
{142, 0x00},
{143, 0x00},
{136, 0x40}
};
#else
SI324Info InitTable[] =
{
{  0, 0x54},
{  1, 0xE4},
{  2, 0x12},
{  3, 0x15},
{  4, 0x92},
{  5, 0xED},
{  6, 0x2D},
{  7, 0x2A},
{  8, 0x00},
{  9, 0xC0},
{ 10, 0x00},
{ 11, 0x40},
{ 19, 0x29},
{ 20, 0x3E},
{ 21, 0xFF},
{ 22, 0xDF},
{ 23, 0x1F},
{ 24, 0x3F},
{ 25, 0x60},
{ 31, 0x00},
{ 32, 0x00},
{ 33, 0x03},
{ 34, 0x00},
{ 35, 0x00},
{ 36, 0x03},
{ 40, 0xC3},
{ 41, 0x13},
{ 42, 0x7F},
{ 43, 0x00},
{ 44, 0x4F},
{ 45, 0x1F},
{ 46, 0x00},
{ 47, 0xB2},
{ 48, 0x91},
{ 55, 0x00},
{131, 0x1F},
{132, 0x02},
{137, 0x01},
{138, 0x0F},
{139, 0xFF},
{142, 0x00},
{143, 0x00},
{136, 0x40}
};

/*
  0, 54h
  1, E4h
  2, 12h
  3, 15h
  4, 92h
  5, EDh
  6, 2Dh
  7, 2Ah
  8, 00h
  9, C0h
 10, 00h
 11, 40h
 19, 29h
 20, 3Eh
 21, FFh
 22, DFh
 23, 1Fh
 24, 3Fh
 25, 60h
 31, 00h
 32, 00h
 33, 03h
 34, 00h
 35, 00h
 36, 03h
 40, C2h
 41, 90h
 42, 3Fh
 43, 00h
 44, C3h
 45, 4Fh
 46, 00h
 47, 94h
 48, CEh
 55, 00h
131, 1Fh
132, 02h
137, 01h
138, 0Fh
139, FFh
142, 00h
143, 00h
136, 40h
*/
#endif


/************************** Function Definitions *****************************/
int MuxInit(XIIC_LIB *I2cLibInstancePtr)
{
	u8 WrBuffer[0];
	int Status;

	WrBuffer[0] = IIC_CHANNEL_ADDRESS;

	Status = I2cWriteData(I2cLibInstancePtr,
				WrBuffer, 1, IIC_MUX_ADDRESS);
	if (Status != XST_SUCCESS) {
		xil_printf("Si5324: Writing failed\n\r");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int ProgramSi5324(void)
{
	XIIC_LIB I2cLibInstance;
	int Index;
	int Status;
	u8 WrBuffer[2];

	Status = I2cSetupHardware(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("Si5324: Configuring HW failed\n\r");
		return XST_FAILURE;
	}

	Status = MuxInit(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("Si5324: Mux Init failed\n\r");
		return XST_FAILURE;
	}

	for (Index = 0; Index < sizeof(InitTable)/8; Index++) {
		WrBuffer[0] = InitTable[Index].RegIndex;
		WrBuffer[1] = InitTable[Index].Value;

		Status = I2cWriteData(&I2cLibInstance, WrBuffer, 2, IIC_SLAVE_ADDR);
		if (Status != XST_SUCCESS) {
			xil_printf("Si5324: Writing failed\n\r");
			return XST_FAILURE;
		}
	}
	return XST_SUCCESS;
}

