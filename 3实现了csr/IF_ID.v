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
module IF_ID(
    input  wire  clk      ,
    input  wire  rst_n    ,
    
     //控制本阶段id组合逻辑运算完的数据是否可以锁存起来，供给exe使用
    input wire if_to_id_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
    input wire id_flush_i,//冲刷流水信号
   
    
    //id阶段的状态机
    input wire id_allowin_i,//id组合逻辑传入，表示id阶段当前数据已经运算完了
    output reg id_valid_o,//输出下一个状态

    input  wire [`PcInstBusWidth] pc_inst_ibus,
    output wire  [`PcInstBusWidth]pc_inst_obus          
);

/***************************************input variable define(输入变量定义)**************************************/
wire [`PcWidth] pc_i;
wire [`InstWidth]inst_i;
/***************************************output variable define(输出变量定义)**************************************/
 reg [`PcWidth] pc_o;
 reg [`InstWidth]inst_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/
assign {pc_i,inst_i} = pc_inst_ibus;

/****************************************output code(输出解码)***************************************/
    assign pc_inst_obus = {pc_o,inst_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
always@(posedge clk)begin
    if(rst_n == `RstEnable)begin
        pc_o <= `ZeroWord32B;
        inst_o <= `ZeroWord32B;
    end else if(if_to_id_valid_i&& id_allowin_i) begin//if id阶段完成计算即allowIn=1,并且if阶段打算流入数据即valid=1，则在时钟上升沿时候写入数据
        pc_o <= pc_i;
        inst_o <= inst_i;
    end else begin//暂停流水
            pc_o <= pc_o;
        inst_o <= inst_o;
        end
end

 always@(posedge clk)begin
        if(rst_n == `RstEnable || id_flush_i )begin
            id_valid_o <= 1'b0;
        end else if(id_allowin_i)begin
            id_valid_o <= if_to_id_valid_i;
        end else begin
             id_valid_o <= id_valid_o;
        end
    end

endmodule
