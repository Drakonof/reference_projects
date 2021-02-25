#include <stdio.h>

#include "lwip/ip_addr.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "lwip/priv/tcp_priv.h"
#include "netif/xadapter.h"
#include "lwip/err.h"
#include "lwip/udp.h"

#include "xil_cache.h"
#include "xil_printf.h"

#include "platform_.h"
#include "si5324.h"
#include "udp_1ge_client.h"

extern volatile int fast_transmit_flag;
extern volatile int slow_transmit_flag;

int main(void) {

    struct netif netif;
    memset(&netif, 0, sizeof(struct netif));

    xil_printf("\r\n\r\n");
    xil_printf("-----UDP Client Application-----\r\n");

    if (XST_SUCCESS != program_si5324()) {
    	xil_printf("Udp client ERROR: the si5324 configuring FAILED\r\n");
    	return XST_FAILURE;
    }

    init_platform();

    if (XST_SUCCESS != init_udp(&netif)) {
        xil_printf("Udp client ERROR: the UDP init FAILED\r\n");
        return XST_FAILURE;
    }

    if (ERR_OK != init_udp_transfer()) {
        xil_printf("Udp client ERROR: the UDP transfer initialization FAILED\r\n");
        return XST_FAILURE;
    }

    while (TRUE) {
       if (TRUE == fast_transmit_flag) {
            tcp_fasttmr();
            fast_transmit_flag = 0;
        }

        if (TRUE == slow_transmit_flag) {
            tcp_slowtmr();
            slow_transmit_flag = 0;
        }

        xemacif_input(&netif);
        transfer_udp_packet();
    }

    return XST_SUCCESS;
}
