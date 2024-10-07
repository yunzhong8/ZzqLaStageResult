/*
*作者：zzq
*创建时间：2023-04-10
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*控制信号:

*/
/*************\
bug:
excpcode忘记设置位宽导致，estate没有修改
1. 例外冲刷信号和wb_valid有关wb_flush_o即fulsh = wb_valid & except|ertn
\*************/
`include "DefineModuleBus.h"
module WB(
    input  wire rfb_allowin_i         ,
    input  wire wb_valid_i             ,

    output wire wb_allowin_o          ,
    output wire wb_to_rfb_valid_o     ,  
    //冲刷流水
    output wire wb_flush_o,  
    
    input  wire [`LineMemToWbBusWidth]mw_to_ibus,
    input  wire [`LineCsrToWbWidth]csr_to_ibus,
    input  wire [`MmuToWbBusWidth]mmu_to_ibus,
    
    output wire [`LineWbToDebugBusWidth]to_debug_obus,
    output wire [`LineRegsWriteBusWidth]   to_regs_obus    ,
    output wire [`LineWbToCsrWidth]   to_csr_obus          ,
    output wire [`WbToMmuBusWidth]to_mmu_obus,
    output wire [`WbToCacheBusWidth]to_cache_obus,
    output wire [`ExcepToCsrWidth]excep_to_csr_obus    //发出当前要执行例外了
    
    
);

/***************************************input variable define(输入变量定义)**************************************/
 wire [`PcWidth]pc_i;
 wire [`InstWidth]inst_i;

 //regs
 wire regs_we_i;
 wire [`RegsAddrWidth]regs_waddr_i;
 wire [`RegsDataWidth]regs_wdata_i;
//csr
 wire is_kernel_inst_i,wb_regs_wdata_src_i;   
 wire csr_we_i; 
 wire [`CsrAddrWidth]  csr_waddr_i;
 wire [`RegsDataWidth] csr_wdata_i;
 wire [`RegsDataWidth] csr_rdata_i;
 wire [1:0]cpu_level_i;
 wire csr_llbit_i;
 
 //llbit
 wire llbit_we_i;
 wire llbit_wdata_i;
 //例外                                      
 wire [`ExceptionTypeWidth]excep_type_i;   
 wire excep_en_i;             
 //tlb
 wire tlb_re_i         ;
 wire tlb_we_i         ;      
 wire tlb_se_i         ;
 wire [`TlbIndexWidth]tlbidx_index_i; 
 wire tlbidx_ne_i;  
 wire tlb_ie_i         ; 
 wire tlb_fe_i         ;
 wire [`InvtlbOpWidth]tlb_op_i     ;
 wire line_tlb_rhit_i;//读命中
 wire line_tlb_shit_i;//查找命中
//cache
        wire sotre_buffer_we_i;    
            
     
/***************************************output variable define(输出变量定义)**************************************/
 wire    regs_we_o;
 wire  [`RegsAddrWidth]regs_waddr_o;
 wire  [`RegsDataWidth]regs_wdata_o;
 wire  [`RegsDataWidth]regs_rdata1_i;
 wire  [`RegsDataWidth]regs_rdata2_i;
 
 //csr
 wire csr_wdata_src_i;
 wire csr_raddr_src_i; 
 wire csr_we_o; 
 wire [`CsrAddrWidth]csr_waddr_o;
 wire [`RegsDataWidth]csr_wdata_o;
 wire [`CsrAddrWidth]csr_raddr_o;
 //tlbcsr
  wire tlb_re_o         ; 
  wire [31:0]r_tlbehi_i;
  wire [31:0]r_tlblo0_i;
  wire [31:0]r_tlblo1_i;
  wire [`PsWidth]r_tlbidx_ps_i;
  wire [`AsidWidth]r_asid_asid_i;
  
  wire tlb_we_o         ;
  wire tlb_se_o         ;
  wire tlb_ie_o         ; 
  wire tlb_fe_o         ;
 
  wire [`VppnWidth]invtlb_vppn_o;
  wire [`AsidWidth]invtlb_asid_o;
  
 
 
 //llbit                     
  wire llbit_we_o;            
  wire llbit_wdata_o;         
 //例外          
  wire excep_ipe;              
  wire excep_en_o; 
  wire  tlb_except_en_o;//tlb例外使能，用于和其他例外区分，因为这个例外的的入口地址是不同的  
  wire  except_badv_we_o;//需要写入虚拟地址的例外
  wire  tlbr_except_en_o;//tlb充填例外         
  wire [`EcodeWidth]excep_ecode_o;         
  wire [`EsubCodeWidth]excep_esubcode_o;      
  wire [`PcWidth]excep_pc_o;
  wire [`MemAddrWidth]mem_rwaddr_i;  
  
  wire excep_badv_we_o;//地址错误就要进行该操作
  wire [`PcWidth]exce_badv_wdata_o;
 //例外返回                      
  wire ertn_en_o;
  //cache
        wire sotre_buffer_we_o;                 
  
