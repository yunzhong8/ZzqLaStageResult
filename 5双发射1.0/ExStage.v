/*
*作者：zzq
*创建时间：2023-04-22
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*
*/
/*************\
bug:
1. 握手信号的组合逻辑环查找方式，就是将握手信号删掉在看
\*************/
`include "DefineModuleBus.h"
module ExStage(
    //时钟
    input  wire  clk      ,
    input  wire  rst_n    ,
    //握手
    input  wire next_allowin_i  ,
    input  wire line1_pre_to_now_valid_i    ,
    input  wire line2_pre_to_now_valid_i    ,
    
    output  wire line1_now_to_next_valid_o    ,
    output  wire line2_now_to_next_valid_o    ,
    output  wire now_allowin_o  ,
    //冲刷
    input wire excep_flush_i,
     
    //数据域
    input  wire [`IdToExBusWidth]pre_to_ibus         ,
    input  wire [`MemToExBusWidth]mem_to_ibus         ,
    
    output wire [`ExForwardBusWidth]forward_obus,
    output wire [`ExToDataBusWidth]to_data_obus     ,
    output wire [`ExToMemBusWidth]to_next_obus          
);

/***************************************input variable define(输入变量定义)**************************************/


//EX
wire [`LineMemToExBusWidth] line2_mem_to_ex_ibus,line1_mem_to_ex_ibus;
/***************************************output variable define(输出变量定义)**************************************/
wire [`LineExToMemBusWidth]line2_ex_to_exmem_obus,line1_ex_to_exmem_obus;
wire [`LineExForwardBusWidth]line2_ex_forward_obus,line1_ex_forward_obus;


/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//ID_EX
wire [`IdToExBusWidth] idex_to_ex_bus;
wire line2_now_valid,line1_now_valid;
//EX
wire [`LineIdToExBusWidth] line1_idex_to_ex_bus, line2_idex_to_ex_bus;

wire [`ExToDataBusWidth]line2_ex_to_data_bus,line1_ex_to_data_bus;
//握手
wire line2_now_allowin,line1_now_allowin;

/****************************************input decode(输入解码)***************************************/
assign {line2_mem_to_ex_ibus,line1_mem_to_ex_ibus} = mem_to_ibus ;
/****************************************output code(输出解码)***************************************/
assign to_next_obus = {line2_ex_to_exmem_obus,line1_ex_to_exmem_obus};
assign forward_obus = {line2_ex_forward_obus,line1_ex_forward_obus};
/****************************************output code(内部解码)***************************************/
assign {line2_idex_to_ex_bus, line1_idex_to_ex_bus} = idex_to_ex_bus;
/*******************************complete logical function (逻辑功能实现)*******************************/

 ID_EX IDEXI(
        .rst_n(rst_n),
        .clk(clk),
        //握手
        .line1_pre_to_now_valid_i(line1_pre_to_now_valid_i),
        .line2_pre_to_now_valid_i(line2_pre_to_now_valid_i),
        .now_allowin_i(now_allowin_o),
        
        .line1_now_valid_o(line1_now_valid),
        .line2_now_valid_o(line2_now_valid),
        
        .excep_flush_i(excep_flush_i),
        //数据域
        .pre_to_ibus(pre_to_ibus),
        
        .to_ex_obus(idex_to_ex_bus)
    );
    
    
    
 EX EXI1(
        //握手
        .mem_allowin_i(next_allowin_i),
        //.ex_valid_i(line1_pre_to_now_valid_i),sb东西，没有经过时序电路直接传到啦，tm的，这行永不删除铭记，找了一整天，这bug
        .ex_valid_i(line1_now_valid),
        
        .ex_allowin_o(line1_now_allowin),
        .ex_to_mem_valid_o(line1_now_to_next_valid_o),
        
        .excep_flush_i(excep_flush_i),
        
        //数据域
        .idex_to_ibus  (line1_idex_to_ex_bus),
        .mem_to_ibus   (line1_mem_to_ex_ibus),

        
        .forward_obus  (line1_ex_forward_obus),
        .to_data_obus  (line1_ex_to_data_bus),
        .to_exmen_obus (line1_ex_to_exmem_obus)
    );                  

 EX EXI2(
        //握手
        .mem_allowin_i(next_allowin_i),
        //.ex_valid_i   (line2_pre_to_now_valid_i),
        .ex_valid_i   (line2_now_valid),
        
        .ex_allowin_o(line2_now_allowin),
        .ex_to_mem_valid_o(line2_now_to_next_valid_o),
        
        .excep_flush_i(excep_flush_i),
        
        //数据域
        .idex_to_ibus(line2_idex_to_ex_bus),
        .mem_to_ibus(line2_mem_to_ex_ibus),
        
        .forward_obus   (line2_ex_forward_obus),
        .to_data_obus   (line2_ex_to_data_bus),
        .to_exmen_obus  (line2_ex_to_exmem_obus)
    );

//
assign to_data_obus = line1_ex_to_data_bus;

//握手
assign now_allowin_o  = line2_now_allowin && line1_now_allowin;




endmodule
