`timescale 1ns / 1ps

module fifo_fwft_ctrl 
# (parameter ADDR_WIDTH = 4) (
    input   logic   clk, rs,
    input   logic   rd, wr,
    output  logic [ADDR_WIDTH - 1: 0]  rd_addr,
    output  logic [ADDR_WIDTH - 1: 0]  wr_addr,
    output  logic  full, empty  
    );
    
    typedef enum {
        read, write, read_write, no_op
    } state_type;
    
    state_type  next_state, state;
    
    logic [ADDR_WIDTH - 1:0]    next_rd_ptr, rd_ptr; 
    logic [ADDR_WIDTH - 1:0]    next_wr_ptr, wr_ptr;
    logic next_full;
    logic next_empty;
    
    always_ff@(posedge clk, posedge rs) begin
        if(rs) begin
            state <= no_op;
            rd_ptr <= {ADDR_WIDTH{1'b0}};
            wr_ptr <= {ADDR_WIDTH{1'b0}};
            full <= 1'b0;
            empty <= 1'b1;
        end
        else begin
            state <= next_state;
            rd_ptr <= next_rd_ptr;
            wr_ptr <= next_wr_ptr;
            full <= next_full;
            empty <= next_empty;
        end
    end
    
    //data registers next state logic
    always_comb 
    begin
        next_rd_ptr = rd_ptr;
        next_wr_ptr = wr_ptr;
        next_full = full;
        next_empty = empty;
        case(state)
            read:           
            begin
                next_rd_ptr = rd_ptr + {{ADDR_WIDTH-1{1'b0}},1'b1};
                next_full = 1'b0;
                if(next_rd_ptr==wr_ptr) 
                    next_empty = 1'b1;
            end
            write:          
            begin
                next_wr_ptr = wr_ptr + {{ADDR_WIDTH-1{1'b0}},1'b1};
                next_empty = 1'b0;
                if(next_wr_ptr==rd_ptr) 
                    next_full = 1'b1;
            end
            read_write:     
            begin
                next_rd_ptr = rd_ptr + {{ADDR_WIDTH-1{1'b0}},1'b1};
                next_wr_ptr = wr_ptr + {{ADDR_WIDTH-1{1'b0}},1'b1};
            end
            no_op:;default:;        
        endcase
    end
    
    always_comb 
    begin
        case(state)
            no_op:      
            begin
                if((rd)&(~wr)) 
                    next_state = read;
                else 
                begin
                    if((~rd)&(wr)) 
                        next_state = write;
                    else 
                    begin
                        if((rd)&(wr)) 
                            next_state = read_write;
                        else 
                            next_state = no_op;
                    end
                end
            end
            default:   next_state = no_op;
        endcase
    end
    
    assign rd_addr = rd_ptr;
    assign wr_addr = wr_ptr;
    
endmodule
