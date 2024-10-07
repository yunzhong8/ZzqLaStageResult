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
module Loog(
     input  wire        clk,
    input  wire        rst_n,
    // inst sram interface
    output wire        inst_sram_en,
    output wire [3:0]       inst_sram_we,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    
    input  wire [31:0] inst_sram_rdata,
    // data sram interface
    
    output wire        data_sram_en,
    output wire  [3:0]      data_sram_we,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input  wire [31:0] data_sram_rdata,
    // trace debug interface
    output wire [31:0] debug_wb_pc,
    output wire [ 3:0] debug_wb_rf_we,
    output wire [ 4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//PreIF
    wire [`PcWidth]preif_pc_o;
//IF
    wire [`PcWidth] if_pc_o;
    wire [`IdToPreifBusWidth]id_to_preif_obus;
//IFID
    wire inst_en_o;
    wire [`PcInstBusWidth]ifid_pc_inst_obus;
    //wire [`IfidToIdBusWidth]ifid_to_id_obus;
//ID阶段
    wire [`PcInstBusWidth]id_pc_inst_obus;
    wire [`IdToPreifBusWidth]id_to_preif_obus;
    wire [`IdToExBusWidth]id_to_idex_obus;
    wire [`IdToRegsBusWidth]id_to_regs_obus;
 //cout
    wire [`CoutToIdBusWidth]cout_to_id_obus;
//Regs
    wire [`RegsToIdBusWidth]regs_to_id_obus;
//IDEX
    wire [`PcInstBusWidth]idex_pc_inst_obus;
    wire[`IdToExBusWidth]idex_to_ex_obus;
//EX
    wire [`PcInstBusWidth]ex_pc_inst_obus;
    wire [`ExToIdBusWidth]ex_to_id_obus;
    wire [`ExToMemBusWidth]ex_to_exmem_obus;
//ExMEM
    wire [`PcInstBusWidth]em_pc_inst_obus;
    wire [`ExToMemBusWidth]em_to_mem_obus;
//MEMI
    wire [`PcInstBusWidth]mem_pc_inst_obus;
    wire [`MemToWbBusWidth]mem_to_mw_obus;
    wire [`MemToDataBusWidth]mem_to_data_obus;
    wire [`MemToIdBusWidth]mem_to_id_obus;
//MEMWB
    wire [`PcInstBusWidth]mw_pc_inst_obus;
    wire [`MemToWbBusWidth]mw_to_regs_obus;

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
    //组合计算nextPC值
    PreIF PreIFI(
        .pc_i   (if_pc_o),
        .id_to_ibus(id_to_preif_obus),

        .pc_o(preif_pc_o)
    );
    
    //PC缓存
    IF IFI(
        .rst_n (rst_n),
        .clk  (clk),
        .inst_en_i(1'b1),
        .pc_i (preif_pc_o),
        
        .inst_en_o(inst_en_o),
        .pc_o (if_pc_o)
        );
    //访问外部存储器
        //assign inst_sram_en=inst_en_o;
        assign inst_sram_en = rst_n;
        assign inst_sram_we = 4'b0000;
        //assign inst_sram_addr = if_pc_o;
        assign inst_sram_addr = preif_pc_o;
        assign inst_sram_wdata= 32'h0000_0000;
    
    //指令缓存
    IF_ID IFIDI(
        .rst_n(rst_n),
        .clk(clk),

        .pc_i(if_pc_o),
        .inst_i(inst_sram_rdata),

         .pc_inst_obus(ifid_pc_inst_obus)
    );

    ID IDI(
        .rst_n (rst_n),
        .pc_inst_ibus(ifid_pc_inst_obus),
        
        .regs_to_ibus(regs_to_id_obus),
        .ex_to_ibus(ex_to_id_obus),
        .mem_to_ibus(mem_to_mw_obus),
        .cout_to_ibus(cout_to_id_obus),
        
        .pc_inst_obus(id_pc_inst_obus),
        .to_preif_obus(id_to_preif_obus),
        .to_idex_obus(id_to_idex_obus),
        .to_regs_obus(id_to_regs_obus)
    );

    Reg_File_Box RFI(
        .rst_n(rst_n),
        .clk(clk),
        
        .id_to_ibus(id_to_regs_obus),//id组合逻辑输出读地址
        .wb_to_ibus(mw_to_regs_obus),//wb阶段输出写地址

        .to_id_obus(regs_to_id_obus)//输出读出数据
    );
    ID_EX IDEXI(
        .rst_n(rst_n),
        .clk(clk),
        .pc_inst_ibus(id_pc_inst_obus),
        .id_to_ibus(id_to_idex_obus),
        
         .pc_inst_obus(idex_pc_inst_obus),
        .to_ex_obus(idex_to_ex_obus)
    );
    EX EXI(

        .pc_inst_ibus(idex_pc_inst_obus),
        .idex_to_ibus(idex_to_ex_obus),

        .pc_inst_obus(ex_pc_inst_obus),
        .to_exmen_obus(ex_to_exmem_obus)
    );
    EX_MEM EXMEMI(
        .rst_n(rst_n),
        .clk(clk),
        .pc_inst_ibus(ex_pc_inst_obus),
        .ex_to_ibus(ex_to_exmem_obus),

        .pc_inst_obus(em_pc_inst_obus),
        .to_mem_obus(em_to_mem_obus)
    );
//访问外部数据存储器
    MEM MEMI(
        .pc_inst_ibus(em_pc_inst_obus),
        .exmem_to_ibus(em_to_mem_obus),
        .mem_rdata_i(data_sram_rdata),
        
        .pc_inst_obus(mem_pc_inst_obus),
        .to_data_obus(mem_to_data_obus),
        .to_memwb_obus(mem_to_mw_obus)
    );
    assign data_sram_en = mem_to_data_obus[65];
    assign data_sram_we =   {4{mem_to_data_obus[64]}};
    assign data_sram_addr = mem_to_data_obus[63:32];
    assign data_sram_wdata =mem_to_data_obus[31:0];
    
    
    
    
    
    MEM_WB MEMWBI(
        .rst_n(rst_n),
        .clk(clk),
        .pc_inst_ibus(mem_pc_inst_obus),
        .mem_to_ibus(mem_to_mw_obus),
        
        .pc_inst_obus(mw_pc_inst_obus),
        .to_wb_obus(mw_to_regs_obus)
    );
    
    assign debug_wb_pc       =  mw_pc_inst_obus[63:32];  
    assign debug_wb_rf_we    = {4{mw_to_regs_obus[36]}};
    assign debug_wb_rf_wnum  = mw_to_regs_obus[36:32];
    assign debug_wb_rf_wdata = mw_to_regs_obus[31:0];

endmodule
