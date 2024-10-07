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
\*************/
`include "DefineLoogLenWidth.h"
module IF(
    input id_allowin_i,
    input if_valid_i,

    output if_allowin_o,
    output if_to_id_valid_o,


    input  wire [`PiToIfBusWidth]pi_to_ibus,
    
    input wire [`InstWidth]inst_i       ,
    
    output wire [`IfToIdBusWidth]to_ifid_obus
         
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
wire [`PcWidth]pc_i;
wire inst_en_i;
/****************************************input decode(输入解码)***************************************/
assign  pc_i =pi_to_ibus;

/****************************************output code(输出解码)***************************************/

assign to_ifid_obus ={pc_i,inst_i};
/*******************************complete logical function (逻辑功能实现)*******************************/

// 握手
      assign if_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
      assign if_allowin_o  = !if_valid_i //本级数据为空，允许if阶段写入
                           || (if_ready_go && id_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
      assign if_to_id_valid_o = if_valid_i && if_ready_go;//id阶段打算写入



endmodule
