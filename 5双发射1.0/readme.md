# 

[toc]
##
本文件扩展到57指令

1. 目前已经实现了基础指令的大部分指令，
2. 还剩乘法除法取模指令和栅栈指令，cache预取指令。
3. 现在打算测试目前已经实现的指令
   必须学习gcc如何编写汇编程序

   4 .在实现握手，在测试已经实现的指令
4. 在实现乘除法。通过乘除法号实现
   
   ### 
   
   5、目前正在实现分支预测
   
   ### 
   当前实现了例外，结果看了教学视频发现自己前面的csr读写设计是有问题的，csr的读写应该在同一个阶段，因为csr寄存器和regs寄存器不一样，csr会被硬件修改，所以forward对它没有用处，所以下一期打算对csr访问进行重构
   ## 
  目前已经实现,同时重构实现了csr的读写全部设置在wb阶段，实现了中断了，测试到了tlb了 
   ## 
当前版本在单发射的模式下可以通过58个测试点，双发射模式icache的命中率几乎为0,没有加速效果
