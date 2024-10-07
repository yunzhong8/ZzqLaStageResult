`include "DefineLoogLenWidth.h"
module Reg_File(
input wire                           rf_in_rstL,
input wire                           rf_in_clk,
//输入
    //读端口1 
        input wire                    rf_in_re1           , //1号端口读使能信号 
        input wire [`RegsAddrWidth]     rf_in_raddr1        ,// 1号端口读地址 
    //读端口2
        input wire                    rf_in_re2           , //2号端口读使能信号 
        input wire [`RegsAddrWidth]     rf_in_raddr2        ,// 2号端口读地址 
    //写端口 
        input wire                    rf_in_we            ,//写使能信号
        input wire [`RegsAddrWidth]     rf_in_waddr         , //写地址
        input wire [`RegsDataWidth]     rf_in_wdata         ,//写数据
    
//输出
    output reg [`RegsDataWidth]         rf_out_rdata1       , // 1号端口读数据 
    output reg [`RegsDataWidth]         rf_out_rdata2         // 2号端口读数据 
    );
 //功能：寄存器组，可以实现两个端口同时读，一个端口写，读写可以同时进行，读将是待写入的数据
 //*******************************************Define Inner Variable（定义内部变量）***********************************************//
	//存储器组变量定义
	reg[`RegsDataWidth]Regs[0:`RegsNum-1];
	integer i;
//    initial begin
//        for(i=0;i<32;i=i+1) Regs[i] = 0;   // 仿真使用，因为仿真中未初始化的reg初值为X (其实可综合)
//    end
	
 //*******************************************loginc Implementation（程序逻辑实现）***********************************************//
 
 //$$$$$$$$$$$$$$$（写操作模块）$$$$$$$$$$$$$$$$$$// 
 always @(posedge rf_in_clk) begin
        if(rf_in_rstL==`RstEnable)begin
            for(i=0;i<32;i=i+1) Regs[i] = 32'h0000_0000;
        end else begin//系统正常执行
                if( ( rf_in_we == `WriteEnable )&& ( rf_in_waddr !=`RegsAddrLen'h0) )begin//如果写入信号有效且写入的不是$0寄存器
                           Regs[rf_in_waddr] <= rf_in_wdata;
//                           $display($time,," Regs[%d]=%h", rf_in_waddr,Regs[rf_in_waddr]);
                end else begin
                     for(i=0;i<32;i=i+1) Regs[i] = Regs[i];
                end  
         end
         
    end
 //#################（ 模块结束）#################//  	
 
 
 //$$$$$$$$$$$$$$$（1号端口读操作模块）$$0$$$$$$$$$$$$$$$$// 
 always @(*)begin
        if(rf_in_rstL == `RstEnable)begin//复位
            rf_out_rdata1<=`ZeroWord32B;
        end else if(rf_in_raddr1==`RegsAddrLen'h0) begin//如果读入的是$0寄存器
            rf_out_rdata1<=`ZeroWord32B;       
        end else  if( (rf_in_raddr1==rf_in_waddr)&&(rf_in_we == `WriteEnable)&&(rf_in_re1 ==`ReadEnable) )begin //如果写有效，读有效，则读出数据是待写入口的数据
            rf_out_rdata1<=rf_in_wdata;
        end else begin //读
            rf_out_rdata1<=Regs[rf_in_raddr1];
        end                 
 end
  
//#################（ 模块结束）#################//  




//$$$$$$$$$$$$$$$（2号端口读操作模块）$$0$$$$$$$$$$$$$$$$// 
 always @(*)begin
        if( rf_in_rstL == `RstEnable )begin//复位
             rf_out_rdata2<=`ZeroWord32B; 
       end else  if(rf_in_raddr2==`RegsAddrLen'h0)begin//如果读入的是$0寄存器
             rf_out_rdata2<=`ZeroWord32B;
       end else  if( (rf_in_raddr2==rf_in_waddr)&&(rf_in_we == `WriteEnable)&&(rf_in_re2 ==`ReadEnable) )begin//如果写有效，读有效，则读出数据是待写入口的数据
             rf_out_rdata2<=rf_in_wdata;
       end else begin //读
             rf_out_rdata2<=Regs[rf_in_raddr2];
       end
 end
  
//#################（ 模块结束）#################//  
 
endmodule
