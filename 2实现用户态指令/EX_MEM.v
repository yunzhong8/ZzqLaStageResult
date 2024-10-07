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
    
      //控制本阶段id组合逻辑运算完的数据是否可以锁存起来，供给exe使用
    input wire ex_to_mem_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
   
    
    //id阶段的状态机
    input wire mem_allowin_i,//id组合逻辑传入，表示id阶段当前数据已经运算完了
    output reg mem_valid_o,//输出下一个状态
    
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
    end else if(ex_to_mem_valid_i&& mem_allowin_i) begin
        pc_inst_obus <= pc_inst_ibus;
        to_mem_obus <= ex_to_ibus;
    end else begin
        pc_inst_obus <= pc_inst_obus;
        to_mem_obus <= to_mem_obus;
    end
end

always@(posedge clk)begin
        if(rst_n == `RstEnable)begin
            mem_valid_o <= 1'b0;
        end else if(mem_allowin_i)begin
            mem_valid_o <= ex_to_mem_valid_i;
        end else begin
             mem_valid_o <= mem_valid_o;
        end
    end
endmodule
