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
`include "DefineLoogLenWidth.h"
module Reg_File_Box(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input  wire [`IdToRegsBusWidth]id_to_ibus           ,
    input  wire [`MemToWbBusWidth]wb_to_ibus         ,
    output wire [`RegsToIdBusWidth]to_id_obus         
);

/***************************************input variable define(输入变量定义)**************************************/
    wire [`RegsAddrWidth] raddr1,raddr2;
    wire we;
    wire [`RegsAddrWidth]waddr;
    wire [`RegsDataWidth]wdata,rdata1,rdata2;

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

/****************************************input decode(输入解码)***************************************/
assign {raddr1,raddr2} = id_to_ibus;
assign {we,waddr,wdata} = wb_to_ibus; 

/****************************************output code(输出解码)***************************************/
assign to_id_obus = {rdata1,rdata2};
/*******************************complete logical function (逻辑功能实现)*******************************/
         Reg_File RFI(
                   .rf_in_rstL   ( rst_n )        ,
                   .rf_in_clk    ( clk )         ,
                   
                     //输入
                         //输入寄存器读读
                       .rf_in_re1           (   1'b1              )      ,
                       .rf_in_raddr1        (    raddr1 )      ,
                       .rf_in_re2           (   1'b1              )      ,
                       .rf_in_raddr2        (   raddr2  )      , 
                       //写数据
                        .rf_in_we           (   we      )      ,
                        .rf_in_waddr        (   waddr   )      ,
                        .rf_in_wdata        (   wdata   )      ,
                         
                         
                     //输出寄存器组读
                       .rf_out_rdata1       (  rdata1    )          ,
                       .rf_out_rdata2       (  rdata2    )          
         );
endmodule
