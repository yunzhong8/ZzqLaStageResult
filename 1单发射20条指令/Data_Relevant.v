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

module Data_Relevant(
input wire rstL,
//输入
    //执行阶段寄存器组信息
        input wire                   ex_regs_we_i,
        input wire                   ex_memtoreg_i,
        input wire [`RegsAddrWidth]    ex_regs_waddr_i,
    //存储阶段寄存器组信息
        input wire                   mem_regs_we_i,
        input wire[`RegsAddrWidth]     mem_regs_waddr_i,
    //正常寄存器组读出数据和读地址
//        input wire                   regs_re1_i,
        input wire [`RegsAddrWidth]    regs_rwaddr1_i,
        
//        input wire                   regs_re2_i,
        input wire [`RegsAddrWidth]    regs_rwaddr2_i,
//输出
    //1号端口数据相关   
        output reg exe_relate1_o,                   //为1表示存在相关     
        output reg mem_relate1_o,     
    //2号端口数据相关
        output reg exe_relate2_o,                   //为1表示存在相关
        output reg mem_relate2_o
    );
//输入：
//输出：
//功能：
//错误：reg类型在if中要更新

//寄存器组1号端口数据相关    
always@(*)begin
    if(rstL ==`RstEnable)begin
            exe_relate1_o<=1'b0;
    end else begin
        if(ex_regs_waddr_i == regs_rwaddr1_i&&ex_regs_we_i==`WriteEnable) begin//首先查看是否是执行阶段ex数据相关
            exe_relate1_o<=1'b1;
        end else begin
            exe_relate1_o<=1'b0;
        end
    end
end
always@(*)begin
    if(rstL ==`RstEnable)begin
            mem_relate1_o<=1'b0;
    end else if(mem_regs_waddr_i == regs_rwaddr1_i && mem_regs_we_i==`WriteEnable)begin//其次查看是存储阶段MEM数据相关
            mem_relate1_o<=1'b1;
    end else begin
            mem_relate1_o<=1'b0;
    end
end
                    
//寄存器组2号端口数据相关    
always@(*)begin
    if(rstL ==`RstEnable)begin
        exe_relate2_o<=1'b0;
    end else if(ex_regs_waddr_i == regs_rwaddr2_i&&ex_regs_we_i==`WriteEnable)begin//首先查看是否是执行阶段ex数据相关      
        exe_relate2_o<=1'b1;
    end else begin
        exe_relate2_o<=1'b0;
    end
end
always@(*)begin
    if(rstL ==`RstEnable)begin
        mem_relate2_o<=1'b0;
    end else if(mem_regs_waddr_i == regs_rwaddr2_i && mem_regs_we_i==`WriteEnable)begin//其次查看是存储阶段MEM数据相关           
        mem_relate2_o<=1'b1;
    end else
        mem_relate2_o<=1'b0;
end
                     
endmodule
