/*
 * DefineModuleBus.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"
`ifndef DEFINEMODULEBUS_H
`define DEFINEMODULEBUS_H

//总线宽度
        `define PcInstBusLen   32+`InstLen
        `define PcInstBusWidth `PcInstBusLen-1:0
     //preif_if
         `define PiToIfBusLen   `InstLen
         `define PiToIfBusWidth `PiToIfBusLen-1:0
     //if
        `define IfToIdBusLen     `PcLen+`InstLen
        `define IfToIdBusWidth   `IfToIdBusLen-1:0
        
     //寄存器组
        `define RegsToIdBusLen  `RegsDataLen+`RegsDataLen+`RegsDataLen//32+32+32
        `define RegsToIdBusWidth  `RegsToIdBusLen-1:0  
    //时钟
        `define CoutToIdBusLen 128//64+64
        `define CoutToIdBusWidth `CoutToIdBusLen-1:0
    
    //Id阶段
        `define OdToIspBusLen   64+16+4+32+`InstLen
        `define OdToIspBusWidth `OdToIspBusLen-1:0
        
        `define IdToExBusLen `EnLen+`CsrAddrLen+`RegsDataLen+`AluOpLen+`AluOperLen+`AluOperLen+`spExeRegsWdataSrcLen+`EnLen+`EnLen+`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`MemDataLen+`EnLen+`RegsAddrLen+`RegsDataLen
        `define IdToExBusWidth `IdToExBusLen-1:0
        
        `define IdToPreifBusLen  `PcLen+1
        `define IdToPreifBusWidth `IdToPreifBusLen-1:0
        
        `define IdToCsrLen `CsrAddrLen
        `define IdToCsrWidth `IdToCsrLen-1 :0
        
        `define IdToRfbBusLen  `CsrAddrLen+`RegsAddrLen+`RegsAddrLen
        `define IdToRfbBusWidth `IdToRfbBusLen:0
        
        `define IdToSpBusLen   `RegsAddrLen+`RegsAddrLen+`RegsAddrLen+`InstLen
        `define IdToSpBusWidth `IdToSpBusLen-1 :0
        
        `define IdToDrBusLen  `CsrAddrLen+`RegsAddrLen+`RegsAddrLen+`RegsDataLen+`RegsDataLen+`RegsDataLen
        `define IdToDrBusWidth `IdToDrBusLen-1 :0
        //DR
            `define DrToIdBusLen `EnLen+`RegsDataLen+`RegsDataLen+`RegsDataLen
            `define DrToIdWidth `DrToIdBusLen-1 :0
    //EXE阶段
        `define ExToIdBusLen  `EnLen+`CsrAddrLen+`RegsDataLen+`EnLen+`RegsAddrLen+`RegsDataLen+`spMemRegsWdataSrcLen
        `define ExToIdBusWidth `ExToIdBusLen-1:0
        
        `define ExToMemBusLen   `EnLen+`CsrAddrLen+`RegsDataLen+`EnLen+`MemWeLen+`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`MemAddrLen+`MemDataLen+`EnLen+`RegsAddrLen+`RegsDataLen
        `define ExToMemBusWidth `ExToMemBusLen-1:0
        
        `define ExToDataBusLen `EnLen+`MemWeLen+`MemAddrLen+`MemDataLen
        `define ExToDataBusWidth `ExToDataBusLen-1:0 
    //MEM阶段
        `define MemToIdBusLen  `EnLen+`CsrAddrLen+`RegsDataLen+`EnLen+`RegsAddrLen+`RegsDataLen
        `define MemToIdBusWidth `MemToIdBusLen-1:0
       
        
        `define MemToWbBusLen `EnLen+`CsrAddrLen+`RegsDataLen+`RegsAddrLen+`RegsDataLen+`EnLen
        `define MemToWbBusWidth  `MemToWbBusLen-1 :0
    
    //WB
        `define WbToCsrLen `CsrAddrLen+`RegsDataLen + `EnLen
        `define WbToCsrWidth `WbToCsrLen-1 :0
    //REGS
         `define RegsReadIbusLen `RegsAddrLen+`RegsAddrLen
         `define RegsReadIbusWidth `RegsReadIbusLen-1:0
         
         `define RegsWriteBusLen `EnLen+`RegsAddrLen+`RegsDataLen
         `define RegsWriteBusWidth `RegsWriteBusLen-1 : 0
         
         `define RegsReadObusLen `RegsDataLen + `RegsDataLen
         `define RegsReadObusWidth `RegsReadObusLen-1 :0
    //CSR
        `define CsrToIdLen `RegsDataLen
        `define CsrToIdWidth `CsrToIdLen-1:0
    //RFB
        `define RfbToIdBusLen `CsrToIdLen+`RegsReadObusLen
        `define RfbToIdBusWidth `RfbToIdBusLen-1 :0


`endif /* !DEFINEMODULEBUS_H */
