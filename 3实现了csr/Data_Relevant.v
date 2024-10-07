/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：reg类型在if中要更新
*
*/
/*************\
bug:
\*************/

`include "DefineModuleBus.h"

module Data_Relevant(
     input wire [`ExToIdBusWidth]ex_to_ibus,
     input wire [`MemToIdBusWidth]mem_to_ibus,
     input wire [`IdToDrBusWidth]id_to_ibus,
     
     output wire [`DrToIdWidth]to_id_obus
    );
/***************************************input variable define(输入变量定义)**************************************/
//执行阶段寄存器组信息
         wire                   ex_regs_we_i;
         wire                   ex_memtoreg_i;
         wire [`RegsAddrWidth]  ex_regs_waddr_i;
         wire [`RegsDataWidth]   ex_regs_wdata_i;
         
         wire                   ex_csr_we_i;
         wire [`CsrAddrWidth]   ex_csr_waddr_i;
         wire [`RegsDataWidth]  ex_csr_wdata_i;
    //存储阶段寄存器组信息
        wire                   mem_regs_we_i;
        wire[`RegsAddrWidth]   mem_regs_waddr_i;
        wire[`RegsDataWidth]   mem_regs_wdata_i;
        wire                   mem_csr_we_i;
        wire [`CsrAddrWidth]   mem_csr_waddr_i;
        wire [`RegsDataWidth]  mem_csr_wdata_i;
    //正常寄存器组读出数据和读地址
         wire [`RegsAddrWidth]    id_regs_raddr1_i;
         wire [`RegsDataWidth]    id_regs_rdata1_i;
         
         wire [`RegsAddrWidth]    id_regs_raddr2_i;
         wire [`RegsDataWidth]    id_regs_rdata2_i;
         
         wire [`CsrAddrWidth]     id_csr_raddr_i;
         wire [`RegsDataWidth]    id_csr_rdata_i;       
/***************************************output variable define(输出变量定义)**************************************/
  wire [`RegsDataWidth]   regs_rdata1_o;
  wire [`RegsDataWidth]   regs_rdata2_o;
  wire [`RegsDataWidth]   csr_rdata_o;
  wire regs_read_ready_o;
/***************************************inner variable define(内部变量定义)**************************************/
wire regs1_exe_relate;
wire regs2_exe_relate;
wire regs1_mem_relate;
wire regs2_mem_relate;
wire csr_exe_relate;
wire csr_mem_relate;

/****************************************input decode(输入解码)***************************************/
  assign{ex_csr_we_i,ex_csr_waddr_i,ex_csr_wdata_i,ex_regs_we_i,ex_regs_waddr_i,ex_regs_wdata_i,ex_memtoreg_i} = ex_to_ibus;  
  assign{mem_csr_we_i,mem_csr_waddr_i,mem_csr_wdata_i,mem_regs_we_i,mem_regs_waddr_i,mem_regs_wdata_i} = mem_to_ibus;
  assign{id_csr_raddr_i,id_regs_raddr1_i,id_regs_raddr2_i,id_csr_rdata_i,id_regs_rdata1_i,id_regs_rdata2_i} = id_to_ibus;

/****************************************output code(输出解码)***************************************/
   assign to_id_obus ={regs_read_ready_o,csr_rdata_o,regs_rdata1_o,regs_rdata2_o};
/*******************************complete logical function (逻辑功能实现)*******************************/

assign regs_rdata1_o = (ex_regs_waddr_i == id_regs_raddr1_i&&ex_regs_we_i==`WriteEnable) ? ex_regs_wdata_i :
                       (mem_regs_waddr_i == id_regs_raddr1_i && mem_regs_we_i==`WriteEnable) ? mem_regs_wdata_i:id_regs_rdata1_i;
                       
assign regs_rdata2_o = (ex_regs_waddr_i == id_regs_raddr2_i&&ex_regs_we_i==`WriteEnable) ? ex_regs_wdata_i :
                       (mem_regs_waddr_i == id_regs_raddr2_i && mem_regs_we_i==`WriteEnable) ? mem_regs_wdata_i : id_regs_rdata2_i;
                       
assign csr_rdata_o  = (ex_csr_waddr_i == id_csr_raddr_i && ex_csr_we_i ==`WriteEnable ) ? ex_csr_wdata_i :
                      (mem_csr_waddr_i == id_csr_raddr_i && mem_csr_we_i ==`WriteEnable) ? mem_csr_wdata_i :id_csr_rdata_i;

assign regs1_exe_relate = ex_regs_waddr_i == id_regs_raddr1_i&&ex_regs_we_i==`WriteEnable;
assign regs1_mem_relate = mem_regs_waddr_i == id_regs_raddr1_i && mem_regs_we_i==`WriteEnable;
assign regs2_exe_relate = ex_regs_waddr_i == id_regs_raddr2_i&&ex_regs_we_i==`WriteEnable;
assign regs2_mem_relate = mem_regs_waddr_i == id_regs_raddr2_i && mem_regs_we_i==`WriteEnable;
assign csr_exe_relate  = ex_csr_waddr_i == id_csr_raddr_i && ex_csr_we_i ==`WriteEnable;
assign csr_mem_relate = mem_csr_waddr_i == id_csr_raddr_i && mem_csr_we_i ==`WriteEnable;

assign regs_read_ready_o = ~( (regs1_exe_relate | regs2_exe_relate) & ex_memtoreg_i );
endmodule
