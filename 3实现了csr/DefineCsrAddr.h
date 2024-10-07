/*
 * DefineCsr.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */

`include "DefineLoogLenWidth.h"
`ifndef DEFINECSR_H
`define DEFINECSR_H

    `define CrmdRegAddr      `CsrAddrLen'h0
    `define PrmdRegAddr      `CsrAddrLen'h1
    `define EuenRegAddr      `CsrAddrLen'h2
    `define ECfgRegAddr      `CsrAddrLen'h4
    `define EStatRegAddr     `CsrAddrLen'h5
    
    `define ERARegAddr       `CsrAddrLen'h6
    `define BAdVRegAddr      `CsrAddrLen'h7
    `define EentryRegAddr    `CsrAddrLen'hc
    
    `define TlbIdxRegAddr    `CsrAddrLen'h10
    `define TlbEhiRegAddr    `CsrAddrLen'h11
    `define TlbElo0RegAddr   `CsrAddrLen'h12
    `define TlbElo1RegAddr   `CsrAddrLen'h13
    
    `define AsIdRegAddr      `CsrAddrLen'h18
    `define PgdLRegAddr      `CsrAddrLen'h19
    `define PgdHtRegAddr     `CsrAddrLen'h1a
    `define PgdRegAddr       `CsrAddrLen'h1b
    
    `define CpuIdRegAddr     `CsrAddrLen'h20
    
    `define Save0RegAddr     `CsrAddrLen'h30
    `define Save1RegAddr     `CsrAddrLen'h31
    `define Save2RegAddr     `CsrAddrLen'h32
    `define Save3RegAddr     `CsrAddrLen'h33
    
    `define TIdRegAddr       `CsrAddrLen'h40
    `define TCfgRegAddr      `CsrAddrLen'h41
    `define TValRegAddr      `CsrAddrLen'h42
    `define TiClrRegAddr     `CsrAddrLen'h44
    
    `define LlbCtlRegAddr    `CsrAddrLen'h60
    `define TlbRentryRegAddr `CsrAddrLen'h88
    `define CTagRegAddr      `CsrAddrLen'h98
    `define DmW0RegAddr      `CsrAddrLen'h180
    `define DmW1RegAddr      `CsrAddrLen'h181
//CSR寄存器信号的location
    //Crmd
    `define CrmdPlvLocation  1:0
    `define CrmdIeLocation   2
    `define CrmdDaLocation   3
    `define CrmdPgLocation   4
    `define CrmdDatfLocation 6:5
    `define CrmdDatmLocation 8:7
//PRMD
    `define PrmdPllvLocation 1:0
    `define PrmdPieLocation  2
//EUEN    
    `define EuenFpeLocation 0
//ECFG
    `define EcfgLieSHLocation 9:0
    `define EcfgLieTILocation 12:11
//ESTAT
    `define EstatIsSwiLocation 1:0
    `define EstatIsHwiLocation  9:2
    `define EstatIsTiLocation  11
    `define EstatIsIpiLocation 12
    `define EstatEcodeLocation 21:16
    `define EstatEsubCodeLocation 30:22
//ERA
    `define EraPcLocation `RegsDataLen-1:0 //长度等于寄存器组的值长度
//BADV
    `define BadvVaddrLocation `RegsDataLen-1:0
//EENTRY
    `define EentryVaLocation 31:6
//CPUID    
    `define CoreIDLocation 8:0
//SAVE    
    `define SaveDataLocation 31:0
//LLBCTL
    `define LlbctlRollbLocation 0
    `define LlbctlWcllbLocation 1
    `define LlbctlKloLocation  2
//TLB
    `define TlbidxIndxLocation 15:0//该值和tlb定义有关需要修改，最大为15
    `define TLbidxPsLocation   29:24
    `define TLbidxNeLocation   31
//TlbEHI
    `define TlbehiVppnLocation 31:13
//TLBELO    
    `define Plen 36
    `define TlbeloVLocation 0
    `define TlbeloDLocation 1
    `define TlbeloPlvLocation 3:2
    `define TlbeloMatLocation 5:4
    `define TlbeloGLocation 6
    `define TlbeloPpnLocation `Palen-5:8//由页表长度palen决定
//ASID
    `define AsidAsidLocation 9:0
    `define AsidAsidBitsLocation 23:16
//PGDL
    `define PgdlBaseLocation 31:12
//PGDh
    `define PgdhBaseLocation 31:12
//PGd
    `define PgdBaseLocation 31:12
//Tlbrentry
    `define TlbrentryPaLocation 31:6
//DMW
    `define DmwPlv0Location 0
    `define DmwPlv3Location 3
    `define DmwMatLocation 5:4
    `define DmwPsegLocation 27:25
    `define DmwVsegLocation 31:29
//TID
    `define TidTidLocation 31:0
//Tcfg
    `define TcfgEnLocation 0
    `define TcfgPeriodicLocation 1
    `define TcfgInitValLocation 31:2`//和n有关
//Tval
    `define TvalTimeValLocation 31:0//和n有关
//Ticlr
    `define TiclrClrLocation 0
`endif /* !DEFINECSR_H */
/*
`CrmdRegAddr      
`PrmdRegAddr      
`EuenRegAddr      
`ECfgRegAddr      
`EStatRegAddr     
`                 
`ERARegAddr       
`BAdVRegAddr      
`EentryRegAddr    
`                 
`TlbIdxRegAddr    
`TlbEhiRegAddr    
`TlbElo0RegAddr   
`TlbElo1RegAddr   
`                 
`AsIdRegAddr      
`PgdLRegAddr      
`PgdHtRegAddr     
`PgdRegAddr       
`                 
`CpuIdRegAddr     
`                 
`Save0RegAddr     
`Save1RegAddr     
`Save2RegAddr     
`Save3RegAddr     
`                 
`TIdRegAddr       
`TCfgRegAddr      
`TValRegAddr      
`TiClrRegAddr     
`                 
`LlbCtlRegAddr    
`TlbRentryRegAddr 
`CTagRegAddr      
`DmW0RegAddr      
`DmW1RegAddr
*/      



























