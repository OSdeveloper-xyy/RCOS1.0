**RCOS1.0操作系统简介**
---
# 开发者
系与言
# 协作者
LeafNeko
# 项目介绍
这是我开发的第一个操作系统，名为RCOS1.0，架构有 _IA32_ 和 _LoongArch_。_X86_ 启动方式打算采取 _BIOS/UEFI_ 双启动,_LoongArch_ 用 _UEFI_。整个操作系统基本使用 _asm_ 实现。
# 项目进程
正在开发，约7~14天更新仓库
## 目前项目流程
红色代表正在进行/修改的项目，绿色代表已完成项目,蓝色代表暂缓
```mermaid
graph LR
J[X86-IA32]
A[引导层] --> B[BIOS/实模式]
A --> C[UEFI/保护模式]
B --> D[ASM引导扇区设置GDT,进入保护模式]
C --> E[EDK2固件]
E --> I[内核]
D --> I 
style E fill:#F00,stroke:#000;
style C fill:#F00,stroke:#000;
style I fill:#0F0,stroke:#000;
style B fill:#0F0,stroke:#000;
style D fill:#0F0,stroke:#000;
K[LoongArch]
```
# 希望
大家可以能为我指出问题，联系方式见下
## 联系方式
Email: anan3055@163.com
