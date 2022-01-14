#include "../inc/range_sensor_core.h"
#include "../inc/range_sensor_map.h"

RangeSensorCore sen0(get_slot_addr(BRIDGE_BASE, S0_RANGE_SENSOR));
RangeSensorCore sen1(get_slot_addr(BRIDGE_BASE, S1_RANGE_SENSOR));
RangeSensorCore sen2(get_slot_addr(BRIDGE_BASE, S2_RANGE_SENSOR));
RangeSensorCore sen3(get_slot_addr(BRIDGE_BASE, S3_RANGE_SENSOR));

int main() {

	while(1) {
		sen0.gen_pulse();
		sen1.gen_pulse();
		sen2.gen_pulse();
		sen3.gen_pulse();

		sen0.rd_dist_ticks();
		sen1.rd_dist_ticks();
		sen2.rd_dist_ticks();
		sen3.rd_dist_ticks();
	}
	return 0;
}
