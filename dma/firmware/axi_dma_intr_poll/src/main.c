#include "xstatus.h"

#include "platform_.h"
#include "axi_dma_intr_poll.h"

#define TX_BUFFER		        (uint32_t *) 0x01100000
#define RX_BUFFER	            (uint32_t *) XPAR_BRAM_0_BASEADDR

#define RESET_TIMEOUT_CNTR_VAL	0x1000
#define MAX_TX_VALUE	        0x100
#define PAYLOAD_SIZE	        MAX_TX_VALUE

volatile _Bool tx_done_flag, rx_done_flag, tx_error, rx_error;

axi_dma_init_str init;
axi_dma_poll_str poll;
axi_dma_handler_str handler;

static void tx_intr_handler(void *callback);
static void rx_intr_handler(void *callback);

static inline void printf_array(uint32_t *p_array, size_t size);

int main(void) {

	uint8_t mul_coefficient = 0;
	const uint8_t c_ascii_num_offset = 0x30;
	uint32_t i = 0;

	memset((uint8_t *) XPAR_BRAM_0_BASEADDR,0,0x100);

	init.dma_id = XPAR_AXIDMA_0_DEVICE_ID;
	init.rx_intr_handler = rx_intr_handler;
	init.tx_intr_handler = tx_intr_handler;
	init.rx_intr_id = XPAR_FABRIC_AXIDMA_0_S2MM_INTROUT_VEC_ID;
	init.tx_intr_id = XPAR_FABRIC_AXIDMA_0_MM2S_INTROUT_VEC_ID;

	poll.p_tx_buf = TX_BUFFER;
	poll.p_rx_buf = RX_BUFFER;
	poll.size = PAYLOAD_SIZE;

	axi_dma_init(&init, &handler);

	while(1) {
		xil_printf("AXI DMA %d: ready. Insert multiplier coefficient (1 - 9): ", init.dma_id);

		mul_coefficient = inbyte();
		mul_coefficient -= c_ascii_num_offset;

		if ((0 == mul_coefficient) || (mul_coefficient > 9)) {
			xil_printf("\n\rAXI DMA %d ERROR: the coefficient must have a value from 1 to 9\n\r", init.dma_id);
			continue;
		}

		xil_printf("%d\n\r", mul_coefficient);


	    for(i = 0; i < MAX_TX_VALUE; i++) {
		    poll.p_tx_buf[i] = (i * mul_coefficient) % MAX_TX_VALUE;
	    }

	    tx_done_flag = FALSE;
	    rx_done_flag = FALSE;

	    axi_dma_poll(&poll, &handler.axi_dma, init.dma_id);

	    xil_printf("AXI DMA %d: waiting completion of the poll...", init.dma_id);

	    while((FALSE == tx_done_flag) || (FALSE == rx_done_flag)) {
	    	asm("NOP");
	    }

		if ((TRUE == tx_error) || (TRUE == rx_error)) {
			xil_printf("AXI DMA %d ERROR: the polling ERROR", init.dma_id);
		}
		else {
			xil_printf("\n\n\rAXI DMA %d: the tx buffer:\n\r", init.dma_id);
			printf_array(TX_BUFFER ,PAYLOAD_SIZE);

			xil_printf("\n\n\rAXI DMA %d: the rx buffer:\n\r", init.dma_id);
			printf_array(RX_BUFFER, PAYLOAD_SIZE);
		}

		xil_printf("\n\n\r");
	}

	return XST_SUCCESS;
}

static void tx_intr_handler(void *callback) {

	uint32_t status = 0;
	int reset_cntr = RESET_TIMEOUT_CNTR_VAL;
	XAxiDma *axi_dma = (XAxiDma *) callback;

	status = XAxiDma_IntrGetIrq(axi_dma, XAXIDMA_DMA_TO_DEVICE);

	XAxiDma_IntrAckIrq(axi_dma, status, XAXIDMA_DMA_TO_DEVICE);

	tx_done_flag = TRUE;

	if (FALSE != (status & XAXIDMA_IRQ_ALL_MASK) &&
	   (TRUE == (status & XAXIDMA_IRQ_ERROR_MASK))) {
	    tx_error = TRUE;
		XAxiDma_Reset(axi_dma);

		while (reset_cntr--) {
			if (XAxiDma_ResetIsDone(axi_dma)) {
				break;
			}

		}
	}
}


static void rx_intr_handler(void *callback)
{
	uint32_t status = 0;
	int reset_cntr = RESET_TIMEOUT_CNTR_VAL;
	XAxiDma *axi_dma = (XAxiDma *) callback;

	status = XAxiDma_IntrGetIrq(axi_dma, XAXIDMA_DEVICE_TO_DMA);

	XAxiDma_IntrAckIrq(axi_dma, status, XAXIDMA_DEVICE_TO_DMA);

	rx_done_flag = TRUE;

	if ((FALSE != (status & XAXIDMA_IRQ_ALL_MASK)) &&
	   (TRUE == (status & XAXIDMA_IRQ_ERROR_MASK))) {
		rx_error = TRUE;
		XAxiDma_Reset(axi_dma);

		while (reset_cntr--) {
			if (XAxiDma_ResetIsDone(axi_dma)) {
				break;
			}
		}
	}
}

static inline void printf_array(uint32_t *p_array, size_t size) {
	const uint8_t c_values_per_line = 10;
	uint32_t i = 0;

	for(i = 0; i < size; i++) {
		xil_printf("%d ", *(TX_BUFFER + i));

		if (FALSE == (i % c_values_per_line) && (0 != i)) {
			xil_printf("\n\r");
		}
	}
}
