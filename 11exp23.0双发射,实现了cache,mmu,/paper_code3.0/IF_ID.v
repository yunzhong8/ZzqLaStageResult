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
`include "DefineModuleBus.h"
module IF_ID(
    input  wire  clk      ,
    input  wire  rst_n    ,
    
     //控制本阶段id组合逻辑运算完的数据是否可以锁存起来，供给exe使用
    input wire line1_pre_to_now_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
    input wire line2_pre_to_now_valid_i,//if_id输出的表示，if阶段的数据可以输出到id阶段
    //id阶段的状态机
    input wire now_allowin_i,//id组合逻辑传入，表示id阶段当前数据已经运算完了
    
    output wire allowin_o,
    output wire line1_now_valid_o,//输出下一个状态
    output wire line2_now_valid_o,
    //冲刷信号
    input wire branch_flush_i,//冲刷流水信号
    input wire excep_flush_i,
    //发射暂停信号
    input wire lunch_stall_i,
    //数据域
    input  wire  [`IfToIdBusWidth] pre_to_ibus,
    
    output wire  [`IfToIdBusWidth]to_id_obus         
);

/***************************************input variable define(输入变量定义)**************************************/
/***************************************output variable define(输出变量定义)**************************************/
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
//队列空间设置为8
reg [`LineIfToIdBusWidth] inst_data_queue[7:0];
reg inst_valid_queue[7:0];
reg [2:0]queue_head;
reg [2:0]queue_tail;

wire [2:0]process_1;
wire[2:0] process_2;
/****************************************input decode(输入解码)***************************************/
/****************************************output code(输出解码)***************************************/
/*******************************complete logical function (逻辑功能实现)*******************************/

//上级流水输入一次写对头就+1
//当前队列允许输入
//规定前一级发过来的数据,如果有效则line1必定有效,line2不清楚
always@(posedge clk)begin
    if(rst_n == `RstEnable||excep_flush_i|| branch_flush_i)begin
        queue_head<=4'd0;
    end else if(line2_pre_to_now_valid_i&line1_pre_to_now_valid_i&allowin_o)begin
        queue_head <= queue_head +4'd2;
    end else if(line1_pre_to_now_valid_i&allowin_o)begin 
        queue_head <= queue_head +4'd1;
    end else begin
        queue_head <= queue_head;
    end
end

//队尾
//如果组合逻辑allowin则队尾部移动2个
//如果是当发射则队尾移动一个单位
always@(posedge clk)begin
    if(rst_n == `RstEnable||excep_flush_i|| branch_flush_i)begin
        queue_tail<=4'd0;
    end else if(lunch_stall_i)begin 
        queue_tail <= queue_tail +4'd1;
    end else if(now_allowin_i)begin
        if(line1_now_valid_o&line2_now_valid_o)begin
             queue_tail <= queue_tail +4'd2;
        end else if(line1_now_valid_o)begin
            queue_tail <= queue_tail +4'd1;
        end else begin
            queue_tail <= queue_tail ;
        end
    end else begin
        queue_tail <= queue_tail;
    end
end
//队列
//如果冲刷信号来的时候,队列数据全部无效,队列valid也全部无效
generate 
    genvar i ;
    for(i=0;i<8;i=i+1) begin : data_loop
        always@(posedge clk)begin
            if(rst_n == `RstEnable||excep_flush_i|| branch_flush_i)begin
                inst_data_queue[i]<=`LineIfToIdBusLen'd0;
            end else if(i==queue_head && line1_pre_to_now_valid_i && allowin_o)begin 
               inst_data_queue[i]  <=pre_to_ibus[`LineIfToIdBusWidth];
            end else if(i==queue_head+1 &&line2_pre_to_now_valid_i && allowin_o)begin 
               inst_data_queue[i]<=pre_to_ibus[`LineIfToIdBusWidth];
            end else begin
                inst_data_queue[i] <= inst_data_queue[i];
            end
        end
        
        always@(posedge clk)begin
            if(rst_n == `RstEnable ||excep_flush_i|| branch_flush_i)begin
                inst_valid_queue[i]<= 1'd0;
            end else if(i==queue_head && line1_pre_to_now_valid_i && allowin_o)begin  
               inst_valid_queue[i]  <= line1_pre_to_now_valid_i;
            end else if(i==queue_head+1 &&line2_pre_to_now_valid_i && allowin_o)begin 
               inst_valid_queue[i]  <= line2_pre_to_now_valid_i;
               //清空尾指令输出过的数据
            end else if(now_allowin_i && line1_now_valid_o && i==queue_tail)begin
                inst_valid_queue[i]  <= 1'b0;
             end else if(now_allowin_i && line2_now_valid_o && i==queue_tail+1)begin
                inst_valid_queue[i]  <= 1'b0;
            end else begin
                inst_valid_queue[i] <= inst_valid_queue[i];
            end
        end 
  end 
endgenerate 
assign process_1 = queue_tail;
assign process_2 = queue_tail + 3'd1;
assign to_id_obus        = {inst_data_queue[ process_2],inst_data_queue[process_1]};
assign line1_now_valid_o = inst_valid_queue[process_1];
assign line2_now_valid_o = inst_valid_queue[process_2];

//两种情况
//当前队列还要两个空空间
//当前空间<2个,但是同时收到了组合的allowin
//收到组合的lunch_stall是不允许的,因为可能上一级发过来两个数据
assign allowin_o = (queue_tail+2 == queue_head) ? (now_allowin_i ? 1'b1:1'b0) :1'b1;

endmodule
