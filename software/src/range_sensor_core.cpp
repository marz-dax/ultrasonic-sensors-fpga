#include "../inc/io_rw.h"
#include "../inc/range_sensor_core.h"

#define min(x,y) (x<y?x:y)
#define MAX_REQ_CNT 31

RangeSensorCore::RangeSensorCore(uint32_t base_addr)
:	_base_addr(base_addr)
{
}

void RangeSensorCore::gen_pulse() {

	for (int i = 0; i < PULSE_CNT; i++) {
		uint32_t pending_req_cnt = rd_pending_req_cnt();
		while (pending_req_cnt > MAX_REQ_CNT) {
			// blocks execution
			pending_req_cnt = rd_pending_req_cnt();
		}
		io_write(_base_addr, GEN_PULSE_REG, 1UL);
	}
	return;
}

void RangeSensorCore::rd_dist_ticks() {
	uint32_t pending_req_cnt = rd_pending_req_cnt();
	while (pending_req_cnt != 0) {
		// blocks program execution until hardware computes all prev req
		pending_req_cnt = rd_pending_req_cnt();
	}

	for (int i = 0; i < PULSE_CNT; i++) {
		uint32_t data = io_read(_base_addr, DIST_REG);
		_data_arr[i] = data;	}

}

uint32_t RangeSensorCore::rd_pending_req_cnt() {
	uint32_t data = 0;
	data = ~(0x000000ff) & io_read(_base_addr, REQ_CNT_REG);
	return data;
}

bool RangeSensorCore::is_fifo_full() {
	uint32_t status = io_read(_base_addr, FIFO_STATUS_REG);
	status = status & (0x00000002);
	status = status >> 1;
	if (status == 1UL) {
		return true;
	} else {
		return false;
	}
}

bool RangeSensorCore::is_fifo_empty() {
	uint32_t status = io_read(_base_addr, FIFO_STATUS_REG);
	status = status & (0x00000001);
	if (status == 1UL) {
		return true;
	} else {
		return false;
	}
}
