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
module ID_EX(
    input  wire  clk      ,
    input  wire  rst_n    ,
    
    //控制本阶段id组合逻辑运算完的数据是否可以锁存起来，供给exe使用
    input wire id_to_ex_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
    input wire ex_allowin_i,//id组合逻辑传入，表示id阶段当前数据已经运算完了
     
    //id阶段的状态机
    output reg ex_valid_o,//输出下一个状态
    
    input wire [`PcInstBusWidth] pc_inst_ibus,
    input  wire [`IdToExBusWidth]id_to_ibus           ,
    output reg[`PcInstBusWidth] pc_inst_obus,
    output  reg [`IdToExBusWidth] to_ex_obus         
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
            to_ex_obus <=`IdToExBusLen'd0;  
            pc_inst_obus<=`PcInstBusLen'd0;
        end else if(id_to_ex_valid_i&& ex_allowin_i)begin//if id阶段完成计算即allowIn=1,并且if阶段打算流入数据即valid=1，则在时钟上升沿时候写入数据
            to_ex_obus <= id_to_ibus;
            pc_inst_obus<=pc_inst_ibus;
        end else begin//暂停流水
            to_ex_obus <= to_ex_obus;
            pc_inst_obus <= pc_inst_obus;
        end
    end
    
    always@(posedge clk)begin
        if(rst_n == `RstEnable)begin
            ex_valid_o <= 1'b0;
        end else if(ex_allowin_i)begin
            ex_valid_o <= id_to_ex_valid_i;
        end else begin
             ex_valid_o <= ex_valid_o;
        end
    end
    
endmodule
