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
\*************/
`include "DefineModuleBus.h"
module WbStage(
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
    output wire excep_flush_o,
    //数据域
    input  wire[`MemToWbBusWidth] pre_to_ibus         ,
    input  wire [`CsrToWbWidth] csr_to_ibus,
    
    output wire [`WbToDebugBusWidth]wb_to_debug_obus,
    output wire [`WbToRegsBusWidth]wb_to_regs_obus,
    output wire [`WbToCsrWidth]wb_to_csr_obus,
    output wire [`ExcepToCsrWidth]excep_to_csr_obus
       
);

/***************************************input variable define(输入变量定义)**************************************/
wire [`LineCsrToWbWidth]line2_csr_to_wb_ibus,line1_csr_to_wb_ibus;
/***************************************output variable define(输出变量定义)**************************************/
wire [`LineWbToRegsBusWidth]line2_wb_to_regs_obus,line1_wb_to_regs_obus;
wire [`LineWbToCsrWidth] line2_wb_to_csr_obus,line1_wb_to_csr_obus;

wire [`LineWbToDebugBusWidth]line2_wb_to_debug_obus,line1_wb_to_debug_obus;
//冲刷信号
wire line2_excep_flush_o,line1_excep_flush_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//MEM_WB
wire line2_now_valid,line1_now_valid;
wire [`MemToWbBusWidth]mw_to_wb_obus;

//MEM
wire [`LineMemToWbBusWidth] line2_mw_to_wb_bus,line1_mw_to_wb_bus;
wire [`ExcepToCsrWidth]line2_excep_to_csr_bus,line1_excep_to_csr_bus;
//握手
wire line2_now_allowin,line1_now_allowin;
/****************************************input decode(输入解码)***************************************/
assign {line2_csr_to_wb_ibus,line1_csr_to_wb_ibus} = csr_to_ibus;
/****************************************output code(输出解码)***************************************/
assign wb_to_debug_obus =  {line2_wb_to_debug_obus,line1_wb_to_debug_obus};
assign wb_to_regs_obus  =  {line2_wb_to_regs_obus,line1_wb_to_regs_obus};
assign wb_to_csr_obus   =  {line2_wb_to_csr_obus,line1_wb_to_csr_obus};
/****************************************output code(内部解码)***************************************/
assign {line2_mw_to_wb_bus,line1_mw_to_wb_bus}= mw_to_wb_obus;

/*******************************complete logical function (逻辑功能实现)*******************************/
MEM_WB MEMWBI(
        .rst_n(rst_n),
        .clk(clk),
        
        //握手                                                     
        .line1_pre_to_now_valid_i(line1_pre_to_now_valid_i),     
        .line2_pre_to_now_valid_i(line2_pre_to_now_valid_i),     
        .now_allowin_i(now_allowin_o),                           
                                                                 
        .line1_now_valid_o(line1_now_valid),                     
        .line2_now_valid_o(line2_now_valid),                     
                                                                 
        .excep_flush_i(excep_flush_o),                           
        //数据域                                                    
        .pre_to_ibus(pre_to_ibus),                               
    
        .to_wb_obus(mw_to_wb_obus)
    );
    
    
    WB WBI1(
    //握手
    .rfb_allowin_i(1'b1),
    .wb_valid_i(line1_now_valid),
    
    .wb_allowin_o    (line1_now_allowin),
    .wb_to_rfb_valid_o(line1_now_to_next_valid_o),
    //冲刷流水线
    .wb_flush_o(line1_excep_flush_o),
    
    //数据域
    .mw_to_ibus  ( line1_mw_to_wb_bus),
    .csr_to_ibus(line1_csr_to_wb_ibus),
    
  
    .to_debug_obus (line1_wb_to_debug_obus),
    .to_regs_obus(line1_wb_to_regs_obus)          ,
    .to_csr_obus( line1_wb_to_csr_obus),
    .excep_to_csr_obus(line1_excep_to_csr_bus)
    
    
    
    );
     WB WBI2(
    //握手
    .rfb_allowin_i(1'b1),
    .wb_valid_i(line2_now_valid),
    
    .wb_allowin_o    (line2_now_allowin),
    .wb_to_rfb_valid_o(line2_now_to_next_valid_o),
    //冲刷流水线
    .wb_flush_o(line2_excep_flush_o),
    
    //数据域
    .mw_to_ibus  ( line2_mw_to_wb_bus),
    .csr_to_ibus(line2_csr_to_wb_ibus),
    
  
    .to_debug_obus (line2_wb_to_debug_obus),
    .to_regs_obus(line2_wb_to_regs_obus)          ,
    .to_csr_obus( line2_wb_to_csr_obus),
    
    .excep_to_csr_obus(line2_excep_to_csr_bus)
      
    );
    
 //例外
 assign excep_flush_o  = line2_excep_flush_o || line1_excep_flush_o;
 
 assign excep_to_csr_obus  = line1_excep_flush_o ? line1_excep_to_csr_bus :
                             line2_excep_flush_o ? line2_excep_to_csr_bus :`ExcepToCsrLen'd0;
 
 //握手   
 assign now_allowin_o  = line2_now_allowin && line1_now_allowin; 
 
         
   
endmodule
