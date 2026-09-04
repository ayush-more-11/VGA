`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 11:26:54
// Design Name: 
// Module Name: vga_tb
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


module vga_tb();
reg clk;
reg reset;

wire hsync;
wire vsync;
wire video_on;
wire p_tick;
wire [9:0] pixel_x;
wire [9:0] pixel_y;

vga uut(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .video_on(video_on),
    .p_tick(p_tick),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y)
);

// 50 MHz clock
always #10 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;

    #100;
    reset = 0;

    #20000000;

    $stop;
end

endmodule
