/*
*作者：zzq
*创建时间：2023-04-06
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*
*/
/*************\
bug:
1. 由于excep_en的信号便于实现，所以新增不同例外的使能信号(pc_addr_error)，组合成excep_en信号
2. 取指令地址异常是pc[1:0]!=0,不是pc[31:30]!=0
\*************/
`include "DefineModuleBus.h"
module IF(
    input id_allowin_i,
    input if_valid_i,

    output if_allowin_o,
    output if_to_id_valid_o,
    input wire excep_flush_i,


    input  wire [`PiToIfBusWidth]pi_to_ibus,
    input wire  interrupt_en_i,
    input wire [`InstWidth]inst_i       ,
    
    output wire [`PcInstBusWidth]pc_inst_obus,
    output wire [`IfToIdBusWidth]to_ifid_obus
         
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/
wire [`ExceptionTypeWidth]excep_type_o;
wire excep_en_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
wire [`PcWidth]pc_i;
wire inst_en_i;
wire pc_addr_error;
/****************************************input decode(输入解码)***************************************/
assign  pc_i =pi_to_ibus;

/****************************************output code(输出解码)***************************************/

assign to_ifid_obus = {excep_en_o,excep_type_o};
assign pc_inst_obus={pc_i,inst_i};
/*******************************complete logical function (逻辑功能实现)*******************************/
assign pc_addr_error = pc_i[1:0]!= 2'b00 ? 1'b1:1'b0;
assign excep_en_o = (interrupt_en_i||pc_addr_error) && if_valid_i;//interrupt_en_i必须有初始化值，pc_addr_error必须有初始值
assign excep_type_o[`IntEcode] = interrupt_en_i ? 1'b1 : 1'b0;
assign excep_type_o[`AdefLocation-1:`IntEcode+1] = 5'h0;
assign excep_type_o[`AdefLocation]= pc_addr_error;
assign excep_type_o[`ErtnLocation:`AdefLocation+1] = 10'h0;//16-6
// 握手
      assign if_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
      assign if_allowin_o  = !if_valid_i //本级数据为空，允许if阶段写入
                           || (if_ready_go && id_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
      assign if_to_id_valid_o = if_valid_i && if_ready_go;//id阶段打算写入



endmodule
