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
`include "DefineAluOp.h"
module Arith_Logic_Unit(
    input  wire [`AluOperWidth] x       ,   // 源操作数x, rj，oper1
    input  wire [`AluOperWidth] y       ,   // 源操作数y, rk,oper2
    input  wire [`AluOpWidth] aluop   ,   // alu op
    
    output wire [`AluOperWidth] alu_rl_o,            // 运算结果 result
    output wire [`AluOperWidth]alu_rh_o

);

/***************************************input variable define(输入变量定义)**************************************/

/***************************************output variable define(输出变量定义)**************************************/

/***************************************parameter define(常量定义)**************************************/

/***************************************inner variable define(内部变量定义)**************************************/
reg [`AluOperWidth] rl;
reg [`AluOperWidth] rh;
wire [63:0]x_sign,y_sign,x_zero,y_zero;
/****************************************input decode(输入解码)***************************************/

/****************************************output code(输出解码)***************************************/
assign {alu_rh_o,alu_rl_o} = {rh,rl};

/*******************************complete logical function (逻辑功能实现)*******************************/
    assign x_sign ={{32{x[31]}},x};
    assign y_sign ={ {32{y[31]}} , y };
    
    assign x_zero ={32'h0,x};
    assign y_zero ={32'h0,y};
    
    always @(*)begin                // 本写法最简单明了 (还可优化，加减比较都可通过加法器解决)
//        r = 0;
        case(aluop)
            `SllAluOp: {rh,rl} = (x << y[4:0]);                     // 0sll, sllv
            `SrlAluOp: {rh,rl} = (x >> y[4:0]);                     // 1srl, srlv
            `SraAluOp: {rh,rl} = ($signed(x) >>> y[4:0]);           // 2sra, srav   
            // (verilog变量默认无符号数, $signed()强制转换为有符号数, ">>>"算术右移运算符)
            
            `AddAluOp: {rh,rl} = x + y;                             // 3add发生溢出，默认将进位删除了，只保留32位，而不是多出一位33位
            `SubAluOp: {rh,rl} = x - y;                             // 4sub

            `AndAluOp: {rh,rl} =  (x & y);                          // 5and
            `OrAluOp : {rh,rl} =  (x | y);                          // 6or
            `XorAluOp: {rh,rl}=  (x ^ y);                          // 7xor
            `NorAluOp: {rh,rl} = ~(x | y);                          // 8nor

            `SltAluOp : {rh,rl} = ($signed(x) < $signed(y))? 1 : 0; //9slt
            `SltuAluOp: {rh,rl} = (x < y)? 1 : 0;                   //10sltu

            `LuiAluOp: {rh,rl} = {y[15:0], 16'h0000};               //11 lui
            `MulAluOp: {rh,rl} = $signed(x_sign)*$signed(y_sign);  //mul
            `MuluAluOp:{rh,rl}=$unsigned(x_zero) * $unsigned(y_zero);
            
            `DivAluOp:  {rh,rl} =$signed(x)/$signed(y);
            `ModAluOp: {rh,rl}  =$signed(x)%$signed(y);
            `DivuAluOp:{rh,rl}=$unsigned(x) /$unsigned(y);
            `ModuAluOp: {rh,rl}  =$unsigned(x)%$unsigned(y);
          
            default: {rh,rl} = 0;
        endcase
    end
endmodule


