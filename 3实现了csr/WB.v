/*
*作者：zzq
*创建时间：2023-04-10
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
module WB(
    input  wire rfb_allowin_i         ,
    input  wire wb_valid_i             ,

    output wire wb_allowin_o          ,
    output wire wb_to_rfb_valid_o    ,    
    
    input  wire [`MemToWbBusWidth]mw_to_ibus,
    input  wire [`PcInstBusWidth]pc_inst_ibus           ,
    
    output wire [`PcInstBusWidth] pc_inst_obus         ,
    output wire [`RegsWriteBusWidth]   to_regs_obus,
    output wire [`WbToCsrWidth]   to_csr_obus
    
);

/***************************************input variable define(输入变量定义)**************************************/
 wire regs_we_i;
 wire [`RegsAddrWidth]regs_waddr_i;
 wire [`RegsDataWidth]regs_wdata_i;

 wire csr_we_i; 
 wire [`CsrAddrWidth]csr_waddr_i;
 wire [`RegsDataWidth]csr_wdata_i;
/***************************************output variable define(输出变量定义)**************************************/
 wire regs_we_o;
 wire [`RegsAddrWidth]regs_waddr_o;
 wire [`RegsDataWidth]regs_wdata_o;

 wire csr_we_o; 
 wire [`CsrAddrWidth]csr_waddr_o;
 wire [`RegsDataWidth]csr_wdata_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
 wire wb_ready_go ;
 wire[`PcWidth] pc;
 wire [`InstWidth]inst;
/****************************************input decode(输入解码)***************************************/
assign {csr_we_i,csr_waddr_i,csr_wdata_i,regs_we_i,regs_waddr_i,regs_wdata_i} = mw_to_ibus;

/****************************************output code(输出解码)***************************************/
assign pc_inst_obus = pc_inst_ibus;
assign to_regs_obus = {regs_we_o,regs_waddr_o,regs_wdata_o};
assign to_csr_obus ={csr_we_o,csr_waddr_o,csr_wdata_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
assign {pc,inst} = pc_inst_ibus;

assign regs_we_o = regs_we_i & wb_valid_i;
assign regs_waddr_o = regs_waddr_i;
assign regs_wdata_o = regs_wdata_i;

assign csr_we_o  = csr_we_i  & wb_valid_i;
assign csr_waddr_o = csr_waddr_i;
assign csr_wdata_o = csr_wdata_i;


//握手
    assign wb_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
    
    assign wb_allowin_o  = !wb_valid_i //本级数据为空，允许if阶段写入
                             || (wb_ready_go && rfb_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
    assign wb_to_rfb_valid_o = wb_valid_i && wb_ready_go;//id阶段打算写入


endmodule
