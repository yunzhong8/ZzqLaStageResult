`include "DefineModuleBus.h"
module Reg_File(
               input wire                           rf_in_rstL,
               input wire                           rf_in_clk,
               //输入
               input wire  [`RegsReadIbusWidth] read_ibus,
               input wire  [`RegsWriteBusWidth] write_ibus,
               output wire [`RegsReadObusWidth] read_obus    
                   
    );
 //功能：寄存器组，可以实现两个端口同时读，一个端口写，读写可以同时进行，读将是待写入的数据
 
 
 /***************************************input variable define(输入变量定义)**************************************/
 //读端口1 
         wire                      rf_in_re1           ; //1号端口读使能信号 
         wire [`RegsAddrWidth]     rf_in_raddr1        ;// 1号端口读地址 
    //读端口2
         wire                      rf_in_re2           ;//2号端口读使能信号 
         wire [`RegsAddrWidth]     rf_in_raddr2        ;// 2号端口读地址 
    //写端口 
         wire                      rf_in_we            ;//写使能信号
         wire [`RegsAddrWidth]     rf_in_waddr         ; //写地址
         wire [`RegsDataWidth]     rf_in_wdata         ;//写数据

/***************************************output variable define(输出变量定义)**************************************/
//输出
           reg [`RegsDataWidth]         rf_out_rdata1       ;// 1号端口读数据 
           reg [`RegsDataWidth]         rf_out_rdata2       ; // 2号端口读数据 
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//存储器组变量定义
	reg[`RegsDataWidth]Regs[0:`RegsNum-1];
	integer i;
//    initial begin
//        for(i=0;i<32;i=i+1) Regs[i] = 0;   // 仿真使用，因为仿真中未初始化的reg初值为X (其实可综合)
//    end
	

/****************************************input decode(输入解码)***************************************/
assign {rf_in_re1,rf_in_re2} = 2'b11;
assign {rf_in_raddr1,rf_in_raddr2} = read_ibus;
assign {rf_in_we,rf_in_waddr,rf_in_wdata} = write_ibus;
/****************************************output code(输出解码)***************************************/
assign read_obus = {rf_out_rdata1,rf_out_rdata2};
/*******************************complete logical function (逻辑功能实现)*******************************/

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
        end else if(rf_in_raddr1==`RegsAddrLen'h0) begin//如果读入的是$0寄存器,优先判断当前读地址是不是$0,防呆，防止出现对不可写的地方写了，导致错误
            rf_out_rdata1<=`ZeroWord32B;       
        end else  if( (rf_in_raddr1==rf_in_waddr) && (rf_in_we == `WriteEnable) && (rf_in_re1 ==`ReadEnable) )begin //如果写有效，读有效，则读出数据是待写入口的数据
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
       end else  if( (rf_in_raddr2 == rf_in_waddr)&&(rf_in_we == `WriteEnable)&&(rf_in_re2 ==`ReadEnable) )begin//如果写有效，读有效，则读出数据是待写入口的数据
             rf_out_rdata2<=rf_in_wdata;
       end else begin //读
             rf_out_rdata2<=Regs[rf_in_raddr2];
       end
 end
  
//#################（ 模块结束）#################//  
 
endmodule
