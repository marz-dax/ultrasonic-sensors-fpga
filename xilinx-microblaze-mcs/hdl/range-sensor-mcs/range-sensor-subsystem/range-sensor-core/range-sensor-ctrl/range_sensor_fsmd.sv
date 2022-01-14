`timescale 1ns / 1ps

module range_sensor_fsmd
#(parameter PULSE_DUR = 32'd1_000, WAIT_DUR = 32'd2_320_000) (
    input logic clk_i, rst_i,
    input logic echo_i,
    input logic [4:0] req_cnt_i,
    output logic trig_o,
    output logic done_o, 
    output logic [31:0] t_dist_o,
    output logic [31:0] state
    );
    
    localparam WAIT_60MS = 32'd6000000;
    
    // fsm state type
    typedef enum {
        initial_state, 
        wait_low_state,
        wait_high_state, 
        pulse_state, 
        done_state,
        wait_60_state
    } state_type;
    
    // signal declaration
    state_type state_d, state_q;
    logic [31:0] cnt_d, cnt_q;
    logic [31:0] t_dist_d, t_dist_q;
    
    // state registers
    always_ff@(posedge  clk_i, posedge rst_i) 
    begin
        if (rst_i) 
        begin
            state_d <= initial_state;
            cnt_d <= 0;
            t_dist_d <= 0;
        end
        else
        begin
            state_d <= state_q;
            cnt_d <= cnt_q;
            t_dist_d <= t_dist_q;
        end
    end
    
    // next state logic
    always_comb 
    begin
        state_q = state_d;
        t_dist_q = t_dist_d;
        cnt_q = cnt_d;
        case (state_d)
            initial_state:
                if (req_cnt_i > 5'd0) 
                begin
                    cnt_q = PULSE_DUR;
                    t_dist_q = 0;
                    state_q = pulse_state;
                end
            pulse_state:
                if (cnt_d == 0) 
                begin
                    cnt_q = WAIT_DUR;
                    state_q = wait_low_state;
                end
                else
                    cnt_q = cnt_d - 32'd1;
            wait_low_state:
                if (echo_i == 0)
                    if(cnt_d == 0)
                    begin
                        t_dist_q = WAIT_DUR;
                        state_q = done_state;
                        cnt_q = PULSE_DUR; //STS
                    end
                    else
                        cnt_q = cnt_d - 32'd1;
                else
                    state_q = wait_high_state;
            wait_high_state: 
                if (echo_i == 1)
                    t_dist_q = t_dist_d + 1;
                else
                    state_q = done_state;  
            done_state:
                begin
                    cnt_q = WAIT_60MS;
                    state_q = wait_60_state; 
                end
            wait_60_state:
                    if (cnt_d == 0)
                        state_q = initial_state;
                    else
                        cnt_q = cnt_d - 1;
            default:
                state_q = initial_state; 
        endcase  
    end
    
    // moore outputs
    assign trig_o = (state_d == pulse_state);
    assign done_o = (state_d == done_state);
    assign t_dist_o = (state_d == done_state) ? t_dist_d: WAIT_DUR;
    
    assign state = state_d;
endmodule
