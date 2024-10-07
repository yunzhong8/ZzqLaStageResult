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
`include "DefineInstSign.h"
`include "DefineAluOp.h"
module IndetifyInstType(
    //input  wire [63:0] op_31_26_d_i_i;
    //input  wire [15:0] op_25_22_d_i_i;
    //input  wire [ 3:0] op_21_20_d_i_i;
    //input  wire [31:0] op_19_15_d_i;
    input  wire  [`OdToIspBusWidth]od_to_ibus,
    output  wire  [`SignWidth] inst_sign_o   ,
    output wire [`AluOpWidth] inst_aluop_o
);
/***************************************parameter define(常量定义)**************************************/

/***************************************variable define(变量定义)**************************************/
wire [63:0] op_31_26_d_i;
wire [15:0] op_25_22_d_i;
wire [ 3:0] op_21_20_d_i;
wire [31:0] op_19_15_d_i;
wire [`InstWidth]inst_i;

wire        inst_add_w;
wire        inst_sub_w;
wire        inst_slt;
wire        inst_sltu;
wire        inst_nor;
wire        inst_and;
wire        inst_or;
wire        inst_xor;
wire        inst_slli_w;
wire        inst_srli_w;
wire        inst_srai_w;
wire        inst_addi_w;
wire        inst_ld_w;
wire        inst_st_w;
wire        inst_jirl;
wire        inst_b;
wire        inst_bl;
wire        inst_beq;
wire        inst_bne;
wire        inst_lu12i_w;

/*******************************complete logical function (逻辑功能实现)*******************************/
assign {op_31_26_d_i,op_25_22_d_i,op_21_20_d_i,op_19_15_d_i,inst_i}=od_to_ibus;

assign inst_add_w  = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h00];
assign inst_sub_w  = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h02];
assign inst_slt    = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h04];
assign inst_sltu   = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h05];
assign inst_nor    = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h08];
assign inst_and    = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h09];
assign inst_or     = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h0a];
assign inst_xor    = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h0] & op_21_20_d_i[2'h1] & op_19_15_d_i[5'h0b];
assign inst_slli_w = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h1] & op_21_20_d_i[2'h0] & op_19_15_d_i[5'h01];
assign inst_srli_w = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h1] & op_21_20_d_i[2'h0] & op_19_15_d_i[5'h09];
assign inst_srai_w = op_31_26_d_i[6'h00] & op_25_22_d_i[4'h1] & op_21_20_d_i[2'h0] & op_19_15_d_i[5'h11];
assign inst_addi_w = op_31_26_d_i[6'h00] & op_25_22_d_i[4'ha];
assign inst_ld_w   = op_31_26_d_i[6'h0a] & op_25_22_d_i[4'h2];
assign inst_st_w   = op_31_26_d_i[6'h0a] & op_25_22_d_i[4'h6];
assign inst_jirl   = op_31_26_d_i[6'h13];
assign inst_b      = op_31_26_d_i[6'h14];
assign inst_bl     = op_31_26_d_i[6'h15];
assign inst_beq    = op_31_26_d_i[6'h16];
assign inst_bne    = op_31_26_d_i[6'h17];
assign inst_lu12i_w= op_31_26_d_i[6'h05] & ~inst_i[25];

    assign inst_sign_o =      inst_add_w ? `AddwInstSign   :
                              inst_sub_w ? `SubwInstSign   :
                              inst_slt   ? `SltInstSign    :
                              inst_sltu  ? `SltuInstSign   :
                              inst_nor   ? `NorInstSign    :
                              inst_and   ? `AndInstSign    :
                              inst_or    ? `OrInstSign     :
                              inst_xor   ? `XorInstSign    : 
                              inst_slli_w ? `SlliwInstSign :
                              inst_srli_w ? `SrliwInstSign :
                              inst_srai_w ? `SraiwInstSign :
                              inst_addi_w ?`AddiwInstSign  :
                              inst_ld_w ?`LdwInstSign      :
                              inst_st_w ? `StwInstSign     :
                              inst_jirl ? `JirlInstSign    :
                              inst_b ?`BInstSign           :
                              inst_bl ?`BlInstSign         :
                              inst_beq ?`BeqInstSign       :
                              inst_bne ?`BneInstSign       :
                              inst_lu12i_w ? `Lu12iwInstSign : `NoInstSign;

    assign inst_aluop_o =     inst_add_w ? `AddAluOp   :
                              inst_sub_w ? `SubAluOp   :
                              inst_slt   ? `SltAluOp    :
                              inst_sltu  ? `SltuAluOp   :
                              inst_nor   ? `NorAluOp    :
                              inst_and   ? `AndAluOp    :
                              inst_or    ? `OrAluOp     :
                              inst_xor   ? `XorAluOp    : 
                              inst_slli_w ? `SllAluOp :
                              inst_srli_w ? `SrlAluOp :
                              inst_srai_w ? `SraAluOp :
                              inst_addi_w ?`AddAluOp  :
                              inst_ld_w ?`AddAluOp    :
                              inst_st_w ? `AddAluOp     :
                              inst_jirl ? `NoAluOp    :
                              inst_b ?`NoAluOp          :
                              inst_bl ?`NoAluOp         :
                              inst_beq ?`NoAluOp       :
                              inst_bne ?`NoAluOp      :
                              inst_lu12i_w ? `LuiAluOp :`NoAluOp;


endmodule

