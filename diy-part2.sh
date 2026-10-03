#!/bin/bash

# 1. 强制替换旧版且有冲突的 Golang 语言环境（daed 编译必须）
#rm -rf feeds/packages/lang/golang

# 2. 强行拉取官方维护、能完美支持最新 dae/daed 编译的最新稳定版 Go 环境
git clone https://github.com/golang/go -b 23 feeds/packages/lang/golang

# 3. 强行拉取最新稳定版且不会与系统 API 冲突的 dae 核心定义（如果 daede feed 还是出错）
# 如果不需要也可以不加，但以下是保障底层网络容器依赖和 bpf 支持
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> .config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> .config
echo "CONFIG_PACKAGE_libbpf=y" >> .config

#sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate



