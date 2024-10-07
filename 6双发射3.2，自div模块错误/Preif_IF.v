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
`include "DefineModuleBus.h"
module Preif_IF(
    input  wire  clk      ,
    input  wire  rst_n    ,
    //握手
    input wire preif_to_if_valid_i,
    input wire if_allowin_i,
    output reg if_valid_o,
    //冲刷信号
    input wire excep_flush_i,
    
    //数据域
    input  wire [`PreifToIfBusWidth]    preif_to_ibus   ,
    
    
    output wire  [`PreifToIfBusWidth]  to_if_obus
);

/***************************************input variable define(输入变量定义)**************************************/
wire  [`PcWidth] pc1_i;
wire  [`PcWidth] pc2_i;
/***************************************output variable define(输出变量定义)**************************************/
reg  [`PcWidth]  pc1_o;
reg  [`PcWidth]  pc2_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/
assign {pc2_i,pc1_i} = preif_to_ibus;

/****************************************output code(输出解码)***************************************/
assign to_if_obus = {pc2_o,pc1_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
 //pc1
    always@(posedge clk)begin
        if(rst_n==`RstEnable)begin
            pc1_o <= `PcLen'h1bff_fffc;
            pc2_o <= `PcLen'h1c00_0000;
        end else if(preif_to_if_valid_i&& if_allowin_i)begin           
            pc1_o <= pc1_i;
            pc2_o <= pc2_i;
        end else begin        
            pc1_o <= pc1_o;
            pc2_o <= pc2_o;
        end
        
    end
     always@(posedge clk)begin
        if(rst_n == `RstEnable || excep_flush_i)begin
            if_valid_o <= 1'b0;
        end else if(if_allowin_i)begin
            if_valid_o <= preif_to_if_valid_i;
        end else begin
             if_valid_o <= if_valid_o;
        end
    end
    
endmodule
