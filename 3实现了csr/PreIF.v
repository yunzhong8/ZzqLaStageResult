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
bug:因为没考虑if阶段的allow,导致气泡插入，把下一条指令的inst没有保存，丢失了
if if阶段不允许输入，则pre_if应该保持原值，保证isnt_ram的读出数据可以持续两个时钟周期，
\*************/
`include "DefineLoogLenWidth.h"
`include "DefineModuleBus.h"
module PreIF(
   
    input wire if_allowin_i,
    output preif_to_if_valid_o,

    input  wire  [`PcWidth]pc_i      ,
    input  wire [`IdToPreifBusWidth]  id_to_ibus,
    
   
    output wire  [`PcWidth]pc_o        
);

/***************************************input variable define(输入变量定义)**************************************/
    wire branch_flag_i;
    wire [`PcWidth]branch_pc_i;
/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/
assign {branch_flag_i,branch_pc_i} = id_to_ibus;

/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
assign pc_o = if_allowin_i?(branch_flag_i ? branch_pc_i : pc_i+32'd4) : pc_i;

assign preif_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
      
      assign preif_to_if_valid_o = preif_ready_go;//id阶段打算写入
endmodule
