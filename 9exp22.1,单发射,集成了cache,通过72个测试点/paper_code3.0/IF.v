/*
*作者：zzq
*创建时间：2023-04-06
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*
*/
/*************\
bug:
1. 由于excep_en的信号便于实现，所以新增不同例外的使能信号(pc_addr_error)，组合成excep_en信号
2. 取指令地址异常是pc[1:0]!=0,不是pc[31:30]!=0
3.握手有问题，冲刷信号是要把本级设置为0,但是如果当前时钟本级的data_ok还没到，就需要设在ce信号，和设置本级无效不做的话，这个指令等冲刷信号消失的时候会因为本级数据不会空，会流下去，导致产生执行效果
4.有取指令例外应该放行（我没有放行），因为不会发出取指令req，自然不会有data_ok
\*************/
`include "DefineModuleBus.h"
module IF(
    input wire id_allowin_i,
    input wire if_valid_i,

    output wire if_allowin_o,
    output wire line1_if_to_id_valid_o,
    output wire line2_if_to_id_valid_o,
    //冲刷信号
    input  wire excep_flush_i,
   
    
    //input  wire [`InstRdataBufferBusWidth]inst_rdata_buffer_i,
    input  wire                       inst_rdata_buffer_ok_i,
    input  wire [`PcWidth]            inst_rdata_buffer_rdata_i,
    input  wire                       inst_sram_data_ok_i,
    input  wire                       cache_we_i,
    input  wire                       icache_iowe_useless_i,
    input  wire [`PreifToIfBusWidth]  pi_to_ibus,
    input  wire                       interrupt_en_i,
    input  wire [`InstWidth]          ram_inst1_i       ,
    //input  wire [`ICacheReadObusWidth]icache_to_ibus,
    input  wire [`MmuToIfBusWidth]    mmu_to_ibus,
    
    output wire                       inst_ram_req_o,
    output wire [`IfToMmuBusWidth]    to_mmu_obus,
    output wire [`IfToPreifBusWidth]  to_preif_obus,
    output wire [`IfToICacheBusWidth] to_icache_obus,
    output wire [`IfToIdBusWidth]     to_id_obus
         
);

/***************************************input variable define(输入变量定义)**************************************/
wire [`PcWidth]pc1_i;
wire [`PcWidth]pc2_i;

wire [`ExceptionTypeWidth]line1_excep_type_i;
wire line1_excep_en_i;
wire [`ExceptionTypeWidth]line2_excep_type_i;
wire line2_excep_en_i;

wire [`InstWidth]inst1_i;
wire inst1_en_i;
wire inst2_en_i;
wire [`InstWidth]inst2_i;

wire inst_ram_req_i;//当前if级的指令向指令存储器发过请求
////指令缓存
//wire inst_rdata_buffer_ok_i;
//wire [`PcWidth]inst_rdata_buffer_rdata_i;
//例外
 wire line1_tlb_excpet_en_i;
 wire line1_tlb_adef_except_en_i;
 wire line1_tlb_adef_excep_i   ;
 wire line1_tlb_fetchr_excep_i ;   
 wire line1_tlb_pif_excep_i    ;   
 wire line1_tlb_ppi_excep_i    ;
 
 
 
 
 
 
 //实物理地址
 wire [`PcWidth]p_line1_pc_i;//实物理地址
 wire uncache_i;
/***************************************output variable define(输出变量定义)**************************************/
wire [`ExceptionTypeWidth]line1_excep_type_o;
wire line1_excep_en_o;
wire [`ExceptionTypeWidth]line2_excep_type_o;
wire line2_excep_en_o;
wire line2_icache_find_o,line1_icache_find_o;
//cache
wire cache_we_o;
//指令
wire [`PcWidth]line2_inst_o,line1_inst_o;
//顺序执行的pc
wire [`PcWidth]to_preif_pc_o;
wire to_preif_pc_we_o;
//cache
wire [19:0]p_tag_o;
wire uncache_o;
//作用是tlb的例外,导致虚拟地址和物理地址严重不一样,出现回填,
//因为我回填的地址index是,虚地址提供的
//访问外界的index是虚拟地址提供的
//回填的tag是虚拟地址提供的
//访问外界的tag是物理地址提供的,映射错误(非tlb错误的例外可以不用取消回填,因为不存在这种错误)
wire cache_refill_valid_o;
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
wire line1_excep_en;
wire inst_en_i;
wire line2_pc_addr_error;
//例外
wire line1_pc_adef;
//握手
wire if_ready_go;
/****************************************input decode(输入解码)***************************************/
assign  {inst_ram_req_i,line2_excep_en_i,line2_excep_type_i,pc2_i,line1_excep_en_i,line1_excep_type_i,pc1_i} = pi_to_ibus;

assign inst2_en_i = 1'b0;
assign {uncache_i,
        line1_tlb_excpet_en_i,line1_tlb_adef_except_en_i,line1_tlb_fetchr_excep_i,line1_tlb_pif_excep_i,line1_tlb_ppi_excep_i,
        p_line1_pc_i} = mmu_to_ibus ;
/****************************************output code(输出解码)***************************************/

//line2被找到啦，且本及允许输入，则preif才能连5跳两个`
assign to_preif_obus = {to_preif_pc_we_o,to_preif_pc_o } ;//line2永远是line1的+4,查找成功就是pc2+4,pc2+8,成功就是，pc1+4,pc2+4

assign inst_ram_req_o = inst_ram_req_i;

assign to_id_obus = {line2_icache_find_o,line2_excep_en_o,line2_excep_type_o,pc2_i,line2_inst_o,line1_icache_find_o,line1_excep_en_o,line1_excep_type_o,pc1_i,line1_inst_o};

assign to_mmu_obus = pc1_i;
assign to_icache_obus = {cache_refill_valid_o,uncache_o,p_tag_o};
/*******************************complete logical function (逻辑功能实现)*******************************/
//topreif,这个顺序执行的写信号只会维持一个时钟周期
//if级数据有效，且允许写入则可以发出请求要求preif使用if阶段的pc,冲刷流水的时候不允许发出写
assign to_preif_pc_we_o = if_valid_i && if_allowin_o && (!excep_flush_i);
assign to_preif_pc_o   =  inst2_en_i&&if_allowin_o ? pc2_i : pc1_i;


//指令
assign line1_inst_o = inst_rdata_buffer_ok_i ? inst_rdata_buffer_rdata_i : ram_inst1_i;//如果是指令缓存有效则选用指令缓存为数据
assign line2_inst_o = inst2_i;


assign line2_pc_addr_error = pc2_i[1:0]!= 2'b00 ? 1'b1:1'b0;

//例外(中断信号中标记在第一条指令上面，因为第二条指令是会被冲刷的)
//取值地址错误例外
assign line1_pc_adef = pc1_i[1:0]!=2'b00 ? 1'b1:1'b0;

assign line1_excep_type_o[`IntEcode]                     = interrupt_en_i ? 1'b1 : 1'b0;//0
assign line1_excep_type_o[`PisLocation:`PilLocation]     = line1_excep_type_i[`PisLocation:`PilLocation];// 2：1
assign line1_excep_type_o[`PifLocation]                  = line1_tlb_pif_excep_i ;//3
assign line1_excep_type_o[`PpiLocation:`PmeLocation]     = line1_excep_type_i[`PpiLocation:`PmeLocation];// 5：4
assign line1_excep_type_o[`AdefLocation]                 = line1_pc_adef|line1_tlb_adef_except_en_i;//6
assign line1_excep_type_o[`IfTlbrLocation:`AdemLocation] = line1_excep_type_i[`IfTlbrLocation:`AdemLocation];//17-7
assign line1_excep_type_o[`IfTlbrLocation]               = line1_tlb_fetchr_excep_i;//17
assign line1_excep_type_o[`TifLocation]                  = 1'b0;//18
assign line1_excep_type_o[`IfPpiLocation]                = line1_tlb_ppi_excep_i;//19
assign line1_excep_en = line1_excep_en_i|interrupt_en_i||line1_pc_adef|line1_tlb_excpet_en_i;
assign line1_excep_en_o = line1_excep_en && if_valid_i;//interrupt_en_i必须有初始化值，pc_addr_error必须有初始值


assign line2_excep_type_o[`PpiLocation:`IntEcode]       = line2_excep_type_i[`PpiLocation:`IntEcode];//5：0
assign line2_excep_type_o[`AdefLocation]                = line2_pc_addr_error;//6
assign line2_excep_type_o[`IfPpiLocation:`AdemLocation] = line2_excep_type_i[`IfPpiLocation:`AdemLocation];//19-7
assign line2_excep_en_o = (line2_excep_en_i||line2_pc_addr_error) && if_valid_i;//interrupt_en_i必须有初始化值，pc_addr_error必须有初始值
//icache查找成功信号
//line1永远查找成功
assign line1_icache_find_o = 1'b1;
//当当前指令是无效指令时候，icache_iowe_useless_i=1,默认这条指令被找到啦，不允许进行cache写
assign line2_icache_find_o = inst2_en_i|icache_iowe_useless_i;

//cache
assign cache_we_o = cache_we_i&(~icache_iowe_useless_i);
assign p_tag_o = p_line1_pc_i[31:12];
//当前指令有效,该指令是uncache属性则有效
//当前来了冲刷信号,这条指令应该没有执行效果,使其uncache消失,防止这个要取消的指令占据cache状态机
//当前指令携带例外信息,也是如此取消uncache属性,防止其占用cache状态机损失性能(不取消也是可以的)
assign uncache_o = uncache_i & if_valid_i &(~line1_excep_en_o)&(~excep_flush_i);

assign cache_refill_valid_o = if_valid_i&(~line1_excep_en)&(~excep_flush_i);
// 握手
      //如果inst_data_ok出现但是下一级不允许写入，则选用buffer_ok信号作为inst_data_oki
      //有取指令例外(line1_excep_en_i==1且if_valid_i==1)应该放行，因为不会发出取指令req，自然不会有data_ok
      assign if_ready_go   = inst_sram_data_ok_i ||inst_rdata_buffer_ok_i||(line1_excep_en_i&if_valid_i); //id阶段数据是否运算好了，1：是
      assign if_allowin_o  = (!if_valid_i) //本级数据为空，允许if阶段写入
                           || (if_ready_go && id_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
                           
      assign line1_if_to_id_valid_o = if_valid_i && if_ready_go;//id阶段打算写入
      
      assign line2_if_to_id_valid_o = if_valid_i&& inst2_en_i && if_ready_go;//id阶段打算写入



endmodule
