/*
 * SpDefine.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"
`include "DefineIdSign.h"
`include "DefineExSign.h"
`include "DefineMemSign.h"
`include "DefineWbSign.h"
`include "DefineBJSign.h"

`ifndef DEFINESP_H
`define DEFINESP_H

//控制信号
             `define NopInstSign           {`NopInstIdSign,`NopInstExSign,`NopInstMemSign,`NopInstWbSign,`NopInstBJSign}
 //Op6指令
     //跳转指令
       //无条件跳转
              `define BInstSign            { `BInstIdSign, `BInstExSign, `BInstMemSign, `BInstWbSign, `BInstBJSign   }
              `define BlInstSign           { `BlInstIdSign,`BlInstExSign,`BlInstMemSign,`BlInstWbSign,`BlInstBJSign   }
              `define JirlInstSign         { `JirlInstIdSign,`JirlInstExSign,`JirlInstMemSign,`JirlInstWbSign,`JirlInstBJSign   }
       //条件跳转
             `define BeqInstSign           {  `BeqInstIdSign,`BeqInstExSign,`BeqInstMemSign,`BeqInstWbSign,`BeqInstBJSign } 
             `define BneInstSign           {  `BneInstIdSign, `BneInstExSign,`BneInstMemSign,`BneInstWbSign,`BneInstBJSign }
             `define BltInstSign           {  `BltInstIdSign,`BltInstExSign,`BltInstMemSign,`BltInstWbSign,`BltInstBJSign  }
             `define BgeInstSign           {  `BgeInstIdSign,`BgeInstExSign,`BgeInstMemSign,`BgeInstWbSign,`BgeInstBJSign  }
             `define BltuInstSign          {  `BltuInstIdSign,`BltuInstExSign, `BltuInstMemSign, `BltuInstWbSign, `BltuInstBJSign   }
             `define BgeuInstSign          {  `BgeuInstIdSign,`BgeuInstExSign, `BgeuInstMemSign, `BgeuInstWbSign, `BgeuInstBJSign  }

 //op7指令
     //立即数转载指令
             `define Lu12iwInstSign        { `Lu12iwInstIdSign,`Lu12iwInstExSign, `Lu12iwInstMemSign, `Lu12iwInstWbSign, `Lu12iwInstBJSign   }

     //pc相对计算指令
           `define PcaddiInstSign          { `PcaddiInstIdSign,`PcaddiInstExSign,`PcaddiInstMemSign,`PcaddiInstWbSign,`PcaddiInstBJSign   } //基础指令集不存在
           `define Pcaddu12iInstSign       { `Pcaddu12iInstIdSign,`Pcaddu12iInstExSign, `Pcaddu12iInstMemSign, `Pcaddu12iInstWbSign, `Pcaddu12iInstBJSign   }

 //OP8指令
     //原子访存指令
            `define LlwInstSign            { `LlwInstIdSign,`LlwInstExSign, `LlwInstMemSign, `LlwInstWbSign, `LlwInstBJSign    }
            `define ScwInstSign            { `ScwInstIdSign,`ScwInstExSign, `ScwInstMemSign, `ScwInstWbSign, `ScwInstBJSign   }
 //Op10指令
     //比较指令
            `define SltiInstSign           { `SltiInstIdSign,`SltiInstExSign,`SltiInstMemSign,`SltiInstWbSign,`SltiInstBJSign   }

            `define SltuiInstSign          { `SltuiInstIdSign,`SltuiInstExSign,`SltuiInstMemSign,`SltuiInstWbSign,`SltuiInstBJSign   }
    //简单运算指令
            `define AddiwInstSign          { `AddiwInstIdSign,`AddiwInstExSign, `AddiwInstMemSign, `AddiwInstWbSign, `AddiwInstBJSign   }
    //逻辑运算指令
            `define AndiInstSign           { `AndiInstIdSign,`AndiInstExSign, `AndiInstMemSign, `AndiInstWbSign, `AndiInstBJSign   }
            `define OriInstSign            { `OriInstIdSign,`OriInstExSign,`OriInstMemSign,`OriInstWbSign,`OriInstBJSign   }
            `define XoriInstSign           { `XoriInstIdSign,`XoriInstExSign,`XoriInstMemSign,`XoriInstWbSign,`XoriInstBJSign   }
       //访存指令
        //加载指令
            `define LdbInstSign            { `LdbInstIdSign,`LdbInstExSign, `LdbInstMemSign, `LdbInstWbSign, `LdbInstBJSign   }
            `define LdhInstSign            { `LdhInstIdSign,`LdhInstExSign,`LdhInstMemSign,`LdhInstWbSign,`LdhInstBJSign   }
            `define LdwInstSign            { `LdwInstIdSign,`LdwInstExSign,`LdwInstMemSign,`LdwInstWbSign,`LdwInstBJSign   }


         //存储指令
            `define StbInstSign            {  `StbInstIdSign,`StbInstExSign,`StbInstMemSign,`StbInstWbSign,`StbInstBJSign  }
            `define SthInstSign            {  `SthInstIdSign,`SthInstExSign,`SthInstMemSign,`SthInstWbSign,`SthInstBJSign  }
            `define StwInstSign            {  `StwInstIdSign,`StwInstExSign,`StwInstMemSign,`StwInstWbSign,`StwInstBJSign  }
        //0扩展加载指令
            `define LdbuInstSign           { `LdbuInstIdSign,`LdbuInstExSign,`LdbuInstMemSign,`LdbuInstWbSign,`LdbuInstBJSign   }
            `define LdhuInstSign           { `LdhuInstIdSign,`LdhuInstExSign, `LdhuInstMemSign, `LdhuInstWbSign, `LdhuInstBJSign   }
        //cache预取指令
            `define PreldInstSign          { `PreldInstIdSign,`PreldInstExSign, `PreldInstMemSign, `PreldInstWbSign, `PreldInstBJSign    }
 //op17指令
     //简单算术指令
             `define AddwInstSign          { `AddwInstIdSign,`AddwInstExSign,`AddwInstMemSign,`AddwInstWbSign,`AddwInstBJSign   }
             `define SubwInstSign          { `SubwInstIdSign,`SubwInstExSign,`SubwInstMemSign,`SubwInstWbSign,`SubwInstBJSign   }
     //比较指令
             `define SltInstSign           { `SltInstIdSign,`SltInstExSign, `SltInstMemSign, `SltInstWbSign, `SltInstBJSign   }
             `define SltuInstSign          { `SltuInstIdSign,`SltuInstExSign,`SltuInstMemSign,`SltuInstWbSign,`SltuInstBJSign   }
     //逻辑运算
             `define AndInstSign           { `AndInstIdSign,`AndInstExSign,`AndInstMemSign,`AndInstWbSign,`AndInstBJSign   }
             `define OrInstSign            { `OrInstIdSign,`OrInstExSign,`OrInstMemSign,`OrInstWbSign,`OrInstBJSign  }
             `define XorInstSign           { `XorInstIdSign,`XorInstExSign, `XorInstMemSign, `XorInstWbSign, `XorInstBJSign   }
             `define NorInstSign           { `NorInstIdSign,`NorInstExSign, `NorInstMemSign, `NorInstWbSign, `NorInstBJSign   }
             `define NandInstSign          { `NandInstIdSign,`NandInstExSign,`NandInstMemSign,`NandInstWbSign,`NandInstBJSign   }//基础指令集不存在的指令
     //移位指令
             `define SllwInstSign          { `SllwInstIdSign,`SllwInstExSign,`SllwInstMemSign,`SllwInstWbSign,`SllwInstBJSign   }
             `define SrlwInstSign          { `SrlwInstIdSign,`SrlwInstExSign,`SrlwInstMemSign,`SrlwInstWbSign,`SrlwInstBJSign   }
             `define SrawInstSign          { `SrawInstIdSign,`SrawInstExSign,`SrawInstMemSign,`SrawInstWbSign,`SrawInstBJSign   }

     //复杂运算指令
     //乘法指令
             `define MulwInstSign          { `MulwInstIdSign,`MulwInstExSign,`MulwInstMemSign,`MulwInstWbSign,`MulwInstBJSign   }
             `define MulhwInstSign         { `MulhwInstIdSign,`MulhwInstExSign, `MulhwInstMemSign, `MulhwInstWbSign, `MulhwInstBJSign   }
             `define MulhwuInstSign        { `MulhwuInstIdSign,`MulhwuInstExSign,`MulhwuInstMemSign,`MulhwuInstWbSign,`MulhwuInstBJSign   }
        //除法指令
             `define DivwInstSign          { `DivwInstIdSign,`DivwInstExSign,`DivwInstMemSign,`DivwInstWbSign,`DivwInstBJSign   }
             `define ModwInstSign          { `ModwInstIdSign,`ModwInstExSign,`ModwInstMemSign,`ModwInstWbSign,`ModwInstBJSign  }
             `define DivwuInstSign         { `DivwuInstIdSign,`DivwuInstExSign,`DivwuInstMemSign,`DivwuInstWbSign,`DivwuInstBJSign   }
             `define ModwuInstSign         { `ModwuInstIdSign,`ModwuInstExSign,`ModwuInstMemSign,`ModwuInstWbSign,`ModwuInstBJSign   }
       //杂项指令
             `define SyscallInstSign       { `SyscallInstIdSign,`SyscallInstExSign,`SyscallInstMemSign,`SyscallInstWbSign,`SyscallInstBJSign   }
             `define BreakInstSign         { `BreakInstIdSign,`BreakInstExSign, `BreakInstMemSign, `BreakInstWbSign, `BreakInstBJSign   }
      //移位指令
             `define SlliwInstSign         { `SlliwInstIdSign,`SlliwInstExSign,`SlliwInstMemSign,`SlliwInstWbSign,`SlliwInstBJSign   }
             `define SrliwInstSign         { `SrliwInstIdSign,`SrliwInstExSign,`SrliwInstMemSign,`SrliwInstWbSign,`SrliwInstBJSign   }
             `define SraiwInstSign         {  `SraiwInstIdSign, `SraiwInstExSign, `SraiwInstMemSign, `SraiwInstWbSign, `SraiwInstBJSign  }
     //栅障指令
             `define DbarInstSign          {  `DbarInstIdSign,`DbarInstExSign,`DbarInstMemSign,`DbarInstWbSign,`DbarInstBJSign  }
             `define IbarInstSign          {  `IbarInstIdSign,`IbarInstExSign, `IbarInstMemSign, `IbarInstWbSign, `IbarInstBJSign  }
 //op22
     //时间预取指令
            `define RdcntidwInstSign       {  `RdcntidwInstIdSign,`RdcntidwInstExSign,`RdcntidwInstMemSign,`RdcntidwInstWbSign,`RdcntidwInstBJSign  }
            `define RdcntvlwInstSign       { `RdcntvlwInstIdSign,`RdcntvlwInstExSign, `RdcntvlwInstMemSign, `RdcntvlwInstWbSign, `RdcntvlwInstBJSign   }
            `define RdcntvhwInstSign       {  `RdcntvhwInstIdSign,`RdcntvhwInstExSign,`RdcntvhwInstMemSign,`RdcntvhwInstWbSign,`RdcntvhwInstBJSign  }
//核心态指令
    //csr访问指令
           `define CsrrdInstSign           { `CsrrdInstIdSign,`CsrrdInstExSign,`CsrrdInstMemSign,`CsrrdInstWbSign,`CsrrdInstBJSign   }

           `define CsrwrInstSign           {  `CsrwrInstIdSign,`CsrwrInstExSign,`CsrwrInstMemSign,`CsrwrInstWbSign,`CsrwrInstBJSign  }
           `define CsrxchgInstSign         {  `CsrxchgInstIdSign,`CsrxchgInstExSign,`CsrxchgInstMemSign,`CsrxchgInstWbSign,`CsrxchgInstBJSign  }
           
    //cache维护指令                        {    }
           `define CacopInstSign           { `CacopInstIdSign,  `CacopInstExSign,`CacopInstMemSign,`CacopInstWbSign,`CacopInstBJSign }
     //Tlb维护指令                         {    }
          `define TlbsrchInstSign          { `TlbsrchInstIdSign,`TlbsrchInstExSign,  `TlbsrchInstMemSign,  `TlbsrchInstWbSign,  `TlbsrchInstBJSign   }
          `define TlbrdInstSign            { `TlbrdInstIdSign,`TlbrdInstExSign,`TlbrdInstMemSign,`TlbrdInstWbSign,`TlbrdInstBJSign   }
          `define TlbwrInstSign            {  `TlbwrInstIdSign,`TlbwrInstExSign, `TlbwrInstMemSign, `TlbwrInstWbSign, `TlbwrInstBJSign  }
          `define TlbfillInstSign          {  `TlbfillInstIdSign,`TlbfillInstExSign,`TlbfillInstMemSign,`TlbfillInstWbSign,`TlbfillInstBJSign  }
         `define InvtlbInstSign            {  `InvtlbInstIdSign,`InvtlbInstExSign,`InvtlbInstMemSign,`InvtlbInstWbSign,`InvtlbInstBJSign  }
    //其他指令                             {    }
         `define IdleInstSign              { `IdleInstIdSign,`IdleInstExSign,`IdleInstMemSign,`IdleInstWbSign,`IdleInstBJSign   }
         `define ErtnInstSign              { `ErtnInstIdSign,`ErtnInstExSign,`ErtnInstMemSign,`ErtnInstWbSign,`ErtnInstBJSign   }



`endif /* !SPDEFINE_H */
