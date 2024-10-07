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
`include "DefineSignLocation.h"
module ID(
   // input  wire  clk      ,
    input  wire  rst_n    ,

    input wire   [`PcInstBusWidth] pc_inst_ibus,
   
    input  wire   [`RegsToIdBusWidth]regs_to_ibus        ,
    input wire   [`ExToIdBusWidth]ex_to_ibus        ,
    input wire   [`MemToIdBusWidth]mem_to_ibus,
    input wire  [`CoutToIdBusWidth]cout_to_ibus,

    output wire [`PcInstBusWidth] pc_inst_obus,
    output wire [`IdToExBusWidth]to_idex_obus,
    output wire [`IdToPreifBusWidth]to_preif_obus,
    output wire [`IdToRegsBusWidth]to_regs_obus
);

/***************************************input variable define(输入变量定义)**************************************/
    wire [`PcWidth] pc_i;
    wire [`InstWidth]inst_i;
    wire [`RegsDataWidth]     regs_rdata1_i;
    wire [`RegsDataWidth]     regs_rdata2_i;
    wire                      ex_regs_we_i;
    wire [`RegsAddrWidth]     ex_regs_waddr_i;
    wire [`RegsDataWidth]     ex_regs_wdata_i;
    wire                      ex_memtoreg_i;
    wire                      mem_regs_we_i;
    wire[`RegsAddrWidth]      mem_regs_waddr_i;
    wire[`RegsDataWidth]      mem_regs_wdata_i;
    wire  [63:0] counter_i;
    wire  [63:0] counterid_i;

/***************************************ioutput variable define(输出变量定义)**************************************/
    wire [`PcWidth]           pc_o          ;
    wire [`InstWidth]         inst_o        ;
    reg [`RegsAddrWidth]    regs_raddr1_o;//寄存器组读地址1
    reg [`RegsAddrWidth]    regs_raddr2_o;//寄存器组读地址2
    wire [`AluOperWidth]       alu_op_o             ;
    wire [`AluOperWidth]     alu_oper1_o          ;
    reg [`AluOperWidth]     alu_oper2_o          ;
    wire [`spExeRegsWdataSrcWidth]                exe_regs_wdata_src_o;
    //存储器输出
    wire                   mem_req_o;
    wire                   mem_we_o;//存储器写使能信号
    wire  [`spMemRegsWdataSrcWidth]                  mem_regs_wdata_src_o;//存储器读出数据类型
    wire  [`spMemMemDataSrcWidth]                 mem_mem_data_src_o;
    wire  [`MemDataWidth]           mem_wdata_o;
    //寄存器输出
    wire                    regs_we_o;//寄存器组写使能
    reg [`RegsAddrWidth]     regs_waddr_o;//寄存器写地址
    reg [`RegsDataWidth]     regs_wdata_o;//寄存器写入数据
    reg                   jmp_flag_o;//跳转标志
    wire [`PcWidth]           jmp_addr_o;//跳转转地址

/***************************************parameter define(常量定义)**************************************/
 parameter regs_re1=1'b1;
 parameter regs_re2=1'b1;

