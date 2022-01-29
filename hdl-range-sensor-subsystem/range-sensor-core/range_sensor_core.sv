`timescale 1ns / 1ps

module range_sensor_core(
    input logic clk_i,
    input logic rst_i,
    // slot interface
    input logic cs_i,
    input logic wr_i, 
    input logic rd_i,
    input logic [2:0] addr_i,
    input logic [31:0] wr_data_i,
    output logic [31:0] rd_data_o,
    // external signals
    output logic trig_o,
    input logic echo_i
    );
    
    /***********************************************************/    
    /* register r/w decoding logic   
    /**********************************************************/  
    logic [1:0] en;
    logic wr_en, rd_en;
    
    assign wr_en = cs_i & wr_i; 
    assign rd_en = cs_i & rd_i;
    
    assign en[0] = wr_en & (addr_i == 3'd0); // reg0 wr decoding logic
    assign en[1] = rd_en & (addr_i == 3'd1); // reg1 rd decoding logic
    /**********************************************************/ 
    
    /***********************************************************/    
    /* delay ff for fifo_rd_i port    
    /**********************************************************/  
    logic delay_q, delay_d;
    assign delay_q = en[1];
    
    always_ff @(posedge clk_i)
        if (rst_i)
            delay_d <= 0;
        else        
            delay_d <= delay_q;
    /**********************************************************/        
        
    /***********************************************************/    
    /* hrc-04 controller    
    /**********************************************************/    
    logic fifo_full, fifo_empty;
    logic [31:0] fifo_rd_data;
    logic [4:0] req_cnt;
    logic reg0_wr_tick;
    
    range_sensor_ctrl controller (
        .clk_i(clk_i), 
        .rst_i(rst_i),
        .tick_i(reg0_wr_tick),
        .echo_i(echo_i),
        .fifo_rd_i(delay_d),
        .req_cnt_o(req_cnt),
        .trig_o(trig_o),
        .fifo_full_o(fifo_full), 
        .fifo_empty_o(fifo_empty),
        .fifo_rd_data_o(fifo_rd_data)
    );
    
    assign reg0_wr_tick = en[0] & wr_data_i[0]; // tick for fifo wr port
    /***********************************************************/ 
    
    /***********************************************************/    
    /* read reg multiplexer    
    /**********************************************************/    
    always_comb
    begin
        case(addr_i[1:0])
            2'd1: rd_data_o = fifo_rd_data;
            2'd2: rd_data_o = {30'd0, fifo_full, fifo_empty};
            2'd3: rd_data_o = {27'd0, req_cnt};
            default: rd_data_o = 32'd0;  
        endcase
    end
    /***********************************************************/ 
    
    
    
     
endmodule
