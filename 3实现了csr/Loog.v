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
    wire preif_to_if_valid;
//Preif_IF
    wire if_valid_o;
    wire [`PiToIfBusWidth] pi_to_if_obus;

//IF
    wire if_allowin_o;
    wire if_to_id_valid_o;
    wire [`IfToIdBusWidth]if_to_ifid_obus;
//IFID
    wire id_valid_o;
    wire inst_en_o;
    wire [`PcInstBusWidth]ifid_pc_inst_obus;
    //wire [`IfidToIdBusWidth]ifid_to_id_obus;
//ID阶段
    wire id_allowin_o;
    wire id_to_ex_valid_o;
    wire id_to_ex_stall_o;
    
    wire [`PcInstBusWidth]id_pc_inst_obus;
    wire [`IdToPreifBusWidth]id_to_preif_obus;
    wire [`IdToExBusWidth]id_to_idex_obus;
    wire [`IdToRfbBusWidth]id_to_rfb_obus;
 //cout
    wire [`CoutToIdBusWidth]cout_to_id_obus;
//Rfb
    wire [`RfbToIdBusWidth]rfb_to_id_obus;
//IDEX 
    wire ex_valid_o;
    
    
    wire [`PcInstBusWidth]idex_pc_inst_obus;
    wire[`IdToExBusWidth]idex_to_ex_obus;
//EX
    wire ex_allowin_o;
    wire ex_to_mem_valid_o;
    
    wire [`PcInstBusWidth]ex_pc_inst_obus;
    wire [`ExToIdBusWidth]ex_to_id_obus;
    wire [`ExToDataBusWidth]ex_to_data_obus;
    wire [`ExToMemBusWidth]ex_to_exmem_obus;
//ExMEM
    wire mem_valid_o;
    wire [`PcInstBusWidth]em_pc_inst_obus;
    wire [`ExToMemBusWidth]em_to_mem_obus;
