#include <stdio.h>
#include <string.h>
#include "xil_printf.h"

#define MEM_CHECK_RANGE 1024U
#define MEM_BASE(x)     (* (uint8_t *) (XPAR_BRAM_0_BASEADDR + (x)))
#define MAKE_CHAR(x)    ((x) + 0x30)

int main()
{
    uint32_t i = 0;

    print("Push any key to display the memory.\n\r");

    outbyte(inbyte());
    print("\n\r");

    for (i = 0; i < MEM_CHECK_RANGE; i++) {
        outbyte(MAKE_CHAR(MEM_BASE(i)));

        if (0 == (i % 10)) {
            print("\n\r");
        }
	}
    print("\n\r\n\r");

    return 0;
}
