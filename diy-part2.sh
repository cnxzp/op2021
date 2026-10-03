#!/bin/bash

# 1. 强行在内核中塞入 eBPF 及相关标准网络容器依赖（daed 运行必须）
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> .config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> .config
echo "CONFIG_PACKAGE_libbpf=y" >> .config

# 2. 彻底粉碎固件源码自带的 smpackage/dae 冲突目录
rm -rf package/feeds/smpackage/dae
rm -rf package/feeds/smpackage/daed
rm -rf package/feeds/smpackage/luci-app-daed
rm -rf feeds/smpackage/dae
rm -rf feeds/smpackage/daed
rm -rf feeds/smpackage/luci-app-daed

# 3. 建立一个全新的、干净的 dae 打包目录，直接强行接管
mkdir -p package/dae/files
cd package/dae/files

# 下载官方为 arm64 (aarch64) 架构预编译好的稳定版 dae 核心
curl -L -o dae https://github.com/daeuniverse/dae/releases/download/nightly/dae-linux-arm64.deb
chmod +x dae

cd /workdir/openwrt

# 重新生成绝对不会报错的本地免编译 Makefile
cat > package/dae/Makefile << 'EOF'
include $(TOPDIR)/rules.mk

PKG_NAME:=dae
PKG_VERSION:=2026.09.24
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/dae
  SECTION:=net
  CATEGORY:=Network
  TITLE:=dae core (Prebuilt for aarch64)
  DEPENDS:=+libbpf +kmod-tun +ip-full
enddefine

define Build/Compile
	# 空步骤，直接跳过源码编译
enddefine

define Package/dae/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/dae $(1)/usr/bin/dae
enddefine

$(eval $(call BuildPackage,dae))
EOF

#sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate



