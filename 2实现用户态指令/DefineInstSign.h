/*
 * SpDefine.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"
`ifndef DEFINESP_H
`define DEFINESP_H

//控制信号
             `define NopInstSign           `SignLen'h000000000
 //Op6指令
     //跳转指令
       //无条件跳转
              `define BInstSign            `SignLen'h280000000
              `define BlInstSign           `SignLen'h281000060
              `define JirlInstSign         `SignLen'h181000040
       //条件跳转
             `define BeqInstSign           `SignLen'h010000001  
             `define BneInstSign           `SignLen'h020000001  
             `define BltInstSign           `SignLen'h030000001 
             `define BgeInstSign           `SignLen'h040000001 
             `define BltuInstSign          `SignLen'h050000001 
             `define BgeuInstSign          `SignLen'h060000001

 //op7指令
     //立即数转载指令
             `define Lu12iwInstSign        `SignLen'h001000000

     //pc相对计算指令
           `define PcaddiInstSign           `SignLen'h00000000 //基础指令集不存在
           `define Pcaddu12iInstSign        `SignLen'h00100100E
 //OP8指令
     //原子访存指令
            `define LlwInstSign            `SignLen'h000000000
            `define ScwInstSign            `SignLen'h000000000
 //Op10指令
     //比较指令
            `define SltiInstSign           `SignLen'h001001008

            `define SltuiInstSign          `SignLen'h001001008
    //简单运算指令
            `define AddiwInstSign           `SignLen'h001001008
    //逻辑运算指令
            `define AndiInstSign           `SignLen'h001001004
            `define OriInstSign            `SignLen'h001001004
            `define XoriInstSign           `SignLen'h001001004
       //访存指令
        //加载指令
            `define LdbInstSign            `SignLen'h001060008
            `define LdhInstSign            `SignLen'h0010A0008
            `define LdwInstSign            `SignLen'h001020008

         //存储指令
            `define StbInstSign            `SignLen'h000070009
            `define SthInstSign            `SignLen'h0000B0009
            `define StwInstSign            `SignLen'h000030009
        //0扩展加载指令
            `define LdbuInstSign           `SignLen'h0010E0008
            `define LdhuInstSign           `SignLen'h001120008
        //cache预取指令
            `define PreldInstSign          `SignLen'h000000000
 //op17指令
     //简单算术指令
             `define AddwInstSign          `SignLen'h001001000
             `define SubwInstSign          `SignLen'h001001000
     //比较指令
             `define SltInstSign           `SignLen'h001001000
             `define SltuInstSign          `SignLen'h001001000
     //逻辑运算
             `define AndInstSign           `SignLen'h001001000
             `define OrInstSign            `SignLen'h001001000
             `define XorInstSign           `SignLen'h001001000
             `define NorInstSign           `SignLen'h001001000
             `define NandInstSign          `SignLen'h000000000 //基础指令集不存在的指令
     //移位指令
             `define SllwInstSign          `SignLen'h001001000
             `define SrlwInstSign          `SignLen'h001001000
             `define SrawInstSign          `SignLen'h001001000

     //复杂运算指令
     //乘法指令
             `define MulwInstSign          `SignLen'h001001000
             `define MulhwInstSign         `SignLen'h001002000
             `define MulhwuInstSign        `SignLen'h001002000
        //除法指令
             `define DivwInstSign          `SignLen'h001001000
             `define ModwInstSign          `SignLen'h001001000
             `define DivwuInstSign         `SignLen'h001001000
             `define ModwuInstSign         `SignLen'h001001000
       //杂项指令
             `define SyscallInstSign       `SignLen'h000000000
             `define BreakInstSign         `SignLen'h000000000
      //移位指令
             `define SlliwInstSign         `SignLen'h001001004
             `define SrliwInstSign         `SignLen'h001001004
             `define SraiwInstSign         `SignLen'h001001004
     //栅障指令
             `define DbarInstSign          `SignLen'h000000000
             `define IbarInstSign          `SignLen'h000000000
 //op22
     //时间预取指令
            `define RdcntidwInstSign       `SignLen'h000000160
            `define RdcntvlwInstSign       `SignLen'h0000000C0
            `define RdcntvhwInstSign       `SignLen'h000000100
//核心态指令
    //csr访问指令
           `define CsrrdInstSign           `SignLen'h000000000
           `define CsrwrInstSign           `SignLen'h000000000
           `define CsrxchgInstSign         `SignLen'h000000000
    //cache维护指令                                      
           `define CacopInstSign           `SignLen'h000000000
     //Tlb维护指令                                       
          `define TlbsrchInstSign          `SignLen'h000000000
          `define TlbrdInstSign            `SignLen'h000000000
          `define TlbwrInstSign            `SignLen'h000000000
          `define TlbfillInstSign          `SignLen'h000000000
         `define InvtlbInstSign            `SignLen'h000000000
    //其他指令                                           
         `define IdleInstSign              `SignLen'h000000000
         `define ErtnInstSign              `SignLen'h000000000
         `define NoInstSign                `SignLen'h000000000



`endif /* !SPDEFINE_H */
