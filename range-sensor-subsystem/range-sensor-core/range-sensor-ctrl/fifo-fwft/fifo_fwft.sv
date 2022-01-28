`timescale 1ns / 1ps

module fifo_fwft
# (parameter  DATA_WIDTH = 8, ADDR_WIDTH = 4) (   
    input logic clk, rs,
    input logic rd, wr,
    input  logic [DATA_WIDTH-1:0]  wr_data,
    output  logic  full, empty,
    output  logic [DATA_WIDTH-1:0]  rd_data
    );
    
    logic [ADDR_WIDTH-1:0]  rd_addr, wr_addr;
    logic  wr_en;
    assign wr_en = (~full)&wr;
    fifo_fwft_ctrl  #(.ADDR_WIDTH(ADDR_WIDTH))  ctrl_unit(.*);
    ram  #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))  ram_unit(.*);
endmodule