//MEMI
    wire mem_allowin_o;
    wire mem_to_wb_valid_o;
    wire [`PcInstBusWidth]mem_pc_inst_obus;
    wire [`MemToWbBusWidth]mem_to_mw_obus;
    
    wire [`MemToIdBusWidth]mem_to_id_obus;
//MEMWB
    wire [`PcInstBusWidth]mw_pc_inst_obus;
    wire [`MemToWbBusWidth]mw_to_regs_obus;
    wire wb_valid_o;
//WB
    wire wb_to_rfb_valid_o;
    wire [`PcInstBusWidth] wb_pc_inst_obus;
    wire [`RegsWriteBusWidth]  wb_to_regs_obus ;                  
    wire  [`WbToCsrWidth] wb_to_csr_obus;  

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
    //组合计算nextPC值
    PreIF PreIFI(
        //握手
        .if_allowin_i(if_allowin_o),
        .preif_to_if_valid_o(preif_to_if_valid),
        
        //数据域
        .pc_i   (pi_to_if_obus),
        .id_to_ibus(id_to_preif_obus),

        .pc_o(preif_pc_o)
    );
    
    //PC缓存
    Preif_IF Preif_IFI(
        .rst_n (rst_n),
        .clk  (clk),
        //握手信号
        .preif_to_if_valid_i(preif_to_if_valid),
        .if_allowin_i(if_allowin_o),
        .if_valid_o(if_valid_o),
        
        //数据域
        .inst_en_i(1'b1),
        .pc_i (preif_pc_o),
        
        .inst_en_o(inst_en_o),
        .to_if_obus (pi_to_if_obus)
        );
     //访问指令rom
    IF IFI(
        //握手
        .id_allowin_i(id_allowin_o),
        .if_valid_i(if_valid_o),
        
        .if_allowin_o(if_allowin_o),
        .if_to_id_valid_o(if_to_id_valid_o),
        
        //数据域
        .pi_to_ibus(pi_to_if_obus),
        .inst_i(inst_sram_rdata),
        
        .to_ifid_obus(if_to_ifid_obus)
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
        //握手
         .if_to_id_valid_i(if_to_id_valid_o),
         .id_allowin_i(id_allowin_o),
         .id_flush_i  (id_to_preif_obus[32]),
         .id_valid_o(id_valid_o),
         
         //数据域
         .pc_inst_ibus(if_to_ifid_obus),
         .pc_inst_obus(ifid_pc_inst_obus)
    );

    ID IDI(
        .rst_n (rst_n),
        //握手
        .ex_allowin_i(ex_allowin_o),
        .id_valid_i(id_valid_o),
        .id_allowin_o(id_allowin_o),
        .id_to_ex_valid_o(id_to_ex_valid_o),
        //.id_to_ex_stall_o(id_to_ex_stall_o),
        
        //数据域
        .pc_inst_ibus(ifid_pc_inst_obus),
        
        .rfb_to_ibus(rfb_to_id_obus),
        .ex_to_ibus(ex_to_id_obus),
        .mem_to_ibus(mem_to_mw_obus),
        .cout_to_ibus(cout_to_id_obus),
        
        .pc_inst_obus(id_pc_inst_obus),
        .to_preif_obus(id_to_preif_obus),
        .to_idex_obus(id_to_idex_obus),
        .to_rfb_obus(id_to_rfb_obus)
    );

    Reg_File_Box RFI(
        .rst_n(rst_n),
        .clk(clk),
        
        .id_to_ibus(id_to_rfb_obus),//id组合逻辑输出读地址
        .wb_to_regs_ibus(wb_to_regs_obus),//wb阶段输出写地址
        .wb_to_csr_ibus(wb_to_csr_obus),

        .to_id_obus(rfb_to_id_obus)//输出读出数据
    );
    ID_EX IDEXI(
        .rst_n(rst_n),
        .clk(clk),
        //握手
        .id_to_ex_valid_i(id_to_ex_valid_o),
        //.id_to_ex_stall_i(id_to_ex_stall_o),
        .ex_allowin_i(ex_allowin_o),
        
        .ex_valid_o(ex_valid_o),
        
        //数据域
        .pc_inst_ibus(id_pc_inst_obus),
        .id_to_ibus(id_to_idex_obus),
        
        .pc_inst_obus(idex_pc_inst_obus),
        .to_ex_obus(idex_to_ex_obus)
    );
    EX EXI(
        //握手
        .mem_allowin_i(mem_allowin_o),
        .ex_valid_i(ex_valid_o),
        .ex_allowin_o(ex_allowin_o),
        .ex_to_mem_valid_o(ex_to_mem_valid_o),
        
        //数据域
        .pc_inst_ibus(idex_pc_inst_obus),
        .idex_to_ibus(idex_to_ex_obus),

        .pc_inst_obus(ex_pc_inst_obus),
        .to_id_obus(ex_to_id_obus),
        .to_data_obus(ex_to_data_obus),
        .to_exmen_obus(ex_to_exmem_obus)
    );
    EX_MEM EXMEMI(
        .rst_n(rst_n),
        .clk(clk),
        //握手
        .ex_to_mem_valid_i(ex_to_mem_valid_o),
        .mem_allowin_i(mem_allowin_o),
        .mem_valid_o(mem_valid_o),
        
        //数据域
        .pc_inst_ibus(ex_pc_inst_obus),
        .ex_to_ibus(ex_to_exmem_obus),

        .pc_inst_obus(em_pc_inst_obus),
        .to_mem_obus(em_to_mem_obus)
    );
    assign data_sram_en    = ex_to_data_obus[`EnLen+`MemWeLen+`MemAddrLen+`MemDataLen-1];
    assign data_sram_we    = ex_to_data_obus[`MemWeLen+`MemAddrLen+`MemDataLen-1:`MemAddrLen+`MemDataLen];
    assign data_sram_addr  = ex_to_data_obus[`MemAddrLen+`MemDataLen-1:`MemDataLen];
    assign data_sram_wdata = ex_to_data_obus[`MemDataLen-1:0];
//访问外部数据存储器
    MEM MEMI(
         //握手
        .wb_allowin_i(1'b1),
        .mem_valid_i(mem_valid_o),
        
        .mem_allowin_o(mem_allowin_o),
        .mem_to_wb_valid_o(mem_to_wb_valid_o),
        
        //数据域
        .pc_inst_ibus(em_pc_inst_obus),
        .exmem_to_ibus(em_to_mem_obus),
        .mem_rdata_i(data_sram_rdata),
        
        .pc_inst_obus(mem_pc_inst_obus),
        
        .to_memwb_obus(mem_to_mw_obus)
    );
    
    
    
    
    
    
    MEM_WB MEMWBI(
        .rst_n(rst_n),
        .clk(clk),
        
        //握手
        .mem_to_wb_valid_i(mem_to_wb_valid_o),
        .wb_allowin_i     (wb_allowin_o),
        .wb_valid_o       (wb_valid_o),
        
        //数据域
        .pc_inst_ibus(mem_pc_inst_obus),
        .mem_to_ibus(mem_to_mw_obus),
        
        .pc_inst_obus(mw_pc_inst_obus),
        .to_wb_obus(mw_to_regs_obus)
    );
    
    
    WB WBI(
    //握手
    .rfb_allowin_i(1'b1),
    .wb_valid_i(wb_valid_o),
    
    .wb_allowin_o    (wb_allowin_o),
    .wb_to_rfb_valid_o(wb_to_rfb_valid_o),
    
    //数据域
    .pc_inst_ibus( mw_pc_inst_obus),
    .mw_to_ibus  ( mw_to_regs_obus),
    
    .pc_inst_obus(wb_pc_inst_obus)         ,
    .to_regs_obus(wb_to_regs_obus)          ,
    .to_csr_obus( wb_to_csr_obus)
    
    
    
    );
    
    assign debug_wb_pc       =  wb_pc_inst_obus[63:32];  
    assign debug_wb_rf_we    = {4{wb_to_regs_obus[37]}};
    assign debug_wb_rf_wnum  = wb_to_regs_obus[36:32];
    assign debug_wb_rf_wdata = wb_to_regs_obus[31:0];

endmodule
