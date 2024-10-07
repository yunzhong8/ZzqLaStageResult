`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 16:33:54
// Design Name: 
// Module Name: mycpu_cache_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "DefineModuleBus.h"

module mycpu_cache_top(
    input  wire                         aclk                      ,
    input  wire                         aresetn                   ,
    
    //指令
    output wire                          inst_rd_req_o             ,//输出类AXI读请求                                          
    output wire [2:0]                   inst_rd_type_o            ,//输出类AXI读请求类型                                        
    output wire [31:0]                  inst_rd_addr_o            ,//输出类AXI读请求的起始地址    
                                     
    input  wire                         inst_rd_rdy_i             ,//AXI转接桥输入可以读啦，read_ready                            
    input  wire                         inst_ret_valid_i           ,//axi转接桥输入读回数据read_data_valid                       
    input  wire                         inst_ret_last_i           ,//axi转接桥输入这是最后一个读回数据，为什么是两位的？？？？                     
    input  wire [31:0]                  inst_ret_data_i           ,//axi转接桥输入的读回数据                                      
                                                                                                            
    output wire                         inst_wr_req_o             ,//类AXI输出的写请求                                         
    output wire [2:0]                   inst_wr_type_o            ,//类AXI输出的写请求类型                                       
    output wire [31:0]                  inst_wr_addr_o            ,//类AXI输出的写地址                                         
    output wire [3:0]                   inst_wr_wstrb_o           ,//写操作掩码                                              
    output wire  [`CacheBurstDataWidth] inst_wr_data_o            ,//类AXI输出的写数据128bit                                   
    input  wire                         inst_wr_rdy_i             ,//AXI总线输入的写完成信号，可以接收写请求                 
    
    //数据
    output wire                         data_rd_req_o             ,//输出类AXI读请求                                              
    output wire [2:0]                   data_rd_type_o            ,//输出类AXI读请求类型                               
    output wire [31:0]                  data_rd_addr_o            ,//输出类AXI读请求的起始地址
                                
    input  wire                         data_rd_rdy_i             ,//AXI转接桥输入可以读啦，read_ready                   
    input  wire                         data_ret_valid_i           ,//axi转接桥输入读回数据read_data_valid              
    input  wire                         data_ret_last_i           ,//axi转接桥输入这是最后一个读回数据，为什么是两位的？？？？            
    input  wire [31:0]                  data_ret_data_i           ,//axi转接桥输入的读回数据                             
                                                                                                    
    output wire                         data_wr_req_o             ,//类AXI输出的写请求                                
    output wire [2:0]                   data_wr_type_o            ,//类AXI输出的写请求类型                              
    output wire [31:0]                  data_wr_addr_o            ,//类AXI输出的写地址                                
    output wire [3:0]                   data_wr_wstrb_o           ,//写操作掩码                                     
    output wire  [`CacheBurstDataWidth] data_wr_data_o            ,//类AXI输出的写数据128bit                          
    input  wire                         data_wr_rdy_i             , //AXI总线输入的写完成信号，可以接收写请求                     
      
    //硬件中断信号
    input wire [7:0] hardware_interrupt_data,
      //trace 
    output wire [31:0] debug_wb_pc,                           
    output wire [ 3:0] debug_wb_rf_we,                        
    output wire [ 4:0] debug_wb_rf_wnum,                      
    output wire [31:0] debug_wb_rf_wdata                      
                        

    );
 /***************************************input variable define(输入变量定义)**************************************/

    wire        cpu_inst_req;
    wire        cpu_inst_wr;
    wire [1:0]  cpu_inst_size;
    wire [3:0]  cpu_inst_wstrb;
    
    wire [3:0]  cpu_inst_offset ; 
    wire [7:0]  cpu_inst_index  ;  
    wire [19:0] cpu_inst_tag    ;    
    wire [31:0] cpu_inst_wdata;
    wire        inst_uncache;
    wire inst_cache_refill_valid;
    
    wire cpu_inst_addr_ok ;
    wire cpu_inst_data_ok ;
    wire [31:0]cpu_inst_rdata;
    
    
    // data sram interface
    
    wire        cpu_data_req;
    wire        cpu_data_wr ;
    wire [1:0]  cpu_data_size;
    wire [3:0]  cpu_data_wstrb ;
  
    wire [3:0]  cpu_data_offset ; 
    wire [7:0]  cpu_data_index  ;  
    wire [19:0] cpu_data_tag    ;    
    
 
    wire [31:0] cpu_data_wdata;
    wire        data_uncache;      
    wire        data_store_buffer_we;
    wire       data_cache_refill_valid;
    
    wire  cpu_data_addr_ok;
    wire  cpu_data_data_ok;
    wire [31:0] cpu_data_rdata;
   
    
    
    reg          memref_valid;
    wire         memref_op;
    wire [  7:0] in_index;
    wire [ 19:0] in_tag;
    wire [  3:0] in_offset;
    wire [ 31:0] memref_data;
    wire [  3:0] memref_wstrb;
    
    wire         cache_addr_ok;
    wire         out_valid;
    wire [ 31:0] cacheres;
        
    wire         rd_req;
    wire [  2:0] rd_type;
    wire [ 31:0] rd_addr;
    wire         rd_rdy;
    wire         ret_valid;
    wire         ret_last;
    wire [ 31:0] ret_data;
    
    wire         wr_req;
    wire [  2:0] wr_type;
    wire [ 31:0] wr_addr;
    wire [  3:0] wr_wstrb;
    wire [127:0] wr_data;
    wire         wr_rdy;
           
    
/*******************************complete logical function (逻辑功能实现)*******************************/ 
  Loog cpu(
    .clk              (aclk   ),
    .rst_n            (aresetn),  //low active

    .inst_sram_req    (cpu_inst_req    ),//out
    .inst_sram_wr     (cpu_inst_wr     ),//out
    .inst_sram_size   (cpu_inst_size   ),//out
    .inst_sram_wstrb  (cpu_inst_wstrb  ),//out
    .inst_sram_offset (cpu_inst_offset ),//out
    .inst_sram_index  (cpu_inst_index  ),//out
    .inst_sram_tag    (cpu_inst_tag    ),//out
    .inst_sram_wdata  (cpu_inst_wdata  ),//out
    .inst_uncache_o   (inst_uncache    ),
    .inst_cache_refill_valid_o (inst_cache_refill_valid),
    
    
    .inst_sram_addr_ok(cpu_inst_addr_ok),//input
    .inst_sram_data_ok(cpu_inst_data_ok),//input
    
    .inst_sram_rdata  (cpu_inst_rdata  ),//input
    
    .data_sram_req    (cpu_data_req    ),//out
    .data_sram_wr     (cpu_data_wr     ),//out
    .data_sram_size   (cpu_data_size   ),//out
    .data_sram_wstrb  (cpu_data_wstrb  ),//out
    .data_sram_offset (cpu_data_offset ),
    .data_sram_index  (cpu_data_index  ), 
    .data_sram_tag    (cpu_data_tag    ),      
    .data_sram_wdata  (cpu_data_wdata  ),//out
    .data_uncache_o   (data_uncache    ),
    .data_store_buffer_we_o (data_store_buffer_we),
    .data_cache_refill_valid_o (data_cache_refill_valid),
    
    .data_sram_addr_ok(cpu_data_addr_ok),//input
    .data_sram_data_ok(cpu_data_data_ok),//input
    
    .data_sram_rdata  (cpu_data_rdata  ),//input
    //中断
    .hardware_interrupt_data(hardware_interrupt_data),//input

    //debug interface
    .debug_wb_pc      (debug_wb_pc      ),//output
    .debug_wb_rf_we   (debug_wb_rf_we   ),//output
    .debug_wb_rf_wnum (debug_wb_rf_wnum ),//output
    .debug_wb_rf_wdata(debug_wb_rf_wdata) //output
);  
    



cache icache_item(
    .clk    (aclk),//input
    .resetn (aresetn),//input
    
    .valid  (cpu_inst_req),//input
    .op     (cpu_inst_wr ), //input
    .offset (cpu_inst_offset), //input
    .index  (cpu_inst_index  ), //input
    .tag    (cpu_inst_tag     ), //input
    .uncache_i        (inst_uncache),
    .store_buffer_we_i(1'b0),
    .cache_refill_valid_i(inst_cache_refill_valid),
    
    .wstrb  (cpu_inst_wstrb ),//input
    .wdata  (cpu_inst_wdata),//input

    .addr_ok(cpu_inst_addr_ok),//output
    .data_ok(cpu_inst_data_ok),//output
    .rdata  (cpu_inst_rdata ),//output

    .rd_req   (inst_rd_req_o   ),//output
    .rd_type  (inst_rd_type_o  ),//output
    .rd_addr  (inst_rd_addr_o  ),//output
    
    .rd_rdy   (inst_rd_rdy_i   ),//intput
    .ret_valid(inst_ret_valid_i),//intput
    .ret_last (inst_ret_last_i ),//intput
    .ret_data (inst_ret_data_i ),//intput

    .wr_req   (inst_wr_req_o     ),//output
    .wr_type  (inst_wr_type_o    ),//output
    .wr_addr  (inst_wr_addr_o    ),//output
    .wr_wstrb (inst_wr_wstrb_o   ),//output
    .wr_data  (inst_wr_data_o    ),//output
    .wr_rdy   (inst_wr_rdy_i     ) //input
);    
    
    
cache dcache_item(
    .clk    (aclk),//input
    .resetn (aresetn),//input
    
    .valid  (cpu_data_req),//input
    .op     (cpu_data_wr), //input
    
    .offset (cpu_data_offset ), //input
    .index  (cpu_data_index  ), //input
    .tag    (cpu_data_tag    ), //input
    .uncache_i        (data_uncache),
    .store_buffer_we_i(data_store_buffer_we),
    .cache_refill_valid_i(data_cache_refill_valid),
    
    
    .wstrb  (cpu_data_wstrb),//input
    .wdata  (cpu_data_wdata),//input

    .addr_ok(cpu_data_addr_ok),//output
    .data_ok(cpu_data_data_ok),//output
    .rdata  (cpu_data_rdata ),//output

    .rd_req   (data_rd_req_o   ),//output
    .rd_type  (data_rd_type_o  ),//output
    .rd_addr  (data_rd_addr_o  ),//output
    
    .rd_rdy   (data_rd_rdy_i   ),//intput
    .ret_valid(data_ret_valid_i),//intput
    .ret_last (data_ret_last_i ),//intput
    .ret_data (data_ret_data_i ),//intput

    .wr_req  (data_wr_req_o   ),//output
    .wr_type (data_wr_type_o  ),//output
    .wr_addr (data_wr_addr_o  ),//output
    .wr_wstrb(data_wr_wstrb_o ),//output
    .wr_data (data_wr_data_o  ),//output
    .wr_rdy  (data_wr_rdy_i   ) //input
);    
    
    
    
    
    
    
    
    
endmodule
