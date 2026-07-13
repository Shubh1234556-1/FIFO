`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 21:06:19
// Design Name: 
// Module Name: mod__b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mod__b(
    input clk, rst,
    input [7:0] data_in,
    input empty,                 // <-- new: FIFO status input
    output reg [7:0] data_out,
    output reg rd_enb
    );
    
    parameter idle       = 2'b00;
    parameter s1         = 2'b01;
    parameter data_state = 2'b10;
    
    reg [1:0] ps, ns;
    
    always @(posedge clk) begin
        if (rst)
            ps <= idle;
        else
            ps <= ns;
    end 
            
    always @(*) begin
        ns       = idle;
        rd_enb   = 1'b0;
        data_out = data_out;

        case(ps)
            idle: begin
                if (!empty) begin
                    ns     = s1;
                    rd_enb = 1'b1;   // only request a read if FIFO isn't empty
                end
                else begin
                    ns     = idle;   // stay here, keep waiting
                    rd_enb = 1'b0;
                end
            end
            s1: begin
                ns     = data_state;
                rd_enb = 1'b0;
            end
            data_state: begin
                ns       = idle;
                data_out = data_in;   // FIFO's registered read is valid now
            end
        endcase
    end
             
endmodule