/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
 // 当前控制信号有效(即输入的是有效的,但是输出则要看now_ctl_valid),if now_ctl_valid==0,则表明当前所有控制信号无效,即等于0,所以对控制信号的设置必须是高点平有效
 //依赖:valid(最基本的),flsuh信号(其有效是否页依赖当前指令是否是valid)
 wire now_ctl_valid;

 wire wb_ready_go ;
 //csr
 wire csr_rere_i;//csr重读信号
 //
 wire excep_pc_error;
 wire excep_mem_addr_error;
//例外
wire excep_en;
wire ertn_en;
 
  
/****************************************input decode(输入解码)***************************************/
assign {sotre_buffer_we_i,
        tlb_fe_i,tlb_se_i,tlb_re_i,tlb_we_i,tlb_ie_i,
        tlb_op_i,line_tlb_shit_i,tlbidx_ne_i,tlbidx_index_i,
        is_kernel_inst_i,
        csr_wdata_src_i,regs_rdata1_i,regs_rdata2_i,
        excep_en_i,excep_type_i,mem_rwaddr_i,
        llbit_we_i,llbit_wdata_i,
        csr_raddr_src_i,csr_we_i,csr_waddr_i,csr_wdata_i,
        wb_regs_wdata_src_i,regs_we_i,regs_waddr_i,regs_wdata_i,
        pc_i,inst_i} = mw_to_ibus;
assign {csr_llbit_i,cpu_level_i,csr_rdata_i} = csr_to_ibus ;
assign {line_tlb_rhit_i,r_tlbehi_i,r_tlblo0_i,r_tlblo1_i,r_tlbidx_ps_i,r_asid_asid_i} = mmu_to_ibus;

/****************************************output code(输出解码)***************************************/
assign wb_flush_o = (excep_en_o|ertn_en_o|tlb_inst_flush_en_o)& wb_valid_i;
 
assign to_regs_obus       = {regs_we_o,regs_waddr_o,regs_wdata_o};

assign to_csr_obus        = {
                            tlb_re_o,line_tlb_rhit_i,r_tlbehi_i,r_tlblo0_i,r_tlblo1_i,r_tlbidx_ps_i,r_asid_asid_i,
                            tlb_se_o,line_tlb_shit_i,tlbidx_index_i,tlbidx_ne_i,
                            csr_raddr_o,
                            llbit_we_o,llbit_wdata_o,
                            csr_we_o,csr_waddr_o,csr_wdata_o};
assign excep_to_csr_obus  = { 
                            tlb_except_en_o,
                            tlb_inst_flush_en_o,
                            tlbr_except_en_o,//tlb重填例外
                            excep_badv_we_o,exce_badv_wdata_o,//1+32
                            ertn_en_o,//1
                            excep_en_o,excep_ecode_o,excep_esubcode_o,excep_pc_o};
