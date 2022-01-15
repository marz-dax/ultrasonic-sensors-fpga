# Ultrasonic Sensors FPGA Core
> 
> A portable core which controls up to 4 HC-SR04 ultrasonic distance sensors without blocking program execution while generating or capturing pulse widths.
> 
> The core interfaces with a 32-bit softcore processor through a bridge which translates the processor's read/write transactions to operations on the core.
> 
> Only a 5-bit word addressable space is required for the core.
> 
## Description 
> 
> ### Hardware
> The subsystem core provides 3 functional capabilities:
> > 
> > - Generate Pulse - generate successive pulses (up to 16) on the trigger pin of a selected HC-SR04 sensor.
> > 
> > - Capture Distance - capture pulse widths (up to 32) on the echo pins of all HC-SR04 sensors.
> > 
> > - Produce Distance - produce to the processor captured pulse widths.
> >
> ### Software
> Each HC-SR04 sensor is allocated an addressable slot on the subsystem core.
> 
> Software interacts with the hardware through a RangeSensorCore class with the following methods:
> ```cpp
> /**
> * Generates 10us pulses on trigger pin
> * @note the method does not block the program execution
> */
> void gen_pulse();
> /**
> * Update data structure with prior pulse widths on echo pin (in clock cycles)
> */
> void rd_dist_ticks();
> /**
> * Check FIFO's full status
> */
> bool is_fifo_full();
> /**
> * Check FIFO's empty status
> */
> bool is_fifo_empty();
> ```
>
## Visual
> 
> Sampled data from the trigger and echo pins of each HC-SR04 sensor.
> 
> ![image](xilinx-microblaze-mcs/images/wf.png)
> 
> The example.cpp instantiates 4 RangeSensorCore objects and each object calls gen_pulse() once. A pulse count of 4 is defined in range_sensor_core.h
> 
> ```cpp 
> RangeSensorCore sen0(get_slot_addr(BRIDGE_BASE, S0_RANGE_SENSOR));
> RangeSensorCore sen1(get_slot_addr(BRIDGE_BASE, S1_RANGE_SENSOR));
> RangeSensorCore sen2(get_slot_addr(BRIDGE_BASE, S2_RANGE_SENSOR));
> RangeSensorCore sen3(get_slot_addr(BRIDGE_BASE, S3_RANGE_SENSOR));
> 
> sen0.gen_pulse();
> sen1.gen_pulse();
> sen2.gen_pulse();
> sen3.gen_pulse();
> ```
> 
> ![image](xilinx-microblaze-mcs/images/wf_crop1.png)
> 
> The hardware captures the pulse widths on the echo pins of each HC-SR04 sensor 
> 
> ![image](xilinx-microblaze-mcs/images/wf_crop.png)
> 
> The example.cpp calls rd_dist_ticks() for each RangeSensorCore object which updates their _dist_arr member with the pulse widths.
> 
> ```cpp
> sen0.rd_dist_ticks();
> sen1.rd_dist_ticks();
> sen2.rd_dist_ticks();
> sen3.rd_dist_ticks();
> ```
>
> Below displays a memory snapshot of each RangeSensorCore object's _dist_arr member.
>
> ![image](xilinx-microblaze-mcs/images/mem_ss.png)
