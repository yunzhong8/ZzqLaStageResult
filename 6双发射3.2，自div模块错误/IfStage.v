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
//`include xxx.h
module IfStage(
    input  wire  clk      ,
    input  wire  rst_n    ,
    //握手                                                 
    input  wire next_allowin_i  ,                        
    input  wire pre_to_now_valid_i    ,   
              
                                                         
    output  wire line1_now_to_next_valid_o    ,          
    output  wire line2_now_to_next_valid_o    ,          
    output  wire now_allowin_o  ,                        
    //冲刷                                                 
    input wire excep_flush_i, 
    //中断使能
    input wire interrupt_en_i,                           
                                                         
    //数据域                                                
    input  wire [`PreifToIfBusWidth]pre_to_ibus         ,
    input  wire [`IdToIfBusWidth]next_to_ibus,   
    input  wire [`InstWidth]inst_sram_rdata_i,   
    input  wire [`ICacheReadObusWidth]icache_to_ibus,
    
                                                         
    output wire [`IfToPreifBusWidth]to_pre_obus,        
    output wire [`IfToICacheBusWidth]to_icache_obus     ,    
    output wire [`IfToIdBusWidth]to_next_obus           
);

/***************************************input variable define(输入变量定义)**************************************/
wire cache_we_i;
/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//preif_if
wire now_valid;
wire [`PreifToIfBusWidth]pi_to_if_bus;
/****************************************input decode(输入解码)***************************************/
assign {icache_iowe_useless_i,cache_we_i} = next_to_ibus;

/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
 //PC缓存
    Preif_IF Preif_IFI(
        .rst_n (rst_n),
        .clk  (clk),
        //握手信号
        .preif_to_if_valid_i(pre_to_now_valid_i),
        .if_allowin_i(now_allowin_o),
        .if_valid_o(now_valid),
        //冲刷信号
        .excep_flush_i(excep_flush_i),
        //数据域
        .preif_to_ibus (pre_to_ibus ),
        
        .to_if_obus (pi_to_if_bus)
        );
     //访问指令rom
    IF IFI(
        //握手
        .id_allowin_i(next_allowin_i),
        .if_valid_i(now_valid),
        
        .if_allowin_o(now_allowin_o),
        .line1_if_to_id_valid_o(line1_now_to_next_valid_o),
        .line2_if_to_id_valid_o(line2_now_to_next_valid_o),
        .excep_flush_i(excep_flush_i),
        
        //数据域
        .pi_to_ibus(pi_to_if_bus),
        .cache_we_i (cache_we_i),
        .icache_iowe_useless_i(icache_iowe_useless_i),
        .interrupt_en_i(interrupt_en_i),//中断使能
        .ram_inst1_i(inst_sram_rdata_i),
        .icache_to_ibus( icache_to_ibus),  
        
        .to_preif_obus(to_pre_obus),
        .to_icache_obus(to_icache_obus),
        .to_id_obus(to_next_obus)
        );
endmodule
