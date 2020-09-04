//io_handler.c
#include "io_handler.h"
#include <stdio.h>

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
void IO_write(alt_u8 Address, alt_u16 Data)
{
	/* Based on the waveform from lecture for writing data from the FPGA. */
	*otg_hpi_address = Address;  // Set address to given parameter.
	*otg_hpi_cs = 0;  // Active low, chip select
	*otg_hpi_data = Data;  // Write data to the data bus.
	*otg_hpi_w = 0;  // Active low, toggle write enable

	/* Reset OTG control signals */
	*otg_hpi_w = 1;
	*otg_hpi_cs = 1;
}

//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;
	temp = *otg_hpi_data;

	/* Reset OTG control signals */
	*otg_hpi_r = 1;
	*otg_hpi_cs = 1;

	return temp;
}
