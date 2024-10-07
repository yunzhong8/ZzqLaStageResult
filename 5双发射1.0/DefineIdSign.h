/*
 * DefineIdSign.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"

`ifndef DEFINEIDSIGN_H
`define DEFINEIDSIGN_H

//控制信号
              `define             NopInstIdSign            `IdSignLen'h0000
 //Op6指令
     //跳转指令
       //无条件跳转
              `define             BInstIdSign              `IdSignLen'h0000
              `define             BlInstIdSign             `IdSignLen'h00c0
              `define             JirlInstIdSign           `IdSignLen'h0080
       //条件跳转
              `define             BeqInstIdSign            `IdSignLen'h0001  
              `define             BneInstIdSign            `IdSignLen'h0001
              `define             BltInstIdSign            `IdSignLen'h0001
              `define             BgeInstIdSign            `IdSignLen'h0001
              `define             BltuInstIdSign           `IdSignLen'h0001
              `define             BgeuInstIdSign           `IdSignLen'h0001
 //op7指令
     //立即数转载指令
              `define             Lu12iwInstIdSign         `IdSignLen'h0000
     //pc相对计算指令
              `define             PcaddiInstIdSign         `IdSignLen'h0000 //基础指令集不存在
              `define             Pcaddu12iInstIdSign      `IdSignLen'h000E
 //OP8指令
     //原子访存指令
              `define             LlwInstIdSign            `IdSignLen'h0414
              `define             ScwInstIdSign            `IdSignLen'h0014
 //Op10指令
     //比较指令
              `define             SltiInstIdSign           `IdSignLen'h0008
              `define             SltuiInstIdSign          `IdSignLen'h0008
    //简单运算指令
              `define             AddiwInstIdSign          `IdSignLen'h0008
    //逻辑运算指令
              `define             AndiInstIdSign           `IdSignLen'h0004
              `define             OriInstIdSign            `IdSignLen'h0004
              `define             XoriInstIdSign           `IdSignLen'h0004
       //访存指令
        //加载指令
              `define             LdbInstIdSign            `IdSignLen'h0008
              `define             LdhInstIdSign            `IdSignLen'h0008
              `define             LdwInstIdSign            `IdSignLen'h0008
         //存储指令
             `define              StbInstIdSign            `IdSignLen'h0009
             `define              SthInstIdSign            `IdSignLen'h0009
             `define              StwInstIdSign            `IdSignLen'h0009
        //0扩展加载指令
             `define              LdbuInstIdSign           `IdSignLen'h0008
             `define              LdhuInstIdSign           `IdSignLen'h0008
        //cache预取指令
             `define              PreldInstIdSign          `IdSignLen'h0000
 //op17指令
     //简单算术指令
             `define              AddwInstIdSign           `IdSignLen'h0000
             `define              SubwInstIdSign           `IdSignLen'h0000
     //比较指令                                                          0000
             `define              SltInstIdSign            `IdSignLen'h0000
             `define              SltuInstIdSign           `IdSignLen'h0000
     //逻辑运算                                            000 0
             `define              AndInstIdSign            `IdSignLen'h0000
             `define              OrInstIdSign             `IdSignLen'h0000
             `define              XorInstIdSign            `IdSignLen'h0000
             `define              NorInstIdSign            `IdSignLen'h0000
             `define              NandInstIdSign           `IdSignLen'h0000//基础指令集不存在的指令
     //移位指令                                                          0000
             `define              SllwInstIdSign           `IdSignLen'h0000
             `define              SrlwInstIdSign           `IdSignLen'h0000
             `define              SrawInstIdSign           `IdSignLen'h0000
     //复杂运算指令
     //乘法指令
             `define              MulwInstIdSign           `IdSignLen'h0000
             `define              MulhwInstIdSign          `IdSignLen'h0000
             `define              MulhwuInstIdSign         `IdSignLen'h0000
        //除法指令                                                       0000
             `define              DivwInstIdSign           `IdSignLen'h0000
             `define              ModwInstIdSign           `IdSignLen'h0000
             `define              DivwuInstIdSign          `IdSignLen'h0000
             `define              ModwuInstIdSign          `IdSignLen'h0000
       //杂项指令                                                        0000
             `define              SyscallInstIdSign        `IdSignLen'h0000
             `define              BreakInstIdSign          `IdSignLen'h0000
      //移位指
             `define              SlliwInstIdSign          `IdSignLen'h0010
             `define              SrliwInstIdSign          `IdSignLen'h0010
             `define              SraiwInstIdSign          `IdSignLen'h0010
     //栅障指
             `define              DbarInstIdSign           `IdSignLen'h0000
             `define              IbarInstIdSign           `IdSignLen'h0000
 //op22
     //时间预取指令
            `define               RdcntidwInstIdSign       `IdSignLen'h02a0
            `define               RdcntvlwInstIdSign       `IdSignLen'h0180
            `define               RdcntvhwInstIdSign       `IdSignLen'h0200
//核心态指令
    //csr访问指令
           `define                CsrrdInstIdSign          `IdSignLen'h1280
           `define                CsrwrInstIdSign          `IdSignLen'h1281
           `define                CsrxchgInstIdSign        `IdSignLen'h1A81          
    //cache维护指令                                                     
           `define                CacopInstIdSign          `IdSignLen'h0000
     //Tlb维护指令                                         000 
           `define                TlbsrchInstIdSign        `IdSignLen'h0000
           `define                TlbrdInstIdSign          `IdSignLen'h0000
           `define                TlbwrInstIdSign          `IdSignLen'h0000
           `define                TlbfillInstIdSign        `IdSignLen'h0000
           `define                InvtlbInstIdSign         `IdSignLen'h0000
    //其他指令                                                            0000
           `define                IdleInstIdSign           `IdSignLen'h0000
           `define                ErtnInstIdSign           `IdSignLen'h0000
           `define                NoExistIdSign            `IdSignLen'h0000
           





`endif /* !DEFINEIDSIGN_H */
