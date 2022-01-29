`timescale 1ns / 1ps

module bridge
#(parameter BRG_BASE = 32'hc0000000) (
    // processor bus
    input logic io_addr_strobe_i,
    input logic io_rd_strobe_i,
    input logic io_wr_strobe_i,
    input logic [3:0] io_byte_en_i,
    input logic [31:0] io_addr_i,
    input logic [31:0] io_wr_data_i,
    output logic [31:0] io_rd_data_o,
    output logic io_rdy_o,
    // subsystem bus
    output logic cs_o,
    output logic wr_o,
    output logic rd_o,
    output logic [4:0] addr_o,
    output logic [31:0] wr_data_o,
    input logic [31:0] rd_data_i
    );
    
    logic bridge_en;
    logic [29:0] word_addr;

    // address translation
    assign word_addr = io_addr_i[31:2];
    assign bridge_en = (io_addr_i[31:24] == BRG_BASE[31:24]);
    assign cs_o = bridge_en && (io_addr_i[23:7] == 0);
    assign addr_o = word_addr[4:0]; //2^5 => (2^2 sensors) + (2^3 registers per sensor)
    
    // control line conversation
    assign wr_o = io_wr_strobe_i;
    assign rd_o = io_rd_strobe_i;
    assign io_rdy_o = 1; // done in one clock
    
    // data line conversion 
    assign wr_data_o = io_wr_data_i;
    assign io_rd_data_o = rd_data_i;
endmodule