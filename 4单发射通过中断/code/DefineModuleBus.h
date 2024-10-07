/*
 * DefineModuleBus.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"
`ifndef DEFINEMODULEBUS_H
`define DEFINEMODULEBUS_H
//绑定接口bus(那些数据是绑定同时出现的就使用相同bus)
  //REGS
         `define RegsWriteBusLen `EnLen+`RegsAddrLen+`RegsDataLen //reg_we1,reg_waddr5,reg_wdata32
         `define RegsWriteBusWidth `RegsWriteBusLen-1 : 0

         `define RegsReadIbusLen `RegsAddrLen+`RegsAddrLen
         `define RegsReadIbusWidth `RegsReadIbusLen-1:0
         
         
         `define RegsReadObusLen `RegsDataLen + `RegsDataLen
         `define RegsReadObusWidth `RegsReadObusLen-1 :0
 //csr写
`define CsrWriteBusLen `EnLen+`CsrAddrLen+`RegsDataLen //csr_we,csr_waddr, csr_wdata32
`define CsrWriteBusWidth `CsrWriteBusLen-1 : 0

//mem写
`define MemWriteBusLen `EnLen+`EnLen+`MemDataLen //mem_req1,mem_we,mem_wdata,
//例外·
`define ExcepBusLen `EnLen+`ExceptionTypeLen
`define ExcepBusWidth `ExcepBusLen-1 :0
//llbit
`define LlbitWriteBusLen `EnLen+`EnLen
`define LlbitWriteBusWidth `LlbitWriteBusLen-1 :0
//alu
`define AluBusLen `AluOpLen+`AluOperLen+`AluOperLen
`define AluBusWidth `AluBusLen-1:0
//pc分支
`define PcBranchBusLen `EnLen+`PcLen
`define PcBranchBusWidth `PcBranchBusLen-1 :0
//data_ram 写
`define DataWriteBusLen `EnLen+`MemWeLen+`MemAddrLen+`MemDataLen
`define DataWriteBusWidth `DataWriteBusLen-1 :0

//总线宽度
        `define PcInstBusLen   32+`InstLen
        `define PcInstBusWidth `PcInstBusLen-1:0
     //preif_if
         `define PiToIfBusLen   `InstLen
         `define PiToIfBusWidth `PiToIfBusLen-1:0
     //if
        `define IfToIdBusLen    `ExcepBusLen
        `define IfToIdBusWidth   `IfToIdBusLen-1:0
        
    //时钟
        `define CoutToIdBusLen 64//64+64
        `define CoutToIdBusWidth `CoutToIdBusLen-1:0
    
    //Id阶段
        `define OdToIspBusLen   32+32+32+64+16+4+32+`InstLen
        `define OdToIspBusWidth `OdToIspBusLen-1:0
        
        `define IdToExBusLen `EnLen+`EnLen+`RegsReadObusLen+`ExcepBusLen+`LlbitWriteBusLen+`EnLen+`CsrWriteBusLen+`AluBusLen+`spExeRegsWdataSrcLen+`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`MemWriteBusLen+`EnLen+`RegsWriteBusLen
        `define IdToExBusWidth `IdToExBusLen-1:0
        
        `define IdToPreifBusLen  `PcBranchBusLen
        `define IdToPreifBusWidth `IdToPreifBusLen-1:0
        
        
        `define IdToRfbBusLen  `RegsAddrLen+`RegsAddrLen
        `define IdToRfbBusWidth `IdToRfbBusLen:0
        
        `define IdToSpBusLen   `RegsAddrLen+`RegsAddrLen+`RegsAddrLen+`InstLen
        `define IdToSpBusWidth `IdToSpBusLen-1 :0
        
    //EXE阶段
        `define ExToIdBusLen  `LlbitWriteBusLen+`RegsWriteBusLen+`spMemRegsWdataSrcLen+`EnLen
        `define ExToIdBusWidth `ExToIdBusLen-1:0
        
        `define ExToMemBusLen  `EnLen+`EnLen+`RegsReadObusLen+ `ExcepBusLen+`LlbitWriteBusLen+`EnLen+`CsrWriteBusLen +`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`DataWriteBusLen+`EnLen+`RegsWriteBusLen
        `define ExToMemBusWidth `ExToMemBusLen-1:0
        
        `define ExToDataBusLen `DataWriteBusLen
        `define ExToDataBusWidth `ExToDataBusLen-1:0 
    //MEM阶段
        `define MemToIdBusLen  `LlbitWriteBusLen+`RegsWriteBusLen+`EnLen
        `define MemToIdBusWidth `MemToIdBusLen-1:0
       
        
        `define MemToWbBusLen `EnLen+`EnLen+`RegsReadObusLen+`ExcepBusLen+`MemAddrLen+`LlbitWriteBusLen+`EnLen+`CsrWriteBusLen+`EnLen+`RegsWriteBusLen
        `define MemToWbBusWidth  `MemToWbBusLen-1 :0
    
    //WB
        `define WbToCsrLen `LlbitWriteBusLen + `CsrAddrLen+`CsrWriteBusLen
        `define WbToCsrWidth `WbToCsrLen-1 :0
    //except_to_csr
        `define ExcepToCsrLen `EnLen+`MemAddrLen+`EnLen+`EnLen+`EcodeLen+`EsubCodeLen+`PcLen
        `define ExcepToCsrWidth `ExcepToCsrLen-1:0
    
    //CSR
        `define CsrToIdLen 1
        `define CsrToIdWidth `CsrToIdLen-1 :0
        
        `define CsrToWbLen   2+`RegsDataLen
        `define CsrToWbWidth `CsrToWbLen-1:0
             
        `define CsrToPreifLen `PcBranchBusLen+`PcBranchBusLen
        `define CsrToPreifWidth `CsrToPreifLen-1:0
    //RFB
        `define RfbToIdBusLen `CsrToIdLen+`RegsReadObusLen
        `define RfbToIdBusWidth `RfbToIdBusLen-1 :0
   //DR
        `define IdToDrBusLen  `RegsReadIbusLen+`RfbToIdBusLen
        `define IdToDrBusWidth `IdToDrBusLen-1 :0
        
         `define DrToIdBusLen `EnLen+`RfbToIdBusLen
         `define DrToIdWidth `DrToIdBusLen-1 :0

`endif /* !DEFINEMODULEBUS_H */
