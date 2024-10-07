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
module EX_MEM(
    input  wire  clk      ,
    input  wire  rst_n    ,
    
    input wire  [`PcInstBusWidth]pc_inst_ibus,
    input  wire  [`ExToMemBusWidth]ex_to_ibus  ,
    output reg [`PcInstBusWidth]pc_inst_obus,
    output reg  [`ExToMemBusWidth]to_mem_obus       
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        to_mem_obus <= `ExToMemBusLen'd0;
        pc_inst_obus <= `PcInstBusLen'd0;
    end else begin
        pc_inst_obus <= pc_inst_ibus;
        to_mem_obus <= ex_to_ibus;
    end
end
endmodule
