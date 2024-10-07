/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：reg类型在if中要更新
*
*/
/*************\
bug:

\*************/

`include "DefineModuleBus.h"

module Branch_Unit(
     input  wire rst_n,
     input  wire ibus,
     output wire obus
     
    );
/***************************************input variable define(输入变量定义)**************************************/
 //分支
     //wire spIdB;
     wire [`spIdBtypeWidth]              spIdBtype;
     wire [`spIdJmpWidth]                spIdJmp;
     wire [`spIdJmpBaseAddrSrcWidth]     spIdJmpBaseAddrSrc;
     wire [`spIdJmpOffsAddrSrcWidth]     spIdJmpOffsAddrSrc;
//
    wire [`RegsDataWidth]regs_rdata1;
    wire [`RegsDataWidth]regs_rdata2;
    wire [`PcWidth] pc_i;
     wire    [15:0]   imm16;
     wire   [25:0]    imm26            ;
 wire [`PcWidth]        jmp_addr_o;//跳转转地址
/***************************************output variable define(输出变量定义)**************************************/ 
  
 
/***************************************inner variable define(内部变量定义)**************************************/
  //jmp信号
    reg jmp_flag;      


/****************************************input decode(输入解码)***************************************/
   
/****************************************output code(输出解码)***************************************/
  
/*******************************complete logical function (逻辑功能实现)*******************************/
 //判断是否跳转
        always @(*)begin
            if(rst_n == `RstEnable)begin
                jmp_flag = 1'b0;
            end else if (spIdJmp == 1'b1)begin//无条件跳转
                jmp_flag = 1'b1;
            end else begin
                case(spIdBtype)
                    `spIdBtypeLen'd1:begin
                        jmp_flag = regs_rdata1 == regs_rdata2?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd2:begin
                        jmp_flag = regs_rdata1 != regs_rdata2?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd3:begin
                        jmp_flag = $signed(regs_rdata1) <$signed(regs_rdata2)?1'b1:1'b0;
                      end
                     `spIdBtypeLen'd4:begin
                        jmp_flag = $signed(regs_rdata1) <$signed(regs_rdata2)?1'b0:1'b1;
                      end
                     `spIdBtypeLen'd5:begin
                        jmp_flag = $unsigned(regs_rdata1) <$unsigned(regs_rdata2)?1'b1:1'b0;
                      end
                      `spIdBtypeLen'd6:begin
                        jmp_flag = $unsigned(regs_rdata1) <$unsigned(regs_rdata2)?1'b0:1'b1;
                      end
                      default: jmp_flag = 1'b0;  
                endcase
            end
        end


//计算跳转地址
 wire [`PcWidth] jmp_base_addr;
 wire [`PcWidth] jmp_offs_addr;
 assign jmp_base_addr = spIdJmpBaseAddrSrc ? regs_rdata1: pc_i;
 assign jmp_offs_addr = spIdJmpOffsAddrSrc ? { {4{imm26[25]}},imm26,2'h0 } : { {14{imm16[15]}},imm16,2'h0 };
 assign jmp_addr_o    = jmp_base_addr + jmp_offs_addr;


//分支预测更新
assign {branch_flush,pht_we,pht_wdata_o,
                           btb_we,btb_wdata_o} = is_branch_inst ? jmp_flag ?  (branch_i ? (pre_pc_i ==jmp_addr_o  ? {1'b0,~pht_state_i[0],pht_state_i+2'd1,1'b0,32'd0} : {1'b1,~pht_state_i[0],pht_state_i+2'd1,1'b1,jmp_addr_o} ) :{1'b1,1'b1,pht_state_i+2'd1,1'b1,jmp_addr_o}) :
                                                                        (branch_i ?{1'b1,1'b1,pht_state_i-2'd1,1'b0,32'd0} : {1'b0,pht_state_i[0],pht_state_i-2'd1,1'b0,32'd0}) :  {1'b0,pht_state_i[0],pht_state_i-2'd1,1'b0,32'd0};















endmodule
