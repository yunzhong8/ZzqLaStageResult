/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：指令的信号的地址
*输出：指令对应的信号，信号组成{控制信号,aluop}
*模块功能：
*
*/
/*************\
bug:
\*************/
`include "DefineLoogLenWidth.h"
`include "DefineInstSign.h"
module InstSignProduce(
    input  wire  inst_sign_addr_i      ,
    output  wire  inst_sign_o   ,

    output  wire  inst_aluop_o
);
/***************************************parameter define(常量定义)**************************************/

/***************************************variable define(变量定义)**************************************/
    wire inst_sign_addr_i;
/*******************************complete logical function (逻辑功能实现)*******************************/
case(inst_sign_addr_i)
    //无条件跳转
        `BInstSignAddr:         inst_sign_o = `BInstSign           ;
        `BlInstSignAddr:        inst_sign_o =  `BlInstSign         ;
        `JirlInstSignAddr:      inst_sign_o = `JirlInstSign        ;
    //有条件跳转
    `BeqInstSignAddr:       inst_sign_o = `BeqInstSign         ;   
    `BneInstSignAddr:       inst_sign_o = `BneInstSign         ;
    `BltInstSignAddr:       inst_sign_o = `BltInstSign         ;
    `BgeInstSignAddr:       inst_sign_o = `BgeInstSign         ;
    `BltuInstSignAddr:      inst_sign_o = `BltuInstSign        ;
    `BeguInstSignAddr:      inst_sign_o = `BeguInstSign        ;
    //原子访存指令
    `LlwInstSignAddr:       inst_sign_o = `LlwInstSign         ;
    `ScwInstSignAddr:       inst_sign_o = `ScwInstSign         ;
    //csr访问指令
    `CsrrdInstSignAddr:     inst_sign_o = `CsrrdInstSign       ;
    `CsrwrInstSignAddr:     inst_sign_o = `CsrwrInstSign       ;
    `CsrxchgInstSignAddr:   inst_sign_o = `CsrxchgInstSign     ;
    //比较指令
    `SltiInstSignAddr:      inst_sign_o = `SltiInstSign        ;
    `SltuInstSignAddr:      inst_sign_o = `SltuInstSign        ;
    //简单算数运算指令  
    `AddiInstSignAddr:      inst_sign_o = `AddiInstSign        ;
    //逻辑运算指令
    `AndiInstSignAddr:      inst_sign_o = `AndiInstSign        ;
    `OriInstSignAddr:       inst_sign_o = `OriInstSign         ;
    `XoriInstSignAddr:      inst_sign_o = `XoriInstSign        ;
    //load指令·
    `LdbInstSignAddr:       inst_sign_o = `LdbInstSign         ;
    `LdhInstSignAddr:       inst_sign_o = `LdhInstSign         ;
    `LdwInstSignAddr:       inst_sign_o = `LdwInstSign         ;
    //store指令· 
    `StbInstSignAddr:       inst_sign_o = `StbInstSign         ;
    `SthInstSignAddr:       inst_sign_o = `SthInstSign         ;
    `StwInstSignAddr:       inst_sign_o = `StwInstSign         ;
    //load指令0扩展
    `LdbuInstSignAddr:      inst_sign_o = `LdbuInstSign        ;
    `LdhuInstSignAddr:      inst_sign_o = `LdhuInstSign        ;
    //cache预取
    `PreldInstSignAddr:     inst_sign_o = `PreldInstSign       ;
    //cache维护指令
    `CacopInstSignAddr:     inst_sign_o = `CacopInstSign       ;
    //简单算数运算指令
    `AddwInstSignAddr:      inst_sign_o = `AddwInstSign        ;
    `SubInstSignAddr:       inst_sign_o = `SubInstSign         ;
    //比较指令 
    `SltInstSignAddr:       inst_sign_o = `SltInstSign         ;
    `SltuInstSignAddr:      inst_sign_o =   `SltuInstSign      ;
    //逻辑运算指令
    `AndInstSignAddr:       inst_sign_o = `AndInstSign         ;
    `OrInstSignAddr:        inst_sign_o = `OrInstSign          ;
    `XorInstSignAddr:       inst_sign_o = `XorInstSign         ;
    `NorInstSignAddr:       inst_sign_o =  `NorInstSign        ;
    //移位指令
    `SllwInstSignAddr:      inst_sign_o = `SllwInstSign       ;
    `SrlwInstSignAddr:      inst_sign_o = `SrlwInstSign       ;
    `SrawInstSignAddr:      inst_sign_o = `SrawInstSign       ;
    //乘法指令
    `MulwInstSignAddr:      inst_sign_o = `SrawInstSign       ;
    `MulhwInstSignAddr:     inst_sign_o = `MulhwInstSign      ;
    `MulhwuInstSignAddr:    inst_sign_o = `MulhwuInstSign     ;
    //除法
    `DivwInstSignAddr:      inst_sign_o = `DivwInstSign       ;
    `ModwInstSignAddr:      inst_sign_o = `ModwInstSign       ;
    `DivwuInstSignAddr:     inst_sign_o = `DivwuInstSign      ;
    `ModwuInstSignAddr:     inst_sign_o = `ModwuInstSign      ;
    //停机指令
    `SyscallInstSignAddr:   inst_sign_o = `SyscallInstSign   ;
    `BreakInstSignAddr:     inst_sign_o = `BreakInstSign     ;
    //移位指令 
    `SlliwInstSignAddr:     inst_sign_o =  `SlliwInstSign    ;
    `SrliwInstSignAddr:     inst_sign_o = `SrliwInstSign     ;
    `SraiwInstSignAddr:     inst_sign_o = `SraiwInstSign     ;
    //栅栈指令
    `DbarInstSignAddr:      inst_sign_o = `DbarInstSign      ;
    `IbarInstSignAddr:      inst_sign_o = `IbarInstSign      ;
    //TLB维护指令
    `InvtlbInstSignAddr:    inst_sign_o = `InvtlbInstSign    ;
    //其他指令
    `IdleInstSignAddr:      inst_sign_o = `IdleInstSign     ;
    //时间预取指令
    `RdcntidwInstSignAddr:  inst_sign_o = `RdcntidwInstSign ;
    `RdcntvlwInstSignAddr:  inst_sign_o = `RdcntvlwInstSign ;
    `RdcntvhwInstSignAddr:  inst_sign_o = `RdcntvhwInstSign ;
    //TLB维护指令
    `TlbsrchInstSignAddr:   inst_sign_o = `TlbsrchInstSign ;
    `TlbrdInstSignAddr:     inst_sign_o = `TlbrdInstSign ;
    `TlbwrInstSignAddr:     inst_sign_o = `TlbwrInstSign ;
    `TlbfillInstSignAddr:   inst_sign_o = `TlbfillInstSign;
    `InvtlbInstSignAddr:    inst_sign_o = `InvtlbInstSign;
    //其他指令 
    `ErtnInstSignAddr:      inst_sign_o = `ErtnInstSign;
            default:            inst_sign_o = `NoInstSign           ;
    endcase

endmodule
