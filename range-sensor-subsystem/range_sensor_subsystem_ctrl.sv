`timescale 1ns / 1ps

module range_sensor_subsystem_ctrl (
    // subsystem bus 
    input logic cs_i,
    input logic wr_i,
    input logic rd_i,
    input logic [4:0]  addr_i,
    input logic [31:0] wr_data_i,
    output logic [31:0] rd_data_o,
    // slot interface signals
    output logic [3:0] slot_cs_arr_o,
    output logic [3:0] slot_wr_arr_o,
    output logic [3:0] slot_rd_arr_o,
    output logic [2:0]  slot_addr_arr_o [3:0],
    output logic [31:0] slot_wr_data_arr_o [3:0],
    input logic [31:0] slot_rd_data_arr_i [3:0]
    );
    
    logic [1:0] slot_addr;
    logic [2:0]  reg_addr;
    
    assign slot_addr = addr_i[4:3];
    assign reg_addr  = addr_i[2:0];

    //address decoding 
    always_comb
    begin
        slot_cs_arr_o = 0;
        if (cs_i)
            slot_cs_arr_o[slot_addr] = 1;
    end
    
    //multiplex slot signals
    generate 
        genvar i;
        for(i=0; i<4; i++)
        begin
            assign slot_wr_arr_o[i] = wr_i;
            assign slot_rd_arr_o[i] = rd_i;
            assign slot_addr_arr_o[i] = reg_addr;
            assign slot_wr_data_arr_o[i] = wr_data_i;
        end
    endgenerate
    
    // mux for selecting read data
    assign rd_data_o = slot_rd_data_arr_i[slot_addr];
    
endmodule
