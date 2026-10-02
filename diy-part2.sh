#!/bin/bash

# 1. 移除 fanchmwrt 源码可能自带的、与独立 feeds 冲突的旧版 dae/daed 组件
rm -rf package/feeds/daed_repo/dae
rm -rf package/feeds/daed_repo/daed
rm -rf package/feeds/daed_repo/luci-app-daed

# 1. 强行在内核中塞入 eBPF 及相关标准网络容器依赖（daed 核心驱动依赖）
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> .config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> .config
echo "CONFIG_PACKAGE_libbpf=y" >> .config

#sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate
