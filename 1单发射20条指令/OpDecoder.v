/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*
*/
/*************\
bug:
\*************/
`include "DefineLoogLenWidth.h"
module OpDecoder(
    input  wire  [`InstWidth]inst_i     ,
    output wire  [`OdToIspBusWidth]to_isp_obus
    /*
    output  wire [63:0]      op_31_26_d_o  ,
    output  wire [15:0]      op_25_22_d_o  ,
    output  wire [3:0]       op_21_20_d_o  ,
    output  wire [31:0]      op_19_15_d_o
    */
);
/***************************************parameter define(常量定义)**************************************/

/***************************************variable define(变量定义)**************************************/

    wire [63:0]      op_31_26_d_o  ;
    wire [15:0]      op_25_22_d_o  ;
    wire [3:0]       op_21_20_d_o  ;
    wire [31:0]      op_19_15_d_o;
wire [ 5:0] op_31_26;
wire [ 3:0] op_25_22;
wire [ 1:0] op_21_20;
wire [ 4:0] op_19_15;
/*******************************complete logical function (逻辑功能实现)*******************************/
//截取op
assign op_31_26 = inst_i[31:26];
assign op_25_22 = inst_i[25:22];
assign op_21_20 = inst_i[21:0];
assign op_19_15 = inst_i[19:15];
//解码
decoder_6_64 u_dec0(.in(op_31_26 ), .out(op_31_26_d_o ));
decoder_4_16 u_dec1(.in(op_25_22 ), .out(op_25_22_d_o ));
decoder_2_4  u_dec2(.in(op_21_20 ), .out(op_21_20_d_o ));
decoder_5_32 u_dec3(.in(op_19_15 ), .out(op_19_15_d_o ));

 assign to_isp_obus={op_31_26_d_o,op_25_22_d_o,op_21_20_d_o,op_19_15_d_o,inst_i};
endmodule