assign to_mmu_obus = {tlb_fe_o,tlb_we_o,tlb_ie_o,tlb_op_i,invtlb_vppn_o,invtlb_asid_o};
assign to_cache_obus = sotre_buffer_we_o;
                            
assign to_debug_obus      = {regs_we_o,regs_waddr_o,regs_wdata_o,pc_i};
/*******************************complete logical function (逻辑功能实现)*******************************/

assign regs_we_o    = regs_we_i & now_ctl_valid;//本级不发生例外，返回，且数据有效才有效
assign regs_waddr_o = regs_waddr_i;
assign regs_wdata_o = wb_regs_wdata_src_i ? csr_rdata_i: regs_wdata_i ;

assign csr_we_o    = csr_we_i  & now_ctl_valid;
assign csr_waddr_o = csr_waddr_i;
assign csr_wdata_o = csr_wdata_src_i ? ( (regs_rdata2_i & regs_rdata1_i) | (csr_rdata_i & (~regs_rdata1_i)) ) : regs_rdata2_i;
assign csr_raddr_o = csr_raddr_src_i ? csr_waddr_i : `TIdRegAddr;

//llbit
assign llbit_we_o = llbit_we_i & now_ctl_valid;
assign llbit_wdata_o = llbit_wdata_i;
//TLB
assign tlb_we_o = tlb_we_i & now_ctl_valid;
assign tlb_re_o = tlb_re_i & now_ctl_valid;//作用控制csr进行写
assign tlb_se_o = tlb_se_i & now_ctl_valid;
assign tlb_fe_o = tlb_fe_i & now_ctl_valid;      

assign tlb_ie_o           = tlb_ie_i &now_ctl_valid;
assign invtlb_asid_o      = regs_rdata1_i[`AsidWidth];
assign invtlb_vppn_o      = regs_rdata2_i[31:13]; 


