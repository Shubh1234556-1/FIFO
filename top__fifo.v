`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 21:20:23
// Design Name: 
// Module Name: top__fifo
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


module top__fifo(
    input clk, rst,
    input [7:0] data_top,
    output [7:0] data_out_top
    );
    
    wire [7:0] data_out_temp;
    wire wr_enb, rd_enb;
    wire full, empty;
    wire [7:0] data_out_fifo;
    
    mod_a mod1 (data_top, clk, rst, data_out_temp, wr_enb);
    fifo_8_8 fifo (clk, rst, wr_enb, rd_enb, data_out_temp, data_out_fifo, full, empty);
    mod__b mod2 (clk, rst, data_out_fifo,empty, data_out_top, rd_enb);
    
endmodule