/***************************************inner variable define(内部变量定义)**************************************/
//指令分解 模块变量定义
     wire   [21:0]    op               ;
    
     wire   [4:0]     rj               ;
     wire   [4:0]     rk               ;
     wire   [4:0]     rd               ;
    
     wire   [11:0]    imm12            ;
     wire    [15:0]   imm16;
     wire   [19:0]    imm20;
     
     wire   [25:0]    imm26            ;

     wire   [31:0]    sign_ext_imm12   ;
     wire    [31:0]   sign_ext_imm16   ;
     wire   [31:0]    sign_ext_imm20  ;
     wire   [31:0]    sign_ext_imm26   ;
     
     wire   [31:0]    zero_ext_imm12   ;
     wire    [31:0]   zero_ext_imm16   ;
     wire   [31:0]    zero_ext_imm20  ;
     wire   [31:0]    zero_ext_imm26   ;

     wire   [4:0] shmat;

     wire   [`PcWidth] next_pc;

 //指令控制信号产生模块定义
     //Id阶段
     wire [`spIdRegsRead2SrcWidth]    spIdRegsRead2Src;//id阶段使用的控制寄存器组第二读端口的读地址
    
     wire [`spIdAluOpaSrcWidth]       spIdAluOpaSrc;
     wire [`spIdAluOpbSrcWidth]       spIdAluOpbSrc;
     
     wire [`spIdRegsWaddrSrcWidth]    spIdRegsWaddrSrc;
    
     

     //EXE
     wire [`spExeRegsWdataSrcWidth]   spExeRegsWdataSrc;
     wire [`AluOpWidth]               spExeAluOp;
     
     //MEM
     wire [`spMemReqWidth]            spMemReq;
     wire [`spMemMemWeWidth]          spMemMemWe;
     wire [`spMemRegsWdataSrcWidth]   spMemRegsWdataSrc;//mem阶段寄存器写入数据：是mem还是exe
     wire [`spMemMemDataSrcWidth]     spMemMemDataSrc;//mem阶段寄存器写入的数据类型000:来自alu,>1表示来着data_sram
     
     //WB
     wire [`EnWidth]  spWbRegsWe ;
     //分支
     //wire spIdB;
     wire [`spIdBtypeWidth]           spIdBtype;
     wire [`spIdJmpWidth]             spIdJmp;
     wire [`spIdJmpBaseAddrSrcWidth]     spIdJmpBaseAddrSrc;
     wire [`spIdJmpOffsAddrSrcWidth]     spIdJmpOffsAddrSrc;

     wire [`SignWidth]                sp_sign_o;
 
 //B类指令
     wire B_gt;
     wire B_equ;
     wire B_lt;
 
 //数据相关检查模块变量定义
    wire exe_relate1_o;//寄存器组1号口是否数据相关
    wire mem_relate1_o;//

    wire exe_relate2_o;//寄存器组2号口是否数据相关
    wire mem_relate2_o;
//解决数据相关后寄存器组读出数据
    wire [`RegsDataWidth]regs_rdata1;
    wire [`RegsDataWidth]regs_rdata2;

/****************************************input decode(输入解码)***************************************/
    assign {pc_i,inst_i} = pc_inst_ibus;
    assign {regs_rdata1_i,regs_rdata2_i} = regs_to_ibus;
    assign {ex_regs_we_i,ex_regs_waddr_i,ex_regs_wdata_i,ex_memtoreg_i} = ex_to_ibus ;
    assign {mem_regs_we_i,mem_regs_waddr_i,mem_regs_wdata_i} = mem_to_ibus ;
    assign {counter_i,counterid_i} = cout_to_ibus;


/****************************************output code(输出解码)***************************************/
    assign pc_inst_obus={pc_i,inst_i};
    assign to_regs_obus = {regs_raddr1_o,regs_raddr2_o};
    
    assign to_idex_obus = { alu_op_o,alu_oper1_o,alu_oper2_o,exe_regs_wdata_src_o,
        mem_req_o,mem_we_o,mem_regs_wdata_src_o,mem_mem_data_src_o,mem_wdata_o,
        regs_we_o,regs_waddr_o,regs_wdata_o
    };
    
    assign to_preif_obus={jmp_flag_o,jmp_addr_o};
    
/*******************************complete logical function (逻辑功能实现)*******************************/

  assign next_pc =pc_i+32'h4;
  //$$$$$$$$$$$$$$$（ 指令分解模块 模块调用）$$$$$$$$$$$$$$$$$$// 
	//模块输入：
	//模块调用：
     assign op = inst_i[31:10] ;

     assign rk = inst_i[14:10] ;
     assign rj = inst_i[9:5]   ;
     assign rd = inst_i[4:0]   ;

     assign imm12=inst_i[21:10] ;  //21-10=11+1=12
     assign imm16=inst_i[25:10];
     assign imm20 = inst_i[24:5];
     assign imm26={inst_i[9:0],inst_i[25:10]};

     assign sign_ext_imm12 = {{20{inst_i[11]}},imm12};
     assign sign_ext_imm16 = {{16{inst_i[15]}},imm16};
     assign sign_ext_imm20 = {{12{inst_i[19]}},imm20};
     assign sign_ext_imm26 = {{6{inst_i[25]}},imm26};
     
     
     assign zero_ext_imm12 = {20'h0_0000,imm12};
     assign zero_ext_imm16 = {16'h0000,imm16};
     assign zero_ext_imm20 = {12'h000,imm20};
     assign zero_ext_imm26 = {6'd0,imm26};
	//模块输入输出显示：  

  //$$$$$$$$$$$$$$$（ 数据相关检查 模块调用）$$$$$$$$$$$$$$$$$$// 
	//模块调用：
	 Data_Relevant DR(
                    .rstL            (rst_n),
                    .ex_regs_we_i    ( ex_regs_we_i      )     ,
                    .ex_memtoreg_i   ( ex_memtoreg_i     )     ,
                    .ex_regs_waddr_i ( ex_regs_waddr_i   )     ,
                   
                    .mem_regs_we_i   ( mem_regs_we_i     )     ,
                    .mem_regs_waddr_i( mem_regs_waddr_i  )     ,

                   
                    .regs_rwaddr1_i  ( regs_raddr1_o  )       ,
                    .regs_rwaddr2_i  (  regs_raddr2_o )       ,
                    
                    .exe_relate1_o   ( exe_relate1_o  )       ,
                    .mem_relate1_o   ( mem_relate1_o  )       ,
                    .exe_relate2_o   ( exe_relate2_o  )       ,
                    .mem_relate2_o   ( mem_relate2_o  )       
                   );
	//模块输入输出显示：  

 	
 	
 	 
 
   //$$$$$$$$$$$$$$$（ 寄存器组读出数据修正 ）$$$$$$$$$$$$$$$$$$// 
	//模块输入：
	//模块调用：
	assign regs_rdata1=exe_relate1_o?ex_regs_wdata_i:(mem_relate1_o?mem_regs_wdata_i:regs_rdata1_i);
    assign regs_rdata2=exe_relate2_o?ex_regs_wdata_i:(mem_relate2_o?mem_regs_wdata_i:regs_rdata2_i);
	//模块输入输出显示：  

 
 	

   //$$$$$$$$$$$$$$$（ 指令控制信号产生 模块调用）$$$$$$$$$$$$$$$$$$// 
        //模块输入：
        //模块调用：
             SignProduce sp(
             .inst_i(inst_i),
             .inst_aluop_o(spExeAluOp),
             .inst_sign_o(sp_sign_o)
             );
             //ID阶段信号spIdRegsWdataSrc为最高位，高位 次高位 次低位 低位
                   assign {spIdRegsWdataSrc,spIdRegsWaddrSrc,spIdAluOpbSrc,spIdAluOpaSrc,spIdRegsRead2Src} = sp_sign_o[`ID_SIGN_LOCATION];
            //跳转信号
                   assign {spIdJmpOffsAddrSrc,spIdJmpBaseAddrSrc,spIdJmp,spIdBtype
                   }= sp_sign_o[`B_SIGN_LOCATION];
            //获取EXE阶段信号
                 assign spExeRegsWdataSrc = sp_sign_o[`EXE_SIGN_LOCATION];
             //MEM
              assign {spMemMemDataSrc,spMemRegsWdataSrc,spMemMemWe}=sp_sign_o[`MEM_SIGN_LOCATION];
              assign spMemReq=1'b1;
              
            //WB
              assign {spWbRegsWe}=sp_sign_o[`WB_SIGN_LOCATION];
    
 	
   //$$$$$$$$$$$$$$$（ B类跳转指令 模块）$$$$$$$$$$$$$$$$$$//     
        //比较
        always @(*)begin
            if(rst_n == `RstEnable)begin
                jmp_flag_o = 1'b0;
            end else if (spIdJmp == 1'b1)begin//无条件跳转
                jmp_flag_o = 1'b1;
            end else begin
                case(spIdBtype)
                    `spIdBtypeLen'd1:begin
                        jmp_flag_o = regs_rdata1 == regs_rdata2?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd2:begin
                        jmp_flag_o = regs_rdata1 != regs_rdata2?1'b1:1'b0;
                     end
                     `spIdBtypeLen'd3:begin
                        jmp_flag_o = $signed(regs_rdata1) <$signed(regs_rdata2)?1'b1:1'b0;
                      end
                     `spIdBtypeLen'd4:begin
                        jmp_flag_o = $signed(regs_rdata1) <$signed(regs_rdata2)?1'b0:1'b1;
                      end
                     `spIdBtypeLen'd5:begin
                        jmp_flag_o = $unsigned(regs_rdata1) <$unsigned(regs_rdata2)?1'b1:1'b0;
                      end
                      `spIdBtypeLen'd6:begin
                        jmp_flag_o = $unsigned(regs_rdata1) <$unsigned(regs_rdata2)?1'b0:1'b1;
                      end
                      default: jmp_flag_o = 1'b0;  
                endcase
            end
        end
 //*******************************************计算输出***********************************************//
//ID阶段使用
     //################计算寄存器读输出################//
     assign  pc_o    = pc_i      ;
     assign  inst_o  = inst_i     ;
    //ID阶段
      //寄存器读地址1
             always@(*)begin
                 if(rst_n==`RstEnable)begin
                    regs_raddr1_o<=5'd0;
                 end else begin
                        regs_raddr1_o<=rj;
                 end
              end
          //寄存器读地址2
             always@(*)begin
                 if(rst_n==`RstEnable)begin
                    regs_raddr2_o<=5'd0;
                 end else if(spIdRegsRead2Src)begin
                    regs_raddr2_o<=rd;
                 end else begin
                         regs_raddr2_o<=rk; 
                 end
              end 
   //################计算寄ALU(EXE)输出################//
          //ALU运算类型
             assign alu_op_o = spExeAluOp;
         //ALu_oper1运算器运算数1
             assign alu_oper1_o=spIdAluOpaSrc?pc_i:regs_rdata1;
            
        //ALu_oper2运算器运算数2
             always@(*)begin
                 if(rst_n == `RstEnable)begin
                     alu_oper2_o = `AluOperLen'd0;
                 end else begin
                     case(spIdAluOpbSrc)
                         2'd0: alu_oper2_o = regs_rdata2;
                         2'd1: alu_oper2_o = zero_ext_imm12;
                         2'd2: alu_oper2_o = sign_ext_imm12;
                         2'd3: alu_oper2_o = sign_ext_imm20;
                         default: alu_oper2_o = `AluOperLen'd0; 
                     endcase
                 end
             end
                assign exe_regs_wdata_src_o = spExeRegsWdataSrc;
    //mem阶段
            assign mem_req_o            = spMemReq          ; //存储器使能
            assign mem_we_o             = spMemMemWe        ; //存储器写使能
            assign mem_regs_wdata_src_o = spMemRegsWdataSrc ; //存储阶段寄存器写入类型选择
            assign mem_mem_data_src_o   = spMemMemDataSrc   ;
            assign mem_wdata_o          = regs_rdata1       ; //存储器写入数据
  //  ################计算WB(regs_write)输出################//         
        assign regs_we_o = spWbRegsWe ;//wb阶段寄存器写使能
    //寄存器组写入地址
         always@(*)begin
                if(rst_n==`RstEnable)begin
                    regs_waddr_o<=`RegsAddrLen'd0;
                end else begin
                    case(spIdRegsWaddrSrc)
                        2'd0:regs_waddr_o = rd;
                        2'd1:regs_waddr_o = rj;
                        2'd2:regs_waddr_o = `RegsAddrLen'd1;
                        default: regs_waddr_o = `RegsAddrLen'd0;
                    endcase
                end
         end
     //寄存器写回数据
        always @(*)begin
            if(rst_n == `RstEnable)begin
                regs_wdata_o = `RegsDataLen'd0;
            end else begin
                case(spIdRegsWdataSrc)
                        3'd0:regs_wdata_o = {imm20,12'b0};
                        3'd1:regs_wdata_o = pc_i+32'd4;
                        3'd2:regs_wdata_o = counter_i[31:0];
                        3'd3:regs_wdata_o = counter_i[63:32];
                        3'd4:regs_wdata_o = counterid_i;
                        default:regs_wdata_o = `RegsDataLen'd0;
                endcase
            end
        end
   

    //################跳转计算################//         
      wire [`PcWidth] jmp_base_addr;
      wire [`PcWidth] jmp_offs_addr;
      assign jmp_base_addr = spIdJmpBaseAddrSrc?regs_rdata1:pc_i;
      assign jmp_offs_addr = spIdJmpOffsAddrSrc?{ {4{imm26[25]}},imm26,2'b00 }:{ {14{imm16[15]}},imm16,2'h0 };
      assign jmp_addr_o = jmp_base_addr+jmp_offs_addr;




   
//wire n_halt;

//SysBanchMark sbmI(
//                  .rstL           (rstL)          ,
//                  .clk            (clk)           ,
//                  .regs_rdata1    (regs_rdata1)   ,
//                  .regs_rdata2    (regs_rdata2)   ,
//                  .SysCall        (spSysCall)     ,
//                  .led_data       (led_data)      ,
//                  .n_halt          (n_halt)
//                  );

endmodule

