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
module IF(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input wire  inst_en_i,
    input  wire [`PcWidth]    pc_i           ,
    output reg inst_en_o,
    output reg  [`PcWidth]  pc_o
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
    always@(posedge clk)begin
        if(rst_n==`RstEnable)begin
            pc_o <= 32'h1bff_fffc;
            inst_en_o<=1'b0;
        end else begin
            inst_en_o<=inst_en_i;
            pc_o <= pc_i;
        end
    end
    
endmodule
