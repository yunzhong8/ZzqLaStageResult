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
module IF_ID(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input  wire [`PcWidth]pc_i          ,
    input  wire [`InstWidth] inst_i          ,

    output wire  [`PcInstBusWidth]pc_inst_obus          
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/
    reg [`PcWidth] pc_o;
    reg [`InstWidth]inst_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/
    assign pc_inst_obus = {pc_o,inst_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
always@(posedge clk)begin
    if(rst_n == `RstEnable)begin
        pc_o <= `ZeroWord32B;
        inst_o <= `ZeroWord32B;
    end else begin
        pc_o <= pc_i;
        inst_o <= inst_i;
    end
end

endmodule