//例外
assign excep_ipe            = (cpu_level_i==2'b11 && is_kernel_inst_i)? 1'b1 : 1'b0;//特权指令执行在核心态发生特权等级例外
assign excep_pc_error       = excep_en_o & (excep_type_i[6] | excep_type_i[3] |excep_type_i[17]|excep_type_i[19]);//虚拟地址
assign excep_mem_addr_error = excep_en_o & (excep_type_i[7]|excep_type_i[8] | excep_type_i[15]|excep_type_i[1]|excep_type_i[2]|excep_type_i[5]|excep_type_i[4]) ;
//tlb指令冲刷信号有效的时候，只有中断例外会有效
assign excep_en_o        = excep_en & wb_valid_i ;
//输入例外使能,当前阶段例外使能且例外信息是异常信息
assign excep_en          =   (excep_en_i | excep_ipe) &(( excep_type_i[15:0] != 16'h0) || excep_type_i[17]!=1'b0 || excep_type_i[19]!=1'b0) ;
assign excep_badv_we_o   = excep_pc_error | excep_mem_addr_error;
assign exce_badv_wdata_o = excep_pc_error ? pc_i: mem_rwaddr_i;
assign excep_pc_o = pc_i;
//在此跳转优先级
assign {excep_ecode_o, excep_esubcode_o} = //取指令阶段()取指令的TLB应该独立出来，因为这个优先级是属于IF级的是更高的
                                           excep_type_i[0]  ? {`IntEcode    ,`EsubCodeLen'h0} ://中断例外
                                           excep_type_i[6]  ? {`AdefEcode   ,`EsubCodeLen'h0} ://取指令地址例外
                                           excep_type_i[3]  ? {`PifEcode    ,`EsubCodeLen'h0} ://取指操作页例外
                                           excep_type_i[17] ? {`TlbrEcode   ,`EsubCodeLen'h0} ://取指令的TLB重填
                                           excep_type_i[19]  ? {`PpiEcode    ,`EsubCodeLen'h0} ://取指令页特权等级例外
                                           
                                           //id阶段
                                           excep_type_i[9]  ? {`SysEcode    ,`EsubCodeLen'h0} ://系统调用例外
                                           excep_type_i[10] ? {`BrkEcode    ,`EsubCodeLen'h0} ://断点例外
                                           excep_type_i[11] ? {`IneEcode    ,`EsubCodeLen'h0} ://指令不存在例外
                                           //exe级
                                           excep_type_i[8]  ? {`AleEcode    ,`EsubCodeLen'h0} ://地址非对齐例外
                                           excep_type_i[7]  ? {`AdemEcode   ,`EsubCodeLen'h1} ://访存指令例外
                                           
                                           excep_type_i[15] ? {`TlbrEcode   ,`EsubCodeLen'h0} ://TLB重填
                                           excep_type_i[1]  ? {`PilEcode    ,`EsubCodeLen'h0} ://load的操作页例外，TLB
                                           excep_type_i[2]  ? {`PisEcode    ,`EsubCodeLen'h0} ://store的操作页例外，TLB
                                           excep_type_i[5]  ? {`PpiEcode    ,`EsubCodeLen'h0} ://页特权等级例外
                                           excep_type_i[4]  ? {`PmeEcode    ,`EsubCodeLen'h0} ://页修改例外
                                           //wb
                                           excep_ipe        ? {`IpeEcode    ,`EsubCodeLen'h0} ://指令特权等级例外
                                           excep_type_i[13] ? {`FpdEcode    ,`EsubCodeLen'h0} ://浮点指令未使能例外
                                           excep_type_i[14] ? {`FpeEcode    ,`EsubCodeLen'h0} :15'h0;//基础浮点指令例外
                                          
 //返回
 assign ertn_en_o =  ertn_en & wb_valid_i; 
 assign ertn_en   =  excep_en_i & excep_type_i[16] ;    
 //tlb重填例外使能本信号有效的时候，except_en信号必有效，本信号只用与裁决例外入口地址而已
 assign tlbr_except_en_o =  excep_en_i & (excep_type_i[`IfTlbrLocation]| excep_type_i[`TlbrLocation]) & wb_valid_i;
 //tlb类型的例外
 //为什么软件维护tlb这么复杂，tlb例外发生需要设置这么多东西，为什么要有tlb，反正现在CPU技术无法突破啦，还不如放弃tlb这种无聊虚实地址转换机制
  assign tlb_except_en_o     = excep_en_o &(excep_type_i[17]|excep_type_i[15]|excep_type_i[1]|excep_type_i[2]|excep_type_i[3]|excep_type_i[4]|excep_type_i[5]|excep_type_i[19]);     
 //tlb指令刷新流水线，本信号有效的时候，非中断例外的例外不会响应
 assign  tlb_inst_flush_en_o =   tlb_re_i&tlb_ie_i&tlb_we_i&tlb_fe_i & now_ctl_valid;     
 
                              
 //cache
//有效的前提:当前指令有效,当前指令不发出冲刷请求
//当llbit_we有效且wdata=0表明这是sc指令,则写有效要等llbit的值
assign sotre_buffer_we_o = llbit_we_i&(~llbit_wdata_i) ? csr_llbit_i&sotre_buffer_we_i&now_ctl_valid : sotre_buffer_we_i&now_ctl_valid;                                          
                                        
                                           
                                    
                                           
                                           
                                           
                                           
//控制有效
//当前指令有效(基本)
//当前指令没有携带例外信息,返回信息,tlb指令冲刷信息
assign now_ctl_valid =  wb_valid_i & (~excep_en_o) & (~ertn_en_o);                                          
                                           
                                                                           
//握手
    assign wb_ready_go   = 1'b1; //id阶段数据是否运算好了，1：是
    
    assign wb_allowin_o  = !wb_valid_i //本级数据为空，允许if阶段写入
                             || (wb_ready_go && rfb_allowin_i);//本级有数据要运行，本时钟周期，id阶段运算好了，exe也同时允许写入，同写，和取走数据
    assign wb_to_rfb_valid_o = wb_valid_i && wb_ready_go;//id阶段打算写入


endmodule
