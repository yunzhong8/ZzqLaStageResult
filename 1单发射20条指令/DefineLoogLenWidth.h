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
`ifndef DEFINELOOGLENWIDTH_H
`define DEFINELOOGLENWIDTH_H

//全局使用的宏定义
    `define ZeroWord32B 32'h0000_0000//32位0

//复位信号
    `define EnLen 1
    `define EnWidth `EnLen-1:0
    `define RstEnable `EnLen'b0 //复位信号有效
    `define RstDisable `EnLen'b1 //复位信号无效

//PC宽度
    `define PcLen   32
    `define PcWidth `PcLen-1:0 //PC宽度
//指令宽度
    `define InstLen   32
    `define InstWidth `InstLen-1:0 //指令宽度

//读写信号
    `define WriteEnable      `EnLen'b1 //写使能
    `define WriteDisable     `EnLen'b0 //写禁止

    `define ReadEnable       `EnLen'b1 //读使能信号
    `define ReadDisable      `EnLen'b0 //禁止读

    `define  MemEnable       `EnLen'b1
    `define  MemDisable      `EnLen'b0
//信号宽度
  
    `define SignLen          36//信号实际使用长度
    `define SignWidth        `SignLen-1:0//信号实际使用宽度
//暂停流水
    `define StopLen         6
    `define StopWidth         `StopLen-1:0
    `define StopEnable      `EnLen'b1
    `define StopDisable     `EnLen'b0


//寄存器组宏定义
    `define RegsAddrLen 5
    `define RegsAddrWidth `RegsAddrLen-1:0 //寄存器组访问地址宽度

    `define RegsDataLen 32
    `define RegsDataWidth `RegsDataLen-1:0 //寄存器组数据宽度
    `define RegsNum 32 //寄存器组寄存器个数
    `define RegsNumLog2  5 //寻址通用寄存器使用的地址长度
//存储器宏定义
    `define MemAddrLen 32
    `define MemAddrWidth `MemAddrLen-1:0
    
    `define MemDataLen  32
    `define MemDataWidth `MemDataLen-1:0

//ALU
    `define AluOpLen 4 //运算器运算类型控制长度
    `define AluOpWidth `AluOpLen-1:0 //运算器运算类型控制长度

    `define AluShmatLen 5
    `define AluShmatWidth `AluShmatLen-1:0
   

    `define AluOperLen 32
    `define AluOperWidth `AluOperLen-1:0 //运算器参与运算的数的宽度


//指令
  //op位宽
    `define  InstOpLen6   6
    `define  InstOpWidtg6    `InstOpLen6-1 :0
    
    `define  InstOpLen7   7
    `define  InstOpWidth7    `InstOpLen7-1 :0
    
    `define  InstOpLen8   8
    `define  InstOpWidth8    `InstOpLen8-1 :0
    
    `define  InstOpLen10   10
    `define  InstOpWidth10    `InstOpLen10-1 :0
    
    `define  InstOpLen17   17
    `define  InstOpWidth17    `InstOpLen17-1 :0
    
    `define  InstOpLen22   22
    `define  InstOpWidth22    `InstOpLen22-1 :0

//指令信号宽度
    //id阶段
        `define spIdRegsRead2SrcLen    1
        `define spIdRegsRead2SrcWidth   `spIdRegsRead2SrcLen-1:0
        
        `define spIdAluOpaSrcLen    1
        `define spIdAluOpaSrcWidth      `spIdAluOpaSrcLen-1:0
        
        `define spIdAluOpbSrcLen      2
        `define spIdAluOpbSrcWidth      `spIdAluOpbSrcLen-1:0
        
        `define spIdRegsWaddrSrcLen      2
        `define spIdRegsWaddrSrcWidth   `spIdRegsWaddrSrcLen-1:0
        
       
    //EXE
        `define spExeRegsWdataSrcLen   1
        `define spExeRegsWdataSrcWidth  `spExeRegsWdataSrcLen-1:0
    //MEM
        `define spMemReqLen             1
        `define spMemReqWidth           `spMemReqLen-1:0
        
        `define spMemMemWeLen           1
        `define spMemMemWeWidth         `spMemMemWeLen-1:0
    
        `define spMemRegsWdataSrcLen 1 //mem阶段传给reg的写入数据控制
        `define spMemRegsWdataSrcWidth  `spMemRegsWdataSrcLen-1:0
    
         
        `define spMemMemDataSrcLen 3 //me
        `define spMemMemDataSrcWidth  `spMemMemDataSrcLen-1:0
    
     
    //PC修改
        `define spIdBtypeLen 3
        `define spIdBtypeWidth          `spIdBtypeLen-1:0
        
        `define spIdJmpLen 1
        `define spIdJmpWidth            `spIdJmpLen-1:0
        
        `define spIdJmpBaseAddrSrcLen 1
        `define spIdJmpBaseAddrSrcWidth `spIdJmpBaseAddrSrcLen-1:0
        
        `define spIdJmpOffsAddrSrcLen  1
        `define spIdJmpOffsAddrSrcWidth `spIdJmpOffsAddrSrcLen-1:0
//总线宽度
       `define PcInstBusLen `PcLen+`InstLen
        `define PcInstBusWidth `PcInstBusLen-1:0
    //ifid
        `define IfidToIdBusLen 64
        `define IfidToIdBusWidth   `IfidToIdBusLen-1:0
     //寄存器组
        `define RegsToIdBusLen 64 //32+32
        `define RegsToIdBusWidth  `RegsToIdBusLen-1:0  
    //时钟
        `define CoutToIdBusLen 128//64+64
        `define CoutToIdBusWidth `CoutToIdBusLen-1:0
    
    //Id阶段
        `define OdToIspBusLen   64+16+4+32+`InstLen
        `define OdToIspBusWidth `OdToIspBusLen-1:0
        
        `define IdToExBusLen `AluOpLen+`AluOperLen+`AluOperLen+`spExeRegsWdataSrcLen+`EnLen+`EnLen+`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`MemDataLen+`EnLen+`RegsAddrLen+`RegsDataLen
        `define IdToExBusWidth `IdToExBusLen-1:0
        
        `define IdToPreifBusLen  `PcLen+1
        `define IdToPreifBusWidth `IdToPreifBusLen-1:0
        
        `define IdToRegsBusLen  `RegsAddrLen+`RegsAddrLen
        `define IdToRegsBusWidth `IdToRegsBusLen:0
        
    //EXE阶段
        `define ExToIdBusLen  `EnLen+`RegsAddrLen+`RegsDataLen+`spMemRegsWdataSrcLen
        `define ExToIdBusWidth `ExToIdBusLen-1:0
        
        `define ExToMemBusLen   `EnLen+`EnLen+`spMemRegsWdataSrcLen+`spMemMemDataSrcLen+`MemAddrLen+`MemDataLen+1+`RegsAddrLen+`RegsDataLen
        `define ExToMemBusWidth `ExToMemBusLen-1:0
    //MEM阶段
        `define MemToIdBusLen  `EnLen+`RegsAddrLen+`RegsDataLen
        `define MemToIdBusWidth `MemToIdBusLen-1:0
        
        `define MemToDataBusLen `EnLen+`EnLen+`MemAddrLen+`MemDataLen
        `define MemToDataBusWidth `MemToDataBusLen-1:0 
        
        `define MemToWbBusLen `RegsAddrLen+`RegsDataLen+`EnLen
        `define MemToWbBusWidth  `MemToWbBusLen-1 :0
`endif
