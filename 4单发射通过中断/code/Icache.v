/*
*作者：zzq
*创建时间：2023-04-21
*email:3486829357@qq.com
*github:yunzhong8
*输入：
*输出：
*模块功能：
*实现8路4组的双端口读，单端口写的全相连icache
*/
/*************\
bug:
\*************/
//`include xxx.h
module Icache(
    input  wire  clk      ,
    input  wire  rst_n    ,

    input  wire           ,
    input  wire           ,
    output wire           ,
    output wire

input  wire             rst_n              ,
input  wire             clk               ,

input  wire             re1_i             ,//1�ſڶ�ʹ��
input  wire  [`PCBus]   raddr1_i          ,//1�ſڶ���ַ
input  wire             re2_i             ,//2�ſڶ�ʹ��   
input  wire  [`PCBus]   raddr2_i          ,//2�ſڶ���ַ 
  
input  wire                        we_i              ,//дʹ��
input wire   [`CacheAddrBus]       waddr_i             , //组内写哪一行，waddr_i = wcnt_o%4
input wire   [`CacheIndexBus]      windex_i            , //写哪一组，windex_i= wcnt_o/4
input  wire  [`PCBus]              wpcdata_i           ,//写入pc
input  wire  [`InstBus]            winstdata_i           ,//写入指令

 

//���
output wire              rt1_o            ,//1�ſ��Ƿ�����ɹ�
output wire  [`InstBus]  rdata1_o         ,//1�ſڶ�������
output wire              rt2_o            ,
output wire  [`InstBus]  rdata2_o         ,
output wire   [`CacheAddrBus]       wcnt_o
 
    );


);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/

    //4组
    wire ic0_we;
    wire ic0_rt1,ic0_rt2;
    wire [31:0]ic0_rdata1,ic0_rdata2;
    
    wire ic1_we;
    wire ic1_rt1,ic1_rt2;
    wire [31:0]ic1_rdata1,ic1_rdata2;
    
    wire ic2_we;
    wire ic2_rt1,ic2_rt2;
    wire [31:0]ic2_rdata1,ic2_rdata2;
    
    wire ic3_we;
    wire ic3_rt1,ic3_rt2;
    wire [31:0]ic3_rdata1,ic3_rdata2;
    //cache地址
    reg [`CacheAddrBus]wcnt;
/****************************************input decode(输入解码)***************************************/


/****************************************output code(输出解码)***************************************/

/*******************************complete logical function (逻辑功能实现)*******************************/

    //д�������
    assign wcnt_o = we_i? waddr_i:wcnt;
    
    always @(posedge clk)begin
        if(rst_n==`RstEnable)begin
            wcnt <=6'd0;
        end else if( we_i )begin
            wcnt<=waddr_i;
        end else begin
            wcnt<=wcnt;
        end
    end  
    
    IcacheGroup Group0(
       .rst_n         ( rst_n       )   ,
       .clk           ( clk        )   ,
       .re1_i         ( re1_i      )   ,
       .raddr1_i      ( raddr1_i   )   ,
       .re2_i         ( re2_i       )   ,
       .raddr2_i      ( raddr2_i   )   ,
       .we_i          ( windex_i[0]&we_i     )   ,
       .waddr_i       ( waddr_i[2:0] )   ,
       .wpcdata_i     ( wpcdata_i    )   ,
       .winstdata_i   ( winstdata_i    )   ,
//       .              (      
       .rt1_o         ( ic0_rt1    )   ,
       .rdata1_o      ( ic0_rdata1 )   ,
       .rt2_o         ( ic0_rt2    )   ,
       .rdata2_o      ( ic0_rdata2 )              
    );
    IcacheGroup Group1(
       .rst_n          ( rst_n       )   ,
       .clk           ( clk        )   ,
       .re1_i         ( re1_i      )   ,
       .raddr1_i      ( raddr1_i   )   ,
       .re2_i          ( re2_i      )   ,
       .raddr2_i      ( raddr2_i   )   ,
       .we_i          ( windex_i[1]&we_i     )   ,
       .waddr_i       ( waddr_i[2:0]    )   ,
       .wpcdata_i     ( wpcdata_i     )   ,
       .winstdata_i   ( winstdata_i   )   ,
//       .              (      
       .rt1_o         ( ic1_rt1    )   ,
       .rdata1_o      ( ic1_rdata1 )   ,
       .rt2_o         ( ic1_rt2    )   ,
       .rdata2_o      ( ic1_rdata2 )              
    );
    IcacheGroup Group2(
       .rst_n          ( rst_n       )   ,
       .clk           ( clk        )   ,
       .re1_i           ( re1_i      )   ,
       .raddr1_i      ( raddr1_i   )   ,
       .re2_i          ( re2_i      )   ,
       .raddr2_i      ( raddr2_i   )   ,
       .we_i          ( windex_i[2]&we_i     )   ,
       .waddr_i       ( waddr_i[2:0] )   ,
       .wpcdata_i     ( wpcdata_i      )   ,
       .winstdata_i   ( winstdata_i    )   ,
  
       .rt1_o         ( ic2_rt1    )   ,
       .rdata1_o      ( ic2_rdata1 )   ,
       .rt2_o         ( ic2_rt2    )   ,
       .rdata2_o      ( ic2_rdata2 )              
    );
    IcacheGroup Group3(
       .rst_n          ( rst_n       )   ,
       .clk           ( clk        )   ,
       .re1_i         ( re1_i      )   ,
       .raddr1_i      ( raddr1_i   )   ,
       .re2_i         ( re2_i      )   ,
       .raddr2_i      ( raddr2_i   )   ,
       .we_i          ( windex_i[3]&we_i     )   ,
       .waddr_i       ( waddr_i[2:0]    )   ,
       .wpcdata_i     ( wpcdata_i      )   ,
       .winstdata_i   ( winstdata_i    )   ,
      
       .rt1_o         ( ic3_rt1    )   ,
       .rdata1_o      ( ic3_rdata1 )   ,
       .rt2_o         ( ic3_rt2    )   ,
       .rdata2_o      ( ic3_rdata2 )              
    );
    //读端口1
    //读命中
    assign  rt1_o=ic0_rt1|ic1_rt1|ic2_rt1|ic3_rt1;
    assign rdata1_o=ic0_rt1?ic0_rdata1:
                    ic1_rt1?ic1_rdata1:
                    ic2_rt1?ic2_rdata1:
                    ic3_rt1?ic3_rdata1:32'h0000_0000;
    //读端口2
    //读命中
    assign  rt2_o=ic0_rt2|ic1_rt2|ic2_rt2|ic3_rt2;                
    assign rdata2_o=ic0_rt2?ic0_rdata2:
                    ic1_rt2?ic1_rdata2:
                    ic2_rt2?ic2_rdata2:
                    ic3_rt2?ic3_rdata2:32'h0000_0000;
endmodule
