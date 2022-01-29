`timescale 1ns / 1ps

module ram
# (parameter   DATA_WIDTH = 8, ADDR_WIDTH = 4) (
    input   logic   clk,
    input   logic   wr_en,
    input   logic [ADDR_WIDTH-1:0]  rd_addr,
    input   logic [ADDR_WIDTH-1:0]  wr_addr,  
    input   logic [DATA_WIDTH-1:0]  wr_data,
    output  logic [DATA_WIDTH-1:0]  rd_data       
    );
    
    logic [DATA_WIDTH-1:0]  mem_array [0:2**ADDR_WIDTH];
    
    always_ff@(posedge clk) 
        if(wr_en)
            mem_array[wr_addr] <= wr_data;
    
    assign rd_data = mem_array[rd_addr];
  
endmodule
