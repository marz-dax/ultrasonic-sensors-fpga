#ifndef _RANGE_SENSOR_CORE_H
#define _RANGE_SENSOR_CORE_H

#include "io_rw.h"

#define PULSE_CNT 4 // number of pulses generated on trigger pin per gen_pulse() call

/*
 * RangeSensorCore class
 */
class RangeSensorCore {
private:
	uint32_t _base_addr; // core base address	
public:
	/**
	 * Register map
	 */
	enum {
		GEN_PULSE_REG = 0,
		DIST_REG = 1,
		FIFO_STATUS_REG = 2,
		REQ_CNT_REG = 3
	};
	uint32_t _data_arr[PULSE_CNT];
	/**
	 * Constructor
	 * @param base_addr slot base address
	 */
	RangeSensorCore(uint32_t base_addr);
	/**
	 * Generates 10us pulses on trigger pin
	 * @note the method does not block the program execution if pending_req_cnt <= 31
	 */
	void gen_pulse();
	/**
	 * Update _dist_time_arr[] with prior pulse widths on echo pin (in clock cycles)
	 */
	void rd_dist_ticks();
	/**
	 * Read the number of pending gen_pulse() request
	 */
	uint32_t rd_pending_req_cnt();
	/**
	 * Check FIFO's full status
	 * @return true if full else false
	 */
	bool is_fifo_full();
	/**
	 * Check FIFO's empty status
	 * @return true if empty else false
	 */
	bool is_fifo_empty();
};

#endif// _RANGE_SENSOR_CORE_H
