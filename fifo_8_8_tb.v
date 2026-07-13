`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 22:51:28
// Design Name: 
// Module Name: fifo_8_8_tb
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


module fifo_8_8_tb();
    reg clk, rst;
    reg [7:0] data_in;
    wire [7:0] data_out;
    
    top__fifo dut (clk, rst, data_in, data_out);
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; data_in = 0;
        #12 rst = 0;         // release reset not exactly on an edge
        
        data_in = 5;  #20;
        data_in = 10; #20;
        data_in = 15; #20;
        data_in = 20; #20;
        
        #100;                 // give the pipeline time to drain
        $finish;
    end
    
    initial
        $monitor("t=%0t rst=%b data_in=%0d data_out=%0d", $time, rst, data_in, data_out);
        
endmodule