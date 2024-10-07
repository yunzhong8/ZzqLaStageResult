/*
*作者：zzq
*创建时间：2023-04-09
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：实现csr寄存器组
*
*/
/*************\
bug:crmd有初始化值的忘记rstl复位的是赋值
we使用的是waddr比较，re使用raddr比较，我使用raddr作为比较输出waddr，raddr,真呆
手册说没有规定复位值的寄存器的初始值都是未知的结果crmd初始值是xxxx_xxx8结果错了,因为样例cpu的初始值是0000_0008
\*************/
`include "DefineModuleBus.h"
`include "DefineCsrAddr.h"
module Csr(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input  wire [`WbToCsrWidth] wb_to_ibus ,
    input  wire [`IdToCsrWidth] id_to_ibus,
    output wire [`CsrToIdWidth]to_id_obus 
);

/***************************************input variable define(输入变量定义)**************************************/
    wire [`CsrAddrWidth] csr_raddr_i;
    wire [`CsrAddrWidth] csr_waddr_i;
    wire [`RegsDataWidth] csr_wdata_i;
    wire csr_we_i;
/***************************************output variable define(输出变量定义)**************************************/
    wire [`RegsDataWidth]csr_rdata_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//写使能
wire crmd_we;
wire prmd_we,euen_we,ecfg_we,estat_we, era_we,badv_we,eentry_we;
//tlb
wire tlbidx_we,tlbehi_we,tlbelo0_we,tlbelo1_we;
//目录
wire asid_we,pgdl_we,pgdh_we,pgd_we;
//处理器编号
wire cpuid_we;
//数据保存
wire save0_we,save1_we,save2_we,save3_we;
//定时
wire tid_we,tcfg_we,tval_we,ticlr_we;
//原子访存
wire llbctl_we;
// 
wire tlbrentry_we;
wire ctag_we;
//直接映射配置窗口
wire dmw0_we,dmw1_we;

//读使能
wire crmd_re;
wire prmd_re,euen_re,ecfg_re,estat_re, era_re,badv_re,eentry_re;
//tlb
wire tlbidx_re,tlbehi_re,tlbelo0_re,tlbelo1_re;
//目录
wire asid_re,pgdl_re,pgdh_re,pgd_re;
//处理器编号
wire cpuid_re;
//数据保存
wire save0_re,save1_re,save2_re,save3_re;
//定时
wire tid_re,tcfg_re,tval_re,ticlr_re;
//原子访存
wire llbctl_re;
// 
wire tlbrentry_re;
wire ctag_re;
//直接映射配置窗口
wire dmw0_re,dmw1_re,dmw2_re;

//寄存器
reg [31:0] crmd_reg;
reg [31:0] prmd_reg,euen_reg,ecfg_reg,estat_reg, era_reg,badv_reg,eentry_reg;
//tlb
reg [31:0] tlbidx_reg,tlbehi_reg,tlbelo0_reg,tlbelo1_reg;
//目录
reg [31:0] asid_reg,pgdl_reg,pgdh_reg,pgd_reg;
//处理器编号
reg [31:0] cpuid_reg;
//数据保存
reg [31:0] save0_reg,save1_reg,save2_reg,save3_reg;
//定时
reg [31:0] tid_reg,tcfg_reg,tval_reg,ticlr_reg;
//原子访存
reg [31:0] llbctl_reg;
// 
reg [31:0] tlbrentry_reg;
reg [31:0] ctag_reg;
//直接映射配置窗口
reg [31:0] dmw0_reg,dmw1_reg;

/****************************************input decode(输入解码)***************************************/
    assign {csr_we_i,csr_waddr_i,csr_wdata_i}=wb_to_ibus;
    assign csr_raddr_i = id_to_ibus;
/****************************************output code(输出解码)***************************************/
    assign to_id_obus = csr_rdata_o;
/*******************************complete logical function (逻辑功能实现)*******************************/
//csr寄存器写使能
    assign  crmd_re      = (csr_raddr_i== `CrmdRegAddr                 ) ? 1'b1 : 1'b0;
    assign  prmd_re      = (csr_raddr_i== `PrmdRegAddr                 ) ? 1'b1 : 1'b0;
    assign  euen_re      = (csr_raddr_i== `EuenRegAddr                 ) ? 1'b1 : 1'b0;
    assign  ecfg_re      = (csr_raddr_i== `ECfgRegAddr                 ) ? 1'b1 : 1'b0;
    assign  estat_re     = (csr_raddr_i== `EStatRegAddr                ) ? 1'b1 : 1'b0;
                                                                                  
    assign  era_re       = (csr_raddr_i== `ERARegAddr                  ) ? 1'b1 : 1'b0;
    assign  badv_re      = (csr_raddr_i== `BAdVRegAddr                 ) ? 1'b1 : 1'b0;
    assign  eentry_re    = (csr_raddr_i== `EentryRegAddr               ) ? 1'b1 : 1'b0;
                                                                                  
    assign  tlbidx_re    = (csr_raddr_i== `TlbIdxRegAddr               ) ? 1'b1 : 1'b0;
    assign  tlbehi_re    = (csr_raddr_i== `TlbEhiRegAddr               ) ? 1'b1 : 1'b0;
    assign  tlbelo0_re   = (csr_raddr_i== `TlbElo0RegAddr              ) ? 1'b1 : 1'b0;
    assign  tlbelo1_re   = (csr_raddr_i== `TlbElo1RegAddr              ) ? 1'b1 : 1'b0;
                                                                                  
    assign  asid_re      = (csr_raddr_i== `AsIdRegAddr                 ) ? 1'b1 : 1'b0;
    assign  pgdl_re      = (csr_raddr_i== `PgdLRegAddr                 ) ? 1'b1 : 1'b0;
    assign  pgdh_re      = (csr_raddr_i== `PgdHtRegAddr                ) ? 1'b1 : 1'b0;
    assign  pgd_re       = (csr_raddr_i== `PgdRegAddr                  ) ? 1'b1 : 1'b0;
                                                                                  
    assign  cpuid_re     = (csr_raddr_i== `CpuIdRegAddr                ) ? 1'b1 : 1'b0;
                                                                                  
    assign  save0_re     = (csr_raddr_i== `Save0RegAddr                ) ? 1'b1 : 1'b0;
    assign  save1_re     = (csr_raddr_i== `Save1RegAddr                ) ? 1'b1 : 1'b0;
    assign  save2_re     = (csr_raddr_i== `Save2RegAddr                ) ? 1'b1 : 1'b0;
    assign  save3_re     = (csr_raddr_i== `Save3RegAddr                ) ? 1'b1 : 1'b0;
                                                                                  
    assign  tid_re       = (csr_raddr_i== `TIdRegAddr                  ) ? 1'b1 : 1'b0;
    assign  tcfg_re      = (csr_raddr_i== `TCfgRegAddr                 ) ? 1'b1 : 1'b0;
    assign  tval_re      = (csr_raddr_i== `TValRegAddr                 ) ? 1'b1 : 1'b0;
    assign  ticlr_re     = (csr_raddr_i== `TiClrRegAddr                ) ? 1'b1 : 1'b0;
                                                                                  
    assign  llbctl_re    = (csr_raddr_i== `LlbCtlRegAddr               ) ? 1'b1 : 1'b0;
    assign  tlbrentry_re = (csr_raddr_i== `TlbRentryRegAddr            ) ? 1'b1 : 1'b0;
    assign  ctag_re      = (csr_raddr_i== `CTagRegAddr                 ) ? 1'b1 : 1'b0;
    assign  dmw0_re      = (csr_raddr_i== `DmW0RegAddr                 ) ? 1'b1 : 1'b0;
    assign  dmw1_re      = (csr_raddr_i== `DmW1RegAddr                ) ?  1'b1 : 1'b0;
 
 //csr寄存器写使能
    assign crmd_we      = (csr_waddr_i== `CrmdRegAddr                 ) ? csr_we_i: 1'b0;
    assign prmd_we      = (csr_waddr_i== `PrmdRegAddr                 ) ? csr_we_i: 1'b0;
    assign euen_we      = (csr_waddr_i== `EuenRegAddr                 ) ? csr_we_i: 1'b0;
    assign ecfg_we      = (csr_waddr_i== `ECfgRegAddr                 ) ? csr_we_i: 1'b0;
    assign estat_we     = (csr_waddr_i== `EStatRegAddr                ) ? csr_we_i: 1'b0;
    //                                                                              
    assign era_we       = (csr_waddr_i== `ERARegAddr                  ) ? csr_we_i: 1'b0;
    assign badv_we      = (csr_waddr_i== `BAdVRegAddr                 ) ? csr_we_i: 1'b0;
    assign eentry_we    = (csr_waddr_i== `EentryRegAddr               ) ? csr_we_i: 1'b0;
    //                           w                                                    
    assign tlbidx_we    = (csr_waddr_i== `TlbIdxRegAddr               ) ? csr_we_i: 1'b0;
    assign tlbehi_we    = (csr_waddr_i== `TlbEhiRegAddr               ) ? csr_we_i: 1'b0;
    assign tlbelo0_we   = (csr_waddr_i== `TlbElo0RegAddr              ) ? csr_we_i: 1'b0;
    assign tlbelo1_we   = (csr_waddr_i== `TlbElo1RegAddr              ) ? csr_we_i: 1'b0;
    //                          w                                                    
    assign asid_we      = (csr_waddr_i== `AsIdRegAddr                 ) ? csr_we_i: 1'b0;
    assign pgdl_we      = (csr_waddr_i== `PgdLRegAddr                 ) ? csr_we_i: 1'b0;
    assign pgdh_we      = (csr_waddr_i== `PgdHtRegAddr                ) ? csr_we_i: 1'b0;
    assign pgd_we       = (csr_waddr_i== `PgdRegAddr                  ) ? csr_we_i: 1'b0;
    //                          w                                                    
    assign cpuid_we     = (csr_waddr_i== `CpuIdRegAddr                ) ? csr_we_i: 1'b0;
     //                          w                                                    
    assign save0_we     = (csr_waddr_i== `Save0RegAddr                ) ? csr_we_i: 1'b0;
    assign save1_we     = (csr_waddr_i== `Save1RegAddr                ) ? csr_we_i: 1'b0;
    assign save2_we     = (csr_waddr_i== `Save2RegAddr                ) ? csr_we_i: 1'b0;
    assign save3_we     = (csr_waddr_i== `Save3RegAddr                ) ? csr_we_i: 1'b0;
    //                           w                                                    
    assign tid_we       = (csr_waddr_i== `TIdRegAddr                  ) ? csr_we_i: 1'b0;
    assign tcfg_we      = (csr_waddr_i== `TCfgRegAddr                 ) ? csr_we_i: 1'b0;
    assign tval_we      = (csr_waddr_i== `TValRegAddr                 ) ? csr_we_i: 1'b0;
    assign ticlr_we     = (csr_waddr_i== `TiClrRegAddr                ) ? csr_we_i: 1'b0;
    //                          w                                                    
    assign llbctl_we    = (csr_waddr_i== `LlbCtlRegAddr               ) ? csr_we_i: 1'b0;
    assign tlbrentry_we = (csr_waddr_i== `TlbRentryRegAddr            ) ? csr_we_i: 1'b0;
    assign ctag_we      = (csr_waddr_i== `CTagRegAddr                 ) ? csr_we_i: 1'b0;
    assign dmw0_we      = (csr_waddr_i== `DmW0RegAddr                 ) ? csr_we_i: 1'b0;
    assign dmw1_we      = (csr_waddr_i== `DmW1RegAddr                 ) ? csr_we_i: 1'b0;
    
    
    
// csr读出数据
    assign csr_rdata_o = ( (csr_raddr_i == csr_waddr_i) && csr_we_i )? csr_wdata_i : //写优先
                         ( {32{     crmd_re        }} &  crmd_reg       |  
                           {32{     prmd_re        }} &  prmd_reg       |
                           {32{     euen_re        }} &  euen_reg       |
                           {32{     ecfg_re        }} &  ecfg_reg       |
                           {32{     estat_re       }} &  estat_reg      |
//                           {32{                    }} &                |
                           {32{     era_re         }} &  era_reg        |
                           {32{     badv_re        }} &  badv_reg       |
                           {32{     eentry_re      }} &  eentry_reg     |
 //                          {32{                    }} &                |
                           {32{     tlbidx_re      }} &  tlbidx_reg     |
                           {32{     tlbehi_re      }} &  tlbehi_reg     |
                           {32{     tlbelo0_re     }} &  tlbelo0_reg    |
                           {32{     tlbelo1_re     }} &  tlbelo1_reg    |
//                           {32{                    }} &                |
                           {32{     asid_re        }} &  asid_reg       |
                           {32{     pgdl_re        }} &  pgdl_reg       |
                           {32{     pgdh_re        }} &  pgdh_reg       |
                           {32{     pgd_re         }} &  pgd_reg        |
//                           {32{                    }} &                |
                           {32{     cpuid_re       }} &  cpuid_reg      |
//                           {32{                    }} &                |
                           {32{     save0_re       }} &  save0_reg      |
                           {32{     save1_re       }} &  save1_reg      |
                           {32{     save2_re       }} &  save2_reg      |
                           {32{     save3_re       }} &  save3_reg      |
//                           {32{                    }} &                |
                           {32{     tid_re         }} &  tid_reg        |
                           {32{     tcfg_re        }} &  tcfg_reg       |
                           {32{     tval_re        }} &  tval_reg       |
                           {32{     ticlr_re       }} &  ticlr_reg      |
 //                          
                           {32{     llbctl_re       }} &  llbctl_reg      |
                           {32{     tlbrentry_re   }} &  tlbrentry_reg  |
                           {32{     ctag_re        }} &  ctag_reg       |
                           {32{     dmw0_re        }} &  dmw0_reg       |
                           {32{     dmw1_re        }} &  dmw1_reg       );
                                                        
  
  
  
  
  
  
  
  
  
  
  
                           
                         
                         
 /*******************************complete logical function (寄存器堆)*******************************/ 
 //CRMD当前模式信息寄存器
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        crmd_reg[`CrmdPlvLocation] =   2'b00;
        crmd_reg[`CrmdIeLocation] =   1'b0 ;
        crmd_reg[`CrmdDaLocation] =   1'b1 ;
        crmd_reg[`CrmdPgLocation] =   1'b0 ;
        crmd_reg[`CrmdDatfLocation] = 2'b00;
        crmd_reg[`CrmdDatmLocation] = 2'b00;
        crmd_reg[31:9] = 23'd0; 
    end else if(crmd_we) begin
        crmd_reg <= csr_wdata_i;
    end else begin
        crmd_reg <=crmd_reg;
    end
 end
 
  //例外当期模式信息
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        prmd_reg <=`ZeroWord32B;
    end else if(prmd_we) begin
        prmd_reg <= csr_wdata_i;
    end else begin
        prmd_reg <=prmd_reg;
    end
 end
 
  //EUEN扩展部件使能
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        euen_reg <= `ZeroWord32B;
    end else if(euen_we) begin
        euen_reg <= csr_wdata_i;
    end else begin
        euen_reg <= euen_reg;
    end
 end
  //ECFG例外扩展
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        ecfg_reg <=`ZeroWord32B;
    end else if(ecfg_we) begin
        ecfg_reg <= csr_wdata_i;
    end else begin
        ecfg_reg <= ecfg_reg;
    end
 end
  //ESTAT例外状态
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        estat_reg <=`ZeroWord32B;
    end else if(estat_we) begin
        estat_reg <= csr_wdata_i;
    end else begin
        estat_reg <= estat_reg;
    end
 end
 
  //Era例外返回地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        era_reg <=`ZeroWord32B;
    end else if(era_we) begin
        era_reg <= csr_wdata_i;
    end else begin
        era_reg <= era_reg;
    end
 end
  //BADV出错虚拟地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        badv_reg <=`ZeroWord32B;
    end else if(badv_we) begin
        badv_reg <= csr_wdata_i;
    end else begin
        badv_reg <= badv_reg;
    end
 end 
 //eentry例外入口地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        eentry_reg <=`ZeroWord32B;
    end else if(eentry_we) begin
        eentry_reg <= csr_wdata_i;
    end else begin
        eentry_reg <= eentry_reg;
    end
 end
  //TLBIDX TLB索引
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tlbidx_reg <=`ZeroWord32B;
    end else if(tlbidx_we) begin
        tlbidx_reg <= csr_wdata_i;
    end else begin
        tlbidx_reg <=tlbidx_reg;
    end
 end
  //TLBEHI TLB表项高位
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tlbehi_reg <=`ZeroWord32B;
    end else if(tlbehi_we) begin
        tlbehi_reg <= csr_wdata_i;
    end else begin
        tlbehi_reg <=tlbehi_reg;
    end
 end 
 //TLBELO0 TLB表项低位0
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tlbelo0_reg <=`ZeroWord32B;
    end else if(tlbelo0_we) begin
        tlbelo0_reg <= csr_wdata_i;
    end else begin
        tlbelo0_reg <= tlbelo0_reg;
    end
 end 
 //TLBELo1 TLB表项低位1
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tlbelo1_reg <=`ZeroWord32B;
    end else if(tlbelo1_we) begin
        tlbelo1_reg <= csr_wdata_i;
    end else begin
        tlbelo1_reg <=tlbelo1_reg;
    end
 end 
 //ASID 地址空间标识符
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        asid_reg <=`ZeroWord32B;
    end else if(asid_we) begin
        asid_reg <= csr_wdata_i;
    end else begin
        asid_reg <= asid_reg;
    end
 end 
 //PGDL 低半地址空间全局目录基地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        pgdl_reg <=`ZeroWord32B;
    end else if(pgdl_we) begin
        pgdl_reg <= csr_wdata_i;
    end else begin
        pgdl_reg <=pgdl_reg;
    end
 end 
 //PGDH 高半地址空间全局目录基地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        pgdh_reg <=`ZeroWord32B;
    end else if(pgdh_we) begin
        pgdh_reg <= csr_wdata_i;
    end else begin
        pgdh_reg <=pgdh_reg;
    end
 end 
 //PGD 全局目录地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        pgd_reg <=`ZeroWord32B;
    end else if(pgd_we) begin
        pgd_reg <= csr_wdata_i;
    end else begin
        pgd_reg <=pgd_reg;
    end
 end 
 //CPUID 处理器编号
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        cpuid_reg <=`ZeroWord32B;
    end else if(cpuid_we) begin
        cpuid_reg <= csr_wdata_i;
    end else begin
        cpuid_reg <=cpuid_reg;
    end
 end 
 //SAVE0 数据保存寄存器0
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        save0_reg <=`ZeroWord32B;
    end else if(save0_we) begin
        save0_reg <= csr_wdata_i;
    end else begin
        save0_reg <=save0_reg;
    end
 end 
 //Save1 数据寄存器1
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        save1_reg <=`ZeroWord32B;
    end else if(save1_we) begin
        save1_reg <= csr_wdata_i;
    end else begin
        save1_reg <=save1_reg;
    end
 end 
 //Save2 数据保存寄存器2
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        save2_reg <=`ZeroWord32B;
    end else if(save2_we) begin
        save2_reg <= csr_wdata_i;
    end else begin
        save2_reg <=save2_reg;
    end
 end 
 //save3 数据保存寄存器3
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        save3_reg <=`ZeroWord32B;
    end else if(save3_we) begin
        save3_reg <= csr_wdata_i;
    end else begin
        save3_reg <= save3_reg;
    end
 end 
 //TID 定时器编号
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tid_reg <=`ZeroWord32B;
    end else if(tid_we) begin
        tid_reg <= csr_wdata_i;
    end else begin
        tid_reg <=tid_reg;
    end
 end 
 //TCFg 定时器配置
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tcfg_reg <=`ZeroWord32B;
    end else if(crmd_we) begin
        tcfg_reg <= csr_wdata_i;
    end else begin
        tcfg_reg <=tcfg_reg;
    end
 end 
 //Tval 定时器值
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tval_reg <=`ZeroWord32B;
    end else if(tval_we) begin
        tval_reg <= csr_wdata_i;
    end else begin
        tval_reg <=tval_reg;
    end
 end 
 
 //TIclr 定时中断清除
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        ticlr_reg <=`ZeroWord32B;
    end else if(ticlr_we) begin
        ticlr_reg <= csr_wdata_i;
    end else begin
        ticlr_reg <=ticlr_reg;
    end
 end 
 //LLibt寄存器
always @(posedge clk)begin
    if(rst_n ==`RstEnable)begin
        llbctl_reg <= `ZeroWord32B;
    end else if(llbctl_we) begin
        llbctl_reg <= csr_wdata_i;
    end else begin
        llbctl_reg <= llbctl_reg;
    end
end
 //TLB充填例外入口地址
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        tlbrentry_reg <=`ZeroWord32B;
    end else if(tlbrentry_we) begin
        tlbrentry_reg <= csr_wdata_i;
    end else begin
        tlbrentry_reg <=tlbrentry_reg;
    end
 end 
 //Ctag 高速缓冲标签
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        ctag_reg <=`ZeroWord32B;
    end else if(ctag_we) begin
        ctag_reg <= csr_wdata_i;
    end else begin
        ctag_reg <= ctag_reg;
    end
 end 
 // DMW0 直接映射配置窗口
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        dmw0_reg <=`ZeroWord32B;
    end else if(dmw0_we) begin
        dmw0_reg <= csr_wdata_i;
    end else begin
        dmw0_reg <= dmw0_reg;
    end
 end 
 //DMW1 直接映射窗口1
 always @(posedge clk)begin
    if(rst_n == `RstEnable)begin
        dmw1_reg <=`ZeroWord32B;
    end else if(dmw1_we) begin
        dmw1_reg <= csr_wdata_i;
    end else begin
        dmw1_reg <=dmw1_reg;
    end
 end 
 
 
 

endmodule
