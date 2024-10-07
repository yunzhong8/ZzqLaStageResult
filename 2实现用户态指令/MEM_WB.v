/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*ea块功能：
*
*/
/*************\
bug:
\*************/
`include "DefineLoogLenWidth.h"
module MEM_WB(
    input  wire  clk      ,
    input  wire  rst_n    ,
    
     //控制本阶段id组合逻辑运算完的数据是否可以锁存起来，供给exe使用
    input wire mem_to_wb_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
   
    
    //id阶段的状态机
    //input wire wb_allowin_i,//id组合逻辑传入，表示id阶段当前数据已经运算完了
    //output reg wb_valid_o,//输出下一个状态


    input  wire [`PcInstBusWidth]pc_inst_ibus           ,
    input  wire [`MemToWbBusWidth]mem_to_ibus          ,
    output reg [`PcInstBusWidth] pc_inst_obus         ,
    output reg [`MemToWbBusWidth] to_wb_obus   
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
            pc_inst_obus <= `PcInstBusLen'd0;
            to_wb_obus <= `MemToWbBusLen'd0;
        end else if(mem_to_wb_valid_i) begin
            pc_inst_obus <=pc_inst_ibus;
            to_wb_obus <= mem_to_ibus;
        end else begin
            pc_inst_obus <=pc_inst_obus;
            to_wb_obus <= to_wb_obus;
        end
    end
    
//    always@(posedge clk)begin
//        if(rst_n == `RstEnable)begin
//            wb_valid_o <= 1'b0;
//        end else if(wb_allowin_i)begin
//            wb_valid_o <= mem_to_wb_valid_i;
//        end else begin
//             wb_valid_o <= wb_valid_o;
//        end
//    end
endmodule
