#include "xstatus.h"

#include "si5324.h"

#include "platform_.h"
#include "axi_dma_intr_poll.h"

#define RX_BUFFER	            (uint32_t *) 0x01200000

#define RESET_TIMEOUT_CNTR_VAL	0x1000
#define MAX_TX_VALUE	        0x100
#define PAYLOAD_SIZE	        MAX_TX_VALUE

volatile _Bool tx_done_flag, rx_done_flag, tx_error, rx_error;

axi_dma_init_str init;
axi_dma_poll_str dev_to_dma_poll;
axi_dma_handler_str handler;

static void tx_intr_handler(void *callback);
static void rx_intr_handler(void *callback);

int main(void) {

	ProgramSi5324();

	memset((uint8_t *) RX_BUFFER,0,0x100);

	init.dma_id = XPAR_AXIDMA_0_DEVICE_ID;
	init.rx_intr_handler = rx_intr_handler;
	init.tx_intr_handler = tx_intr_handler;
	init.rx_intr_id = XPAR_FABRIC_AXIDMA_0_S2MM_INTROUT_VEC_ID;
	init.tx_intr_id = 0;

	dev_to_dma_poll.p_buf = RX_BUFFER;
	dev_to_dma_poll.size = PAYLOAD_SIZE;

	axi_dma_init(&init, &handler);
	axi_dma_dev_to_dma_poll(&dev_to_dma_poll, &handler.axi_dma, init.dma_id);

	while (1) {
		if (TRUE == rx_done_flag) {

			Xil_DCacheFlushRange((UINTPTR) (dev_to_dma_poll.p_buf), dev_to_dma_poll.size);
			Xil_DCacheInvalidateRange((UINTPTR) (dev_to_dma_poll.p_buf), dev_to_dma_poll.size);

			rx_done_flag = FALSE;
			axi_dma_dev_to_dma_poll(&dev_to_dma_poll, &handler.axi_dma, init.dma_id);
		}
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
