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
1. 因为没考虑if阶段的allow,导致气泡插入，把下一条指令的inst没有保存，丢失了
2. if if阶段不允许输入，则pre_if应该保持原值，保证isnt_ram的读出数据可以持续两个时钟周期，
3. 例外使能信号和地址信号顺序反了，拼接错误
\*************/
`include "DefineLoogLenWidth.h"
`include "DefineModuleBus.h"
module PreIF(
   
    input wire next_allowin_i,
    output now_to_next_valid_o,

    input  wire  [`IfToPreifBusWidth]if_to_ibus  ,
    //跳转
    input  wire [`IdToPreifBusWidth]  id_to_ibus,
    
    //例外返回
    input  wire [`CsrToPreifWidth] csr_to_ibus,
   
    output wire  [`PreifToIfBusWidth]to_pi_obus       
);

/***************************************input variable define(输入变量定义)**************************************/
    wire branch_flag_i;
    wire [`PcWidth]branch_pc_i;
    
    wire [`PcWidth]excep_entry_pc_i;  
    wire [`PcWidth]ertn_pc_i       ;  
    wire excep_en_i; 
    wire ertn_en_i       ; 
    
    wire [`PcWidth]pc1_i;
    
    
/***************************************output variable define(输出变量定义)**************************************/
    wire [`PcWidth]pc1_o;
    wire [`PcWidth]pc2_o;
 
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
wire preif_ready_go ;
/****************************************input decode(输入解码)***************************************/
assign {branch_flag_i,branch_pc_i} = id_to_ibus;
assign {excep_en_i,ertn_en_i,excep_entry_pc_i,ertn_pc_i} = csr_to_ibus;
assign pc1_i = if_to_ibus;

/****************************************output code(输出解码)***************************************/
assign to_pi_obus = {pc2_o,pc1_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
assign pc1_o = excep_en_i    ? excep_entry_pc_i :
               ertn_en_i     ? ertn_pc_i        :
               next_allowin_i  ? (  branch_flag_i ? branch_pc_i : pc1_i+32'd4  ) : pc1_i;

assign pc2_o = pc1_o +32'd4;

assign preif_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
assign now_to_next_valid_o = preif_ready_go;//id阶段打算写入
      
      
endmodule
