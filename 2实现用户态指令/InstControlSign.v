/*
*作者：zzq
*创建时间：2023-04-05
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
//`include xxx.h
module InstControlSign(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input  wire IT_to_ibus,
    output  wire  [`SignWidth] inst_sign_o   ,
    output wire [`AluOpWidth] inst_aluop_o
);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/
    assign inst_sign_o =      inst_add_w ? `AddwInstSign   :
                              inst_sub_w ? `SubwInstSign   :
                              inst_slt   ? `SltInstSign    :
                              inst_sltu  ? `SltuInstSign   :
                              inst_nor   ? `NorInstSign    :
                              inst_and   ? `AndInstSign    :
                              inst_or    ? `OrInstSign     :
                              inst_xor   ? `XorInstSign    :

                              inst_orn   ? `NorInstSign    : //new
                              inst_andn  ? `NandInstSign   ://new不在基础指令集中
                              inst_sllw  ? `SllwInstSign   :
                              inst_srlw  ? `SrlwInstSign   :
                              inst_sraw  ? `SrawInstSign   :
                              inst_mul_w ? `MulwInstSign   :
                              inst_mulh_w ? `MulhwInstSign :
                              inst_mulhu_w  ? `ModwuInstSign :
                              inst_mod_w  ? `ModwInstSign  :
                              inst_div_w  ? `DivwInstSign  :
                              inst_div_wu ? `DivwuInstSign :
                              inst_mod_wu ? `ModwuInstSign :
                              inst_break  ? `BreakInstSign :
                              inst_syscall ? `SyscallInstSign://new

                              inst_slli_w ? `SlliwInstSign :
                              inst_srli_w ? `SrliwInstSign :
                              inst_srai_w ? `SraiwInstSign :

                              inst_idle     ? `IdleInstSign:
                              inst_invtlb   ? `InvtlbInstSign:  
                              inst_dbar     ? `DbarInstSign:  
                              inst_ibar     ? `IbarInstSign  
                              inst_slti     ? `SltInstSign:
                              inst_sltui    ? `SltuInstSign:

                              inst_addi_w ?`AddiwInstSign  :

                              inst_andi  ? `AndiInstSign:
                              inst_ori   ? `OriInstSign :
                              inst_xori  ? `XoriInstSign:
                              inst_ld_b  ? `LdbInstSign :
                              inst_ld_h  ? `LdhInstSign :
                              inst_ld_w  ? `LdwInstSign :
                              inst_st_b  ? `StbInstSign :
                              inst_st_h  ? `SthInstSign :
                              inst_st_w  ? `StwInstSign :
                              inst_ld_bu ? `LdbuInstSign:
                              inst_ld_hu ? `LdhuInstSign :
                              inst_cacop ? `CacopInstSign :
                              inst_preld ? `PreldInstSign :
                              
                              inst_st_w ? `StwInstSign     :
                              inst_jirl ? `JirlInstSign    :
                              inst_b ?`BInstSign           :
                              inst_bl ?`BlInstSign         :
                              inst_beq ?`BeqInstSign       :
                              inst_bne ?`BneInstSign       :
                              inst_blt ?`BltInstSign       :        

                              inst_bge ?`BgeInstSign       :
                              inst_bltu ? `BltuInstSign    :      
                              inst_bgeu ? `BgeuInstSign    :      
                              inst_lu12i_w  ?`Lu12iwInstSign :   
                              inst_pcaddi   ? `PcaddiInstSign ://不在基础指令集中  
                              inst_pcaddu12i ? `Pcaddu12iInstSign : 
                              inst_csrxchg    ? `CsrxchgInstSign:
                              inst_ll_w       ? `LlwInstSign   :
                              inst_sc_w       ? `ScwInstSign   :
                              inst_csrrd      ? `CsrrdInstSign :
                              inst_csrwr      ? `CsrwrInstSign :
                              inst_rdcntid_w  ? `RdcntidwInstSign :
                              inst_rdcntvl_w  ? `RdcntvlwInstSign:
                              inst_rdcntvh_w  ? `RdcntvhwInstSign:
                              inst_ertn       ? `ErtnInstSign:
                              inst_tlbsrch    ? `TlbsrchInstSign:
                              inst_tlbrd      ? `TlbrdInstSign :
                              inst_tlbwr      ? `TlbwrInstSign :
                              inst_tlbfill ? `Lu12iwInstSign : `NoInstSign;

    assign inst_aluop_o =     inst_add_w ? `AddAluOp   :
                              inst_sub_w ? `SubAluOp   :
                              inst_slt   ? `SltAluOp    :
                              inst_sltu  ? `SltuAluOp   :
                              inst_nor   ? `NorAluOp    :
                              inst_and   ? `AndAluOp    :
                              inst_or    ? `OrAluOp     :
                              inst_xor   ? `XorAluOp    : 

                              inst_orn   ? `NorAluOp   : //new
                              inst_andn  ? `AndAluOp    ://new
                              inst_sllw  ? `SllAluOp:
                              inst_srlw  ? `SrlAluOp    :
                              inst_sraw  ? `SraAluOp    :
                              inst_mul_w ? `MulAluOp   :
                              inst_mulh_w ? `MulAluOp :
                              inst_mulhu_w  ? `MuluAluOp  :
                              inst_mod_w  ? `ModAluOp  :
                              inst_div_w  ? `DivAluOp :
                              inst_div_wu ? `DivuAluOp :
                              inst_mod_wu ? `ModuAluOp :
                              inst_break  ? `NoAluOp:
                              inst_syscall ? `NoAluOp ://new

                              inst_slli_w ? `SllAluOp :
                              inst_srli_w ? `SrlAluOp :
                              inst_srai_w ? `SraAluOp :

                              inst_idle     ? `NoAluOp :
                              inst_invtlb   ? `NoAluOp :
                              inst_dbar     ? `NoAluOp :
                              inst_ibar     ? `NoAluOp :
                              inst_slti     ? `SltAluOp:
                              inst_sltui    ? `SltuAluOp:


                              inst_addi_w ?`AddAluOp  :

                              inst_andi  ? `AndAluOp:
                              inst_ori   ? `OrAluOp :
                              inst_xori  ? `XorAluOp:
                              inst_ld_b  ? `AddAluOp:
                              inst_ld_h  ? `AddAluOp  :
                              inst_ld_w  ? `AddAluOp :
                              inst_st_b  ? `AddAluOp  :
                              inst_st_h  ? `AddAluOp  :
                              inst_st_w  ? `AddAluOp :
                              inst_ld_bu ? `AddAluOp:
                              inst_ld_hu ? `AddAluOp :
                              inst_cacop ? `NoAluOp  :
                              inst_preld ? `NoAluOp  :

                              inst_jirl ? `NoAluOp    :
                              inst_b ?`NoAluOp          :
                              inst_bl ?`NoAluOp         :
                              inst_beq ?`NoAluOp       :
                              inst_bne ?`NoAluOp      :

                              inst_bge ?`NoAluOp        :
                              inst_bltu ? `NoAluOp     :
                              inst_bgeu ? `NoAluOp     :

                              inst_lu12i_w  ?`LuiAluOp :

                              inst_pcaddi   ? `NoAluOp  :
                              inst_pcaddu12i ? `NoAluOp  :
                              inst_csrxchg    ? `NoAluOp :
                              inst_ll_w       ? `NoAluOp    :
                              inst_sc_w       ? `NoAluOp    :
                              inst_csrrd      ? `NoAluOp  :
                              inst_csrwr      ? `NoAluOp  :
                              inst_rdcntid_w  ? `NoAluOp  :
                              inst_rdcntvl_w  ? `NoAluOp :
                              inst_rdcntvh_w  ? `NoAluOp :
                              inst_ertn       ? `NoAluOp :
                              inst_tlbsrch    ? `NoAluOp :
                              inst_tlbrd      ? `NoAluOp  :
                              inst_tlbwr      ? `NoAluOp  :
                              inst_tlbfill ? `NoAluOp : `NoAluOp;


endmodule


