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
module EX(
   
    input mem_allowin_i,//输入ex已经完成当前数据了,允许你清除id_ex锁存器中的数据，将新数据给ex执行，1为允许,由ex传入
    input ex_valid_i, //ID阶段流水是空的，没有要执行的数据，1为有效 ，由id_ex传入,
    
    //
    output ex_allowin_o,//传给if，和id_exe,id阶段已经完成数据，允许你清除if_id锁存器内容
    output ex_to_mem_valid_o,//传给exe_mem，id阶段已经完成
   
    input wire   [`PcInstBusWidth]pc_inst_ibus ,
    input  wire  [`IdToExBusWidth] idex_to_ibus        ,

    output  wire [`PcInstBusWidth]pc_inst_obus,
    output  wire  [`ExToIdBusWidth] to_id_obus,
    output wire [`MemToDataBusWidth] to_data_obus,
    output wire  [`ExToMemBusWidth] to_exmen_obus
);

/***************************************input variable define(输入变量定义)**************************************/
//运算器
    wire [`AluOpWidth]         alu_op_i      ;
    wire[`AluOperWidth]        alu_oper1_i   ;
    wire[`AluOperWidth]        alu_oper2_i   ;
    wire[`spExeRegsWdataSrcWidth] exe_regs_wdata_src_i;
 //存储器
    wire                     mem_req_i     ;
    wire                     mem_we_i      ;
    wire [`spMemRegsWdataSrcWidth]                    mem_regs_wdata_src_i  ;
    wire [`spMemMemDataSrcWidth]                    mem_mem_data_src_i;
    wire [31:0]              mem_wdata_i   ;
//寄存器组
    wire                     regs_we_i     ;
    wire[`RegsAddrWidth]       regs_waddr_i  ;
    wire[`RegsDataWidth]       regs_wdata_i ;
/***************************************output variable define(输出变量定义)**************************************/

    //存储器
    wire                  mem_req_o       ;
    wire                  mem_we_o        ;
    wire [`spMemRegsWdataSrcWidth]                 mem_regs_wdata_src_o   ;
    wire [`spMemMemDataSrcWidth]             mem_mem_data_src_o;
    wire [`MemAddrWidth]           mem_rwaddr_o    ;
    wire [`MemDataWidth]           mem_wdata_o     ;
    //寄存器组
    wire                   regs_we_o      ;
    wire[`RegsAddrWidth]     regs_waddr_o   ;
    reg[`RegsDataWidth] regs_wdata_o ;

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//XXXX 模块变量定义
         wire alu_equ_o;
         wire [`AluOperWidth]alu_rl_o;
         wire [`AluOperWidth]alu_rh_o;
/****************************************input decode(输入解码)***************************************/

    assign {alu_op_i,alu_oper1_i,alu_oper2_i,exe_regs_wdata_src_i,
    mem_req_i,mem_we_i,mem_regs_wdata_src_i,mem_mem_data_src_i,mem_wdata_i,
    regs_we_i,regs_waddr_i,regs_wdata_i}=idex_to_ibus;
/****************************************output code(输出解码)***************************************/
assign to_exmen_obus={mem_req_o,mem_we_o,mem_regs_wdata_src_o,mem_mem_data_src_o,mem_rwaddr_o,mem_wdata_o,
regs_we_o,regs_waddr_o,regs_wdata_o};//32+1+5+32

assign to_id_obus={regs_we_o,regs_waddr_o,regs_wdata_o,mem_regs_wdata_src_o};

assign pc_inst_obus=pc_inst_ibus;
assign to_data_obus={mem_req_o,mem_we_o,mem_rwaddr_o,mem_wdata_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
  Arith_Logic_Unit ALU(
                            alu_oper1_i,alu_oper2_i,
                            alu_op_i,
                            alu_rl_o,
                            alu_rh_o);
    assign alu_rh_o=32'h0000_0000;
    //存储器
    assign mem_req_o      =   mem_req_i;
    assign  mem_we_o      =   mem_we_i;
    assign mem_regs_wdata_src_o   =   mem_regs_wdata_src_i;
    assign mem_mem_data_src_o     =   mem_mem_data_src_i;
    assign mem_rwaddr_o   =   mem_req_i?alu_rl_o:32'h0000_0000;
    assign mem_wdata_o    =  mem_wdata_i;
 //寄存器组
    always @(*)begin
        case(exe_regs_wdata_src_i)
            `spExeRegsWdataSrcLen'd0: regs_wdata_o = regs_wdata_i;
            `spExeRegsWdataSrcLen'd1: regs_wdata_o = alu_rl_o;
            `spExeRegsWdataSrcLen'd2: regs_wdata_o = alu_rh_o;
            default: regs_wdata_o = `ZeroWord32B;
        endcase
    end
 	assign regs_waddr_o    =  regs_waddr_i;
    assign regs_we_o       =  regs_we_i;
    
    
    // 握手
      assign ex_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
      assign ex_allowin_o  = !ex_valid_i //本级数据为空，允许if阶段写入
                           || (ex_ready_go && mem_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
      assign ex_to_mem_valid_o = ex_valid_i && ex_ready_go;//id阶段打算写入


endmodule
