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
module MEM(
//    input  wire  clk      ,
//    input  wire  rst_n    ,

    input wb_allowin_i,//输入ex已经完成当前数据了,允许你清除id_ex锁存器中的数据，将新数据给ex执行，1为允许,由ex传入
    input mem_valid_i, //ID阶段流水是空的，没有要执行的数据，1为有效 ，由id_ex传入,
    
    //
    output mem_allowin_o,//传给if，和id_exe,id阶段已经完成数据，允许你清除if_id锁存器内容
    output mem_to_wb_valid_o,//传给exe_mem，id阶段已经完成当前数据，想要将运算结果写入id_ex锁存器中，
    
    input  wire [`PcInstBusWidth]   pc_inst_ibus,
    input  wire [`ExToMemBusWidth]    exmem_to_ibus       ,
    input wire [`MemDataWidth]  mem_rdata_i    ,
     
    output  wire [`PcInstBusWidth] pc_inst_obus,
    output wire    [`MemToWbBusWidth]to_memwb_obus            
);

/***************************************input variable define(输入变量定义)**************************************/
    //存储器
         wire mem_req_i ;
         wire mem_we_i; 
         wire [`spMemRegsWdataSrcWidth] mem_regs_wdata_src_i;
         wire [`spMemMemDataSrcWidth] mem_mem_data_src_i;
         wire [`MemAddrWidth]         mem_rwaddr_i   ;
         wire [`MemDataWidth]   mem_wdata_i    ;
    //寄存器组
         wire[`RegsAddrWidth] regs_waddr_i;
         wire regs_we_i;
         wire [`RegsDataWidth] regs_wdata_i;

/***************************************output variable define(输出变量定义)**************************************/
    //存储器
         wire mem_req_o;
         wire mem_we_o;
         wire [`MemAddrWidth]mem_rwaddr_o;
         reg [3:0]mem_rwsel_o;
         reg[`MemDataWidth]mem_wdata_o;
        
        
    //寄存器组
         wire regs_we_o;
         wire[`RegsAddrWidth]regs_waddr_o;
         wire[`RegsDataWidth] regs_wdata_o;
    
    
    
    
    

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
 reg [`MemDataWidth]mem_rdata;
 wire [1:0] mem_rwaddr_low2;
/****************************************input decode(输入解码)***************************************/
 assign   {mem_req_i,mem_we_i,mem_regs_wdata_src_i,mem_mem_data_src_i,mem_rwaddr_i,mem_wdata_i,mem_rdata_i,
        regs_we_i,regs_waddr_i,regs_wdata_i} = exmem_to_ibus;


/****************************************output code(输出解码)***************************************/
assign pc_inst_obus = pc_inst_ibus;
assign to_memwb_obus={regs_we_o,regs_waddr_o,regs_wdata_o};
//assign to_data_obus={mem_req_o,mem_we_o,mem_rwaddr_o,mem_wdata_o};
/*******************************complete logical function (逻辑功能实现)*******************************/

  //寄存器组
    assign regs_waddr_o = regs_waddr_i;
    assign regs_we_o = regs_we_i;
    assign regs_wdata_o = mem_regs_wdata_src_i ?mem_rdata:regs_wdata_i;

    assign mem_rwaddr_low2 = mem_rwaddr_i[1:0];
   
    always @(*)begin
            case(mem_mem_data_src_i)
                `spMemMemDataSrcLen'd0:begin//字
                    mem_rdata = mem_rdata_i ;
                    mem_rwsel_o = 4'b1111;
                    mem_wdata_o = mem_wdata_i;
                end
                `spMemMemDataSrcLen'd1:begin//半字0扩展
                    mem_wdata_o = {mem_wdata_i[15:0],mem_wdata_i[15:0]};
                    case(mem_rwaddr_low2)
                        2'b00:begin
                            mem_rdata = {16'd0,mem_rdata_i[15:0]};
                            mem_rwsel_o = 4'b0011;
                        end
                        2'b10:begin
                            mem_rdata = {16'd0,mem_rdata_i[31:16]};
                            mem_rwsel_o = 4'b1100;
                        end
                        default:begin
                            mem_rdata = `ZeroWord32B;
                            mem_rwsel_o = 4'b0000;
                        end
                    endcase    
                end
                `spMemMemDataSrcLen'd2:begin//半字符号扩展
                    mem_wdata_o = {mem_wdata_i[15:0],mem_wdata_i[15:0]};
                    case(mem_rwaddr_low2)
                        2'b00:begin
                            mem_rdata = {{16{mem_rdata_i[15]}},mem_rdata_i[15:0]};
                            mem_rwsel_o = 4'b0011;
                        end
                        2'b11:begin
                            mem_rdata = { {16{mem_rdata_i[31]}},mem_rdata_i[31:16] };
                            mem_rwsel_o = 4'b1100;
                        end
                        default:begin
                            mem_rdata = `ZeroWord32B;
                            mem_rwsel_o = 4'b0000;
                        end
                    endcase
                end
                `spMemMemDataSrcLen'd3:begin//字节0扩展
                    mem_wdata_o = {4{mem_wdata_i[7:0]}};
                    case(mem_rwaddr_low2)
                        2'b00:begin
                            mem_rdata = {24'd0,mem_rdata_i[7:0]};
                            mem_rwsel_o = 4'b0001;
                        end
                        2'b01:begin
                            mem_rdata = {24'd0,mem_rdata_i[15:8]};
                            mem_rwsel_o = 4'b0010;
                        end
                        2'b10:begin
                            mem_rdata = {24'd0,mem_rdata_i[23:16]};
                            mem_rwsel_o =4'b0100;
                        end
                        default:begin
                            mem_rdata = {24'd0,mem_rdata_i[31:24]};
                            mem_rwsel_o = 4'b1000;
                        end
                    endcase
                end
                `spMemMemDataSrcLen'd4:begin//字节符号扩展
                    mem_wdata_o = {4{mem_wdata_i[7:0]}};
                    case(mem_rwaddr_low2)
                        2'b00:begin
                            mem_rdata = { {24{mem_rdata_i[7]}},mem_rdata_i[7:0] };
                            mem_rwsel_o = 4'b0001;
                        end
                        2'b01:begin
                            mem_rdata = { {24{mem_rdata_i[15]}},mem_rdata_i[15:8]};
                            mem_rwsel_o = 4'b0010;
                        end
                        2'b10:begin
                            mem_rdata = {{24{mem_rdata_i[23]}},mem_rdata_i[23:16]};
                            mem_rwsel_o = 4'b0100;
                        end
                        default:begin
                            mem_rdata = {{24{mem_rdata_i[31]}},mem_rdata_i[31:24]};
                            mem_rwsel_o = 4'b1000;
                        end
                    endcase
                end
            endcase
        end

//存储器  
    assign  mem_we_o     = mem_we_i;//写使能    
    assign  mem_rwaddr_o = mem_rwaddr_i; 
    assign  mem_req_o    = mem_req_i   ;
    
  assign mem_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
  assign mem_allowin_o  = !mem_valid_i //本级数据为空，允许if阶段写入
                           || (mem_ready_go && wb_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
  assign mem_to_wb_valid_o = mem_valid_i && mem_ready_go;//id阶段打算写入

 
       
       
endmodule

