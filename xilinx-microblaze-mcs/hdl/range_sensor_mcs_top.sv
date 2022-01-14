`timescale 1ns / 1ps

module range_sensor_mcs_top(
    input logic CLK100MHZ,
    input logic CPU_RESETN,
    //external signals
    output logic [4:1] JA, // trigger pins
    input logic [4:1] JB // echo pins
    );
    
    logic [3:0] echo;
    logic [3:0] trig;
    
    assign echo = JB[4:1];
    
    range_sensor_mcs range_sensor_mcs_unit (
        .clk_i(CLK100MHZ),
        .rst_n_i(CPU_RESETN),
        //external
        .echo_i(echo),
        .trig_o(trig)      
    );
    
    assign JA[4:1] = trig;
 
endmodule
