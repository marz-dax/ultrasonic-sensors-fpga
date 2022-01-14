`timescale 1ns / 1ps

module range_sensor_ctrl(
    input logic clk_i, rst_i,
    input logic tick_i,
    input logic echo_i,
    input logic fifo_rd_i,
    output logic [4:0] req_cnt_o,
    output logic trig_o,
    output logic fifo_full_o, fifo_empty_o,
    output logic [31:0] fifo_rd_data_o
    );
    
     
    // fsmd signals
    logic done;
    logic [31:0] t_dist;
    // fifo signals
    logic full;
    logic empty;
    logic [31:0] rd_data;
    // counter signals 
    logic up, en;
    logic [4:0] req_cnt_q, req_cnt_d;
    
    // counter state register
    always_ff @(posedge clk_i, posedge rst_i)
        if (rst_i)
            req_cnt_q <= 0;
        else
            req_cnt_q <= req_cnt_d;
            
    // counter next state logic 
    always_comb
        if (en)
            if (up)
                req_cnt_d = req_cnt_q + 5'd1;
            else 
                req_cnt_d = req_cnt_q - 5'd1;
        else
            req_cnt_d = req_cnt_q;
            
    // fsmd
    range_sensor_fsmd fsmd (
        .clk_i(clk_i), 
        .rst_i(rst_i),
        .echo_i(echo_i),
        .req_cnt_i(req_cnt_q),
        .trig_o(trig_o),
        .done_o(done), 
        .t_dist_o(t_dist)
    );
    
    // fifo buffer
    fifo_fwft #(.DATA_WIDTH(32), .ADDR_WIDTH(5)) fifo (
        .clk(clk_i),
        .rs(rst_i),
        .rd(fifo_rd_i),
        .wr(done),
        .wr_data(t_dist),
        .full(fifo_full_o),
        .empty(fifo_empty_o),
        .rd_data(fifo_rd_data_o)     
    );
    
    assign req_cnt_o = req_cnt_q;
    assign up = tick_i;
    assign en = (tick_i ^ done);
    
endmodule
