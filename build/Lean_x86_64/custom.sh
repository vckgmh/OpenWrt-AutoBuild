#!/bin/bash

# passwall
sed -i '$a src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall;packages' feeds.conf.default
sed -i '$a src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall;luci' feeds.conf.default

# luci-theme-infinityfreedom
# sed -i '$a src-git infinityfreedom https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git' feeds.conf.default

# 针对 LEDE 项目拉取 argon 主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/vckgmh-packages/luci-theme-argon

# luci-app-argon-config 插件
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/vckgmh-packages/luci-app-argon-config

# infinityfreedom 主题
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/vckgmh-packages/luci-theme-infinityfreedom

# neobird 主题
# git clone https://github.com/thinktip/luci-theme-neobird.git package/vckgmh-packages/luci-theme-neobird

cat feeds.conf.default

# 更新并安装源
# ./scripts/feeds clean
./scripts/feeds update -a
# ./scripts/feeds install -a -f
./scripts/feeds install -a

# 移除lede源码自带的argon主题
rm -rf feeds/luci/themes/luci-theme-argon

# 自定义定制选项
NET="package/base-files/files/bin/config_generate"
ZZZ="package/lean/default-settings/files/zzz-default-settings"
#
sed -i 's#192.168.1.1#192.168.5.1#g' $NET                                                    # 定制默认IP
# sed -i 's#OpenWrt#OpenWrt-X86#g' $NET                                                     # 修改默认名称为OpenWrt-X86
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' $ZZZ                                             # 取消系统默认密码
sed -i "s/OpenWrt /build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ              # 增加自己个性名称
sed -i 's#localtime  = os.date()#localtime  = os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")#g' package/lean/autocore/files/*/index.htm               # 修改默认时间格式

#创建自定义配置文件

cd $WORKPATH
touch ./.config

cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y

# 生成支持传统启动的固件
CONFIG_GRUB_IMAGES=y

# 生成支持UEFI启动的固件
CONFIG_GRUB_EFI_IMAGES=y

# 固件大小
CONFIG_TARGET_KERNEL_PARTSIZE=30
CONFIG_TARGET_ROOTFS_PARTSIZE=300

# 固件压缩
# CONFIG_TARGET_IMAGES_GZIP is not set

# LiveCD镜像
CONFIG_ISO_IMAGES=y

# PVE/KVM 镜像
CONFIG_QCOW2_IMAGES=y

# VirtualBox 镜像
CONFIG_VDI_IMAGES=y

# VMware 镜像
CONFIG_VMDK_IMAGES=y

# Hyper-V 镜像
CONFIG_VHDX_IMAGES=y

# 去掉默认选中的插件开始
# 访问时间控制
# CONFIG_PACKAGE_luci-app-accesscontrol is not set

# 广告屏蔽大师Plus +
# CONFIG_PACKAGE_luci-app-adbyby-plus is not set

# IP/MAC绑定
# CONFIG_PACKAGE_luci-app-arpbind is not set

#支持计划重启
# CONFIG_PACKAGE_luci-app-autoreboot is not set

# 动态域名 DNS
# CONFIG_PACKAGE_luci-app-ddns is not set

# 新型的写时复制 (COW)
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs is not set
# 用于列出所有可用块设备的信息
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk is not set

# 文件传输（可web安装ipk包）
# CONFIG_PACKAGE_luci-app-filetransfer is not set

# VPN服务器 IPSec
# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set

# 网络带宽监视器
# CONFIG_PACKAGE_luci-app-nlbwmon is not set

# 命令行云端同步工具
# Rclone界面
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-ng is not set
# Rclone另一个界面
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-webui is not set

# 网页终端命令行
# CONFIG_PACKAGE_luci-app-ttyd is not set

# Turbo ACC 网络加速(支持 Fast Path 或者 硬件 NAT)
# CONFIG_PACKAGE_luci-app-turboacc is not set
# BBR拥塞控制算法提升TCP网络性能
# CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_BBR_CCA is not set
# Shortcut-FE 流量分载
# CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE_CM is not set

# 解锁网易云灰色歌曲3合1新版本
# CONFIG_PACKAGE_luci-app-unblockmusic is not set
# Golang版本
# CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_Go is not set

# 通用即插即用UPnP（端口自动转发）
# CONFIG_PACKAGE_luci-app-upnp is not set

# KMS服务器设置
# CONFIG_PACKAGE_luci-app-vlmcsd is not set

# FTP服务器
# CONFIG_PACKAGE_luci-app-vsftpd is not set

# VPN服务器 WireGuard状态
# CONFIG_PACKAGE_luci-app-wireguard is not set

# WOL网络唤醒
# CONFIG_PACKAGE_luci-app-wol is not set

# 迅雷快鸟
# CONFIG_PACKAGE_luci-app-xlnetacc is not set

# ZeroTier内网穿透
# CONFIG_PACKAGE_luci-app-zerotier is not set

# 去掉samba (网络共享)
# CONFIG_PACKAGE_autosamba is not set

# 去掉默认选中的插件结束

# ipv6支持
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y

# 主题
# CONFIG_PACKAGE_luci-theme-material is not set
# CONFIG_PACKAGE_luci-theme-netgear is not set

# 第三方主题
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-theme-infinityfreedom=y

# passwall
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_GO=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y

#
#
# 自带插件
#
#

# IP/MAC绑定
CONFIG_PACKAGE_luci-app-arpbind=y

#支持计划重启
CONFIG_PACKAGE_luci-app-autoreboot=y

#磁盘管理
CONFIG_PACKAGE_luci-app-diskman=y
# 新型的写时复制 (COW)
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
# 用于列出所有可用块设备的信息
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_mdadm=y

# 文件传输（可web安装ipk包）
CONFIG_PACKAGE_luci-app-filetransfer=y

# 内网穿透Frp客户端
CONFIG_PACKAGE_luci-app-frpc=y

# 网页终端命令行
CONFIG_PACKAGE_luci-app-ttyd=y

# Turbo ACC 网络加速(支持 Fast Path 或者 硬件 NAT)
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_BBR_CCA=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_DNSFORWARDER=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_DNSPROXY=y

# 通用即插即用UPnP（端口自动转发）
CONFIG_PACKAGE_luci-app-upnp=y

# KMS服务器设置
CONFIG_PACKAGE_luci-app-vlmcsd=y

# WOL网络唤醒
CONFIG_PACKAGE_luci-app-wol=y

# vim编辑器
CONFIG_PACKAGE_vim-full=y

CONFIG_PACKAGE_openssh-sftp-server=y

# 第三方插件
CONFIG_PACKAGE_luci-app-argon-config=y

# uHTTPd Web服务器
CONFIG_PACKAGE_luci-app-uhttpd=y

# Docker容器
CONFIG_PACKAGE_luci-app-dockerman=y

# kodexplorer可道云
CONFIG_PACKAGE_luci-app-kodexplorer=y

# 阿里云盘webdav
CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y

EOF

sed -i 's/^[ \t]*//g' ./.config

# 返回目录
cd $HOME