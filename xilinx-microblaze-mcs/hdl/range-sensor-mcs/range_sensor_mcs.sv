`timescale 1ns / 1ps

module range_sensor_mcs 
#(parameter BRG_BASE = 32'hc0000000) (
    input logic clk_i,
    input logic rst_n_i,
    //external signals
    input logic [3:0] echo_i,
    output logic [3:0] trig_o
    );
    
    logic rst;
    // mcs bus
    logic io_addr_strobe;
    logic io_rd_strobe;
    logic io_wr_strobe;
    logic [3:0] io_byte_en;
    logic [31:0] io_addr;
    logic [31:0] io_rd_data;
    logic [31:0] io_wr_data;
    logic io_rdy;
    // subsystem bus
    logic cs;
    logic wr;
    logic rd;
    logic [4:0] addr;
    logic [31:0] wr_data;
    logic [31:0] rd_data;
    // external signals
    logic [3:0] trig;
    logic [3:0] echo;
  
    assign rst = !rst_n_i;
    
    // mcs
    microblaze_mcs_0 cpu_unit (
        .Clk(clk_i),
        .Reset(rst),
        .IO_addr_strobe(io_addr_strobe),
        .IO_address(io_addr),
        .IO_byte_enable(io_byte_en),
        .IO_read_data(io_rd_data),
        .IO_read_strobe(io_rd_strobe),
        .IO_ready(io_rdy),
        .IO_write_data(io_wr_data),
        .IO_write_strobe(io_wr_strobe)
    );
    
    // subsystem bridge
    bridge #(.BRG_BASE(BRG_BASE)) bridge_unit (
        // mcs bus
        .io_addr_strobe_i(io_addr_strobe),
        .io_rd_strobe_i(io_rd_strobe),
        .io_wr_strobe_i(io_wr_strobe),
        .io_byte_en_i(io_byte_en),
        .io_addr_i(io_addr),
        .io_rd_data_o(io_rd_data),
        .io_wr_data_i(io_wr_data),
        .io_rdy_o(io_rdy),
        // subsystem bus
        .cs_o(cs),
        .wr_o(wr),
        .rd_o(rd),
        .addr_o(addr),
        .wr_data_o(wr_data),
        .rd_data_i(rd_data)
    );
    
    // subsystem
    range_sensor_subsystem subsystem_unit (
        .clk_i(clk_i), 
        .rst_i(rst),
        // subsystem bus
        .cs_i(cs),
        .wr_i(wr),
        .rd_i(rd),
        .addr_i(addr),
        .rd_data_o(rd_data),
        .wr_data_i(wr_data),
        // external signals
        .trig_o(trig),
        .echo_i(echo)
    );
    
    assign trig_o = trig;
    assign echo = echo_i;
endmodule