/*
*作者：zzq
*创建时间：2023-03-31
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：reg类型在if中要更新
*模块考虑到未来要改为乱序执行，所以本模块设置成可以独立出去的模块
*/
/*************\
bug:

\*************/

`include "DefineModuleBus.h"

module Branch_Unit(
      input  wire rst_n,
      
      //当前指令pc
      input wire [`PcWidth]                     pc_i,
      input wire [`InstWidth]                   inst_i,
      //B类跳转指令的类型
      input wire [`spIdBtypeWidth]              spIdBtype_i,//要输入
      //直接跳转指令信号
      input wire [`spIdJmpWidth]                spIdJmp_i,//要输入
      //寄存器1的值
      input wire [`RegsDataWidth]               regs_rdata1_i,   
      //寄存器2的地址       
      input wire [`RegsDataWidth]               regs_rdata2_i,   
      //当前指令是跳转在指令
      input wire                                is_branch_inst_i,//要输入  
      //跳转地址             
      input wire [`PcWidth]                     jmp_base_addr_i,//基地址要输入
      input wire [`PcWidth]                     jmp_offs_addr_i,//偏移地址要输入
      
      //分支预测输入
      input wire                                branch_i,//分支预测的是否跳转 要输入
      input wire                                btb_hit_i,//分支预测btb表是否命中 要输入 
      input wire [`ScountStateWidth]            pht_state_i,//pht状态机 要输入
      input wire [`PcWidth]                     pre_pc_i, //预测地址 要输入
     
      input wire                                now_ctl_valid_i,
     
      //是否更新跳转地址的使能信
      output wire                               now_is_branch_inst_o,
      output wire                               branch_flush_o, 
      //跳转转地址  
      output wire [`PcWidth]                    jmp_addr_o,
    
     //更新分支预测
      output wire [`PtoWbusWidth]               to_pr_obus
     
     
     
     
     
    );
/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/ 
  //分支预测
     
      wire pht_we_o;
      wire [`ScountAddrWidth]pht_waddr_o;
      wire [`ScountStateWidth]pht_wdata_o;
      
      wire btb_we_o;
      wire btb_wvalid_o;
      wire [`BtbAddrWidth] btb_waddr_o;
      wire [`BiatWidth] btb_wtag_o;
      wire [31:0]btb_wdata_o;//位宽是多少
 
  
 
/***************************************inner variable define(内部变量定义)**************************************/
  //jmp信号
    reg jmp_flag;      
//分支预测
    wire pht_we;
    wire btb_we;
   
    wire branch_flush;

/****************************************input decode(输入解码)***************************************/
   
/****************************************output code(输出解码)***************************************/
  //分支预测器更新
      assign to_pr_obus={pht_we_o,pht_waddr_o,pht_wdata_o,
                          btb_we_o,btb_wvalid_o,btb_waddr_o,btb_wtag_o,btb_wdata_o};
  
/*******************************complete logical function (逻辑功能实现)*******************************/
 //判断是否跳转
        always @(*)begin
            if(rst_n == `RstEnable)begin
                jmp_flag = 1'b0;
            end else if (spIdJmp_i == 1'b1)begin//无条件跳转
                jmp_flag = 1'b1;
            end else begin
                case(spIdBtype_i)
                    `spIdBtypeLen'd1:begin
                        jmp_flag = regs_rdata1_i == regs_rdata2_i?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd2:begin
                        jmp_flag = regs_rdata1_i != regs_rdata2_i?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd3:begin
                        jmp_flag = $signed(regs_rdata1_i) <$signed(regs_rdata2_i)?1'b1:1'b0;
                      end
                     `spIdBtypeLen'd4:begin
                        jmp_flag = $signed(regs_rdata1_i) <$signed(regs_rdata2_i)?1'b0:1'b1;
                      end
                     `spIdBtypeLen'd5:begin
                        jmp_flag = $unsigned(regs_rdata1_i) <$unsigned(regs_rdata2_i)?1'b1:1'b0;
                      end
                      `spIdBtypeLen'd6:begin
                        jmp_flag = $unsigned(regs_rdata1_i) <$unsigned(regs_rdata2_i)?1'b0:1'b1;
                      end
                      default: jmp_flag = 1'b0;  
                endcase
            end
        end
 
 


//分支预测更新
assign {branch_flush,pht_we,pht_wdata_o,
                           btb_we,btb_wdata_o} = is_branch_inst_i ? jmp_flag ?  (branch_i ? (pre_pc_i ==jmp_addr_o  ? {1'b0,~pht_state_i[0],pht_state_i+2'd1,1'b0,32'd0} : {1'b1,~pht_state_i[0],pht_state_i+2'd1,1'b1,jmp_addr_o} ) :{1'b1,1'b1,pht_state_i+2'd1,1'b1,jmp_addr_o}) :
                                                                        (branch_i ?{1'b1,1'b1,pht_state_i-2'd1,1'b0,32'd0} : {1'b0,pht_state_i[0],pht_state_i-2'd1,1'b0,32'd0}) :  {1'b0,pht_state_i[0],pht_state_i-2'd1,1'b0,32'd0};

assign branch_flush_o           = branch_flush & now_ctl_valid_i;   
assign now_is_branch_inst_o     = is_branch_inst_i & now_ctl_valid_i;   
assign pht_we_o                 = pht_we & now_ctl_valid_i;                   
assign btb_we_o                 = btb_we&now_ctl_valid_i;                                   
assign {btb_wtag_o,btb_waddr_o} = pc_i[31:3];               
assign btb_wvalid_o             = now_ctl_valid_i;                        
assign pht_waddr_o              = pc_i[12:3];                           

assign jmp_addr_o    = jmp_flag ? (jmp_base_addr_i + jmp_offs_addr_i) :pc_i +32'd4;






endmodule
