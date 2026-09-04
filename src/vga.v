`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 10:24:00
// Design Name: 
// Module Name: vga
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


module vga( input wire clk, reset,
            output wire hsync, vsync, video_on, p_tick,
            output wire [9:0] pixel_x, pixel_y
            );
            
    localparam HD = 640; 
    localparam HB = 16; //(right)
    localparam HR = 96; //retrace
    localparam HF = 48; // (left)
    

    localparam VD = 480;
    localparam VB = 33; // (bottom)
    localparam VR = 2; // retrace 
    localparam VF = 10; // (top)
    
    
    
/*localparam HD = 64;
localparam HF = 4;
localparam HB = 2;
localparam HR = 8;

localparam VD = 48;
localparam VF = 2;
localparam VB = 2;
localparam VR = 2;*/
    
    reg mod2_reg;
    wire mod2_next;
    
    // counter regiters, two each for buffering to avoid glitches 
    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;
    
    // output buffers 
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    
    wire h_end, v_end, pixel_tick;
    
    // register control
    always@(posedge clk, posedge reset)
        if(reset)
        begin
        mod2_reg <= 1'b0; 
        v_count_reg <= 0;
        h_count_reg <= 0;
        v_sync_reg <= 1'b0;
        h_sync_reg <= 1'b0;
        end
        
        else 
        begin 
            mod2_reg <= mod2_next;
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
        end
        
        assign mod2_next = ~mod2_reg; // mod2 ckt to generate 25MHz enb tick
        assign pixel_tick = mod2_reg;
        
        assign h_end = (h_count_reg == ( HD + HF + HB + HR - 1 )); // hmax
        assign v_end = (v_count_reg == ( VD + VF + VB + VR - 1)); // vmax
        
        always@*
            if(pixel_tick)
                if(h_end)
                    h_count_next = 0;
                 else 
                    h_count_next = h_count_reg + 1;
             else
                h_count_next = h_count_reg;
                
        always@*
            if(pixel_tick & h_end)
                if(v_end)
                    v_count_next = 0;
                 else
                    v_count_next = v_count_reg + 1;
             else 
                v_count_next = v_count_reg;
                
         assign h_sync_next = ( h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1) );
         assign v_sync_next = ( v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1) );
         
         assign video_on = ( h_count_reg < HD ) && ( v_count_reg < VD );
         
         assign hsync = h_sync_reg;
         assign vsync = v_sync_reg;
         assign pixel_x = h_count_reg;
         assign pixel_y = v_count_reg;
         assign p_tick = pixel_tick;
             
endmodule
