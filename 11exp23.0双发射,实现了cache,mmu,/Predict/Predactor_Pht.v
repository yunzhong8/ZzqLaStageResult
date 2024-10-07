`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/07 18:43:25
// Design Name: 
// Module Name: Predactor_Pht
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


module Predactor_Pht(
input wire rst_n,
input wire clk,

input wire we,
input wire [`ScountAddrWidth]waddr,
input wire [`ScountStateWidth]wdata,

output wire [`ScountAddrWidth]raddr,
output wire [`ScountStateWidth]rdata


    );
    
 pht_ram pht_ram_item (
  .clka(clk),    // input wire clka
  
  //饱和计数器写入
  .ena(1'b1),      // input wire ena
  .wea(we),      // input wire [0 : 0] wea
  .addra(waddr),  // input wire [9 : 0] addra
  .dina(wdata),    // input wire [2: 0] dina
  
  //饱和计数器读出
  .clkb(clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(raddr),  // input wire [9 : 0] addrb
  .doutb(rdata)  // output wire [2 : 0] doutb
);
   
 
endmodule
