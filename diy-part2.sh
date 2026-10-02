#!/bin/bash

# 1. 强制注入 daed 所需的底层内核 eBPF 模块支持（防止底层依赖缺失报错 2）
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> .config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> .config

# 2. 修复可能由于 Golang 或 luci-app-store 与原生系统的依赖冲突
# 强制移除可能导致在 toplevel.mk 阶段发生严重锁死冲突的旧包描述文件
rm -rf feeds/packages/lang/golang
git clone https://github.com feeds/packages/lang/golang
#sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate
