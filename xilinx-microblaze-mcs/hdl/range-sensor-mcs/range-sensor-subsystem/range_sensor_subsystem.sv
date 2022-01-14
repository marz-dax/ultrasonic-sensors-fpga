`timescale 1ns / 1ps

`include "range_sensor_map.svh"

module range_sensor_subsystem (
    input logic clk_i, 
    input logic rst_i,
    // subsystem bus
    input logic cs_i,
    input logic wr_i,
    input logic rd_i,
    input logic [4:0]  addr_i,
    input logic [31:0] wr_data_i,
    output logic [31:0] rd_data_o,
    // external signals
    output logic [3:0] trig_o,
    input logic [3:0] echo_i
    );
    
    // slot interface signals
    logic [3:0] cs_arr;
    logic [3:0] wr_arr;
    logic [3:0] rd_arr;
    logic [2:0]  addr_arr [3:0];
    logic [31:0] wr_data_arr [3:0];
    logic [31:0] rd_data_arr [3:0];
    // range sensor signals
    logic [3:0] trig, echo;
    
    // slot controller
    range_sensor_subsystem_ctrl ctrl_unit (
        // subsystem bus
        .cs_i(cs_i),
        .wr_i(wr_i),
        .rd_i(rd_i),
        .addr_i(addr_i),
        .wr_data_i(wr_data_i),
        .rd_data_o(rd_data_o),
        // slot interface signals
        .slot_cs_arr_o(cs_arr),
        .slot_wr_arr_o(wr_arr),
        .slot_rd_arr_o(rd_arr),
        .slot_addr_arr_o(addr_arr),
        .slot_wr_data_arr_o(wr_data_arr),
        .slot_rd_data_arr_i(rd_data_arr)
    );
    
    // range sensor core
    range_sensor_core range_sen0 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        // slot interface signals
        .cs_i(cs_arr[`S0_RANGE_SENSOR]),
        .wr_i(wr_arr[`S0_RANGE_SENSOR]), 
        .rd_i(rd_arr[`S0_RANGE_SENSOR]),
        .addr_i(addr_arr[`S0_RANGE_SENSOR]),
        .wr_data_i(wr_data_arr[`S0_RANGE_SENSOR]),
        .rd_data_o(rd_data_arr [`S0_RANGE_SENSOR]),
        // external port
        .trig_o(trig[0]),
        .echo_i(echo[0])
    ); 
    
    // range sensor core
    range_sensor_core range_sen1 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        // slot interface signals
        .cs_i(cs_arr[`S1_RANGE_SENSOR]),
        .wr_i(wr_arr[`S1_RANGE_SENSOR]), 
        .rd_i(rd_arr[`S1_RANGE_SENSOR]),
        .addr_i(addr_arr[`S1_RANGE_SENSOR]),
        .wr_data_i(wr_data_arr[`S1_RANGE_SENSOR]),
        .rd_data_o(rd_data_arr [`S1_RANGE_SENSOR]),
        // external port
        .trig_o(trig[1]),
        .echo_i(echo[1])
    ); 
    
    // range sensor core
    range_sensor_core range_sen2 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        // slot interface signals
        .cs_i(cs_arr[`S2_RANGE_SENSOR]),
        .wr_i(wr_arr[`S2_RANGE_SENSOR]), 
        .rd_i(rd_arr[`S2_RANGE_SENSOR]),
        .addr_i(addr_arr[`S2_RANGE_SENSOR]),
        .wr_data_i(wr_data_arr[`S2_RANGE_SENSOR]),
        .rd_data_o(rd_data_arr [`S2_RANGE_SENSOR]),
        // external port
        .trig_o(trig[2]),
        .echo_i(echo[2])
    ); 
    
    // range sensor core
    range_sensor_core range_sen3 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        // slot interface signals
        .cs_i(cs_arr[`S3_RANGE_SENSOR]),
        .wr_i(wr_arr[`S3_RANGE_SENSOR]), 
        .rd_i(rd_arr[`S3_RANGE_SENSOR]),
        .addr_i(addr_arr[`S3_RANGE_SENSOR]),
        .wr_data_i(wr_data_arr[`S3_RANGE_SENSOR]),
        .rd_data_o(rd_data_arr [`S3_RANGE_SENSOR]),
        // external port
        .trig_o(trig[3]),
        .echo_i(echo[3])
    ); 
    
    assign trig_o = trig;
    assign echo = echo_i;

endmodule
