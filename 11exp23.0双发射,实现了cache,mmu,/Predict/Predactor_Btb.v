`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/07 20:07:06
// Design Name: 
// Module Name: Predactor_Btb
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
// hit,和branch_pc要往下传递，方便id阶段返回修正btb表
//////////////////////////////////////////////////////////////////////////////////
`include "DefineLoogLenWidth.h"

module Predactor_Btb(
input wire rst_n,
input wire clk,

input wire pc_i,

input wire ww,
output wire hit_o,//1为命中，0为没有命中则使用pc+4
output wire [`PcWidth]btb_branch_pc
    );
    
 /***************************************input variable define(输入变量定义)**************************************/
wire [`BiaWidth]pc_tag_i;
wire [`BtbAddrWidth]btb_raddr_i;

wire [`BtbDataWidth]btb_rdata;

wire btb_waddr_i;
/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
wire we_i;

wire valid;
wire [`BiaWidth]bia;
wire [`PcWidth]btb_banch_pc;


/****************************************input decode(输入解码)***************************************/
assign {pc_tag_i,btb_raddr_i}=pc_i;
/****************************************input decode(输入解码)***************************************/

btb_ram btb_ram_item (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(we_i),      // input wire [0 : 0] wea
  .addra(waddr_i),  // input wire [6 : 0] addra
  .dina(wdata_i),    // input wire [43 : 0] dina
  
  .clkb(clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(btb_raddr_i),  // input wire [6 : 0] addrb
  .doutb(btb_rdata)  // output wire [43 : 0] doutb
);
//解压btb表读出数据
assign {valid,bia,btb_banch_pc_o}=btb_rdata;

//判断btb表示是否命中
assign hit_o=valid &&(bia==pc_tag_i)?1'b1:1'b0;


endmodule
