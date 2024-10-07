/*
 * defineSignLocation.h
 * Copyright (C) 2023 zzq <zzq@zzq-HP-Pavilion-Gaming-Laptop-15-cx0xxx>
 *
 * Distributed under terms of the MIT license.
 */
`include "DefineLoogLenWidth.h"

`ifndef DEFINESIGNLOCATION_H
    `define DEFINESIGNLOCATION_H
    //例外信号
    `define EXCEP_SIGN_USE_LEN 2
    `define EXCEP_SIGN_BEGIN_POINT  `BJSignLen+`WbSignLen+`MemSignLen+`ExSignLen +`IdSignLen//8+4+8+4=24
    `define EXCEP_SIGN_LOCATION `EXCEP_SIGN_BEGIN_POINT+`EXCEP_SIGN_USE_LEN+`EXCEP_SIGN_BEGIN_POINT
    //译码阶段信号
    `define ID_SIGN_USE_LEN 12 //4
    `define ID_SIGN_BEGIN_PIONT `BJSignLen+`WbSignLen+`MemSignLen+`ExSignLen//8+4+8+4=24
    `define ID_SIGN_LOCATION  `ID_SIGN_BEGIN_PIONT+`ID_SIGN_USE_LEN : `ID_SIGN_BEGIN_PIONT
    //执行阶段信号
    `define EXE_SIGN_USE_LEN 2 //1
    `define EXE_SIGN_BEGIN_PIONT `BJSignLen+`WbSignLen+`MemSignLen//8+4+8=20
    `define EXE_SIGN_LOCATION `EXE_SIGN_BEGIN_PIONT+`EXE_SIGN_USE_LEN : `EXE_SIGN_BEGIN_PIONT
    
    //访存阶段信号·
    `define MEM_SIGN_USE_LEN  5 //2
    `define MEM_SIGN_BEGIN_PIONT `BJSignLen+`WbSignLen//8+4=12
    `define MEM_SIGN_LOCATION `MEM_SIGN_BEGIN_PIONT+`MEM_SIGN_USE_LEN : `MEM_SIGN_BEGIN_PIONT
    
    //写会阶段信号·
    `define WB_SIGN_USE_LEN  2 //1
    `define WB_SIGN_BEGIN_PIONT `BJSignLen//8
    `define WB_SIGN_LOCATION  `WB_SIGN_BEGIN_PIONT+`WB_SIGN_USE_LEN : `WB_SIGN_BEGIN_PIONT
    
    //ID给IF阶段信号
    `define B_SIGN_USE_LEN  6 //2
    `define B_SIGN_BEGIN_PIONT 0 //
    `define B_SIGN_LOCATION `B_SIGN_BEGIN_PIONT+`B_SIGN_USE_LEN : `B_SIGN_BEGIN_PIONT
    //end 3+1+2+1+2=9 4*9=36
    
`endif /* !defineSIGNLOCATION_H */
