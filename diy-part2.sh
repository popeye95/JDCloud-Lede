#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

#echo "-----------------Modify default IP"
#sed -i 's/192.168.1.1/192.168.68.1/g' package/base-files/files/bin/config_generate
#grep  192 -n3 package/base-files/files/bin/config_generate

echo '-----------------修改时区为东八区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate


echo '-----------------修改主机名为 Luban'
sed -i 's/OpenWrt/jDcloud-re-sp01b/g' package/base-files/files/bin/config_generate

#grep timezone -n5 package/base-files/files/bin/config_generate

# 更换腾讯源

#echo "src/gz openwrt_core http://mirrors.cloud.tencent.com/lede/releases/22.03.3/targets/ramips/mt7621/packages" >> package/system/opkg/files/customfeeds.conf
#echo "src/gz openwrt_base http://mirrors.cloud.tencent.com/lede/releases/22.03.3/packages/mipsel_24kc/base" >> package/system/opkg/files/customfeeds.conf
#echo "src/gz openwrt_luci http://mirrors.cloud.tencent.com/lede/releases/22.03.3/packages/mipsel_24kc/luci" >> package/system/opkg/files/customfeeds.conf
#echo "src/gz openwrt_packages http://mirrors.cloud.tencent.com/lede/releases/22.03.3/packages/mipsel_24kc/packages" >> package/system/opkg/files/customfeeds.conf
#echo "src/gz openwrt_routing http://mirrors.cloud.tencent.com/lede/releases/22.03.3/packages/mipsel_24kc/routing" >> package/system/opkg/files/customfeeds.conf
#echo "src/gz openwrt_telephony http://mirrors.cloud.tencent.com/lede/releases/22.03.3/packages/mipsel_24kc/telephony" >> package/system/opkg/files/customfeeds.conf

#echo "-----------------修改u-boot的ramips"
#sed -i 's/yuncore,ax820/jdcloud,luban/g' package/boot/uboot-envtools/files/ramips

#grep all5002 -n5 package/boot/uboot-envtools/files/ramips

#echo '-----------------载入 mt7621_jdcloud_luban.dts'
#curl --retry 3 -s --globoff "https://gist.githubusercontent.com/vki888/12f935f75833058dfd6df69cd16dde8c/raw/a49bc98f720f2a19b49e98da2ca289c015bbae26/openwrt-autocompile-luban.dts" -o target/linux/ramips/dts/mt7621_jdcloud_luban.dts
#cat target/linux/ramips/dts/mt7621_jdcloud_luban.dts

# fix2 + fix4.2
#echo '-----------------修补 mt7621.mk'
#grep adslr_g7 -n10 target/linux/ramips/image/mt7621.mk
#sed -i '/Device\/adslr_g7/i\define Device\/jdcloud_luban\n  \$(Device\/dsa-migration)\n  \$(Device\/uimage-lzma-loader)\n  IMAGE_SIZE := 15808k\n  DEVICE_VENDOR := JDCloud\n  DEVICE_MODEL := luban\n  DEVICE_PACKAGES := kmod-fs-ext4 kmod-mt7915-firmware kmod-mt7915e kmod-sdhci-mt7620 uboot-envtools kmod-mmc kmod-mtk-hnat kmod-mtd-rw wpad-openssl\nendef\nTARGET_DEVICES += jdcloud_luban\n\n' target/linux/ramips/image/mt7621.mk
#grep adslr_g7 -n10 target/linux/ramips/image/mt7621.mk

# fix3 + fix5.2
#echo '-----------------修补 02-network'
#sed -i '/xiaoyu,xy-c5/i\jdcloud,luban|\\' target/linux/ramips/mt7621/base-files/etc/board.d/02_network
#grep xiaoyu,xy-c5 -n3 target/linux/ramips/mt7621/base-files/etc/board.d/02_network


#echo '-----------------定义kernel MD5，与官网一致'
#echo '2974fbe1fa59be88f13eb8abeac8c10b' > ./.vermagic
#cat .vermagic

#sed -i 's/^\tgrep.*vermagic/\tcp -f \$(TOPDIR)\/\.vermagic \$(LINUX_DIR)\/\.vermagic/g' include/kernel-defaults.mk
#grep vermagic -n5 include/kernel-defaults.mk



# 删除自定义源默认的 argon 主题
rm -rf package/lean/luci-theme-argon
rm -rf   feeds/luci/themes/luci-theme-argon

# 部分第三方源自带 argon 主题，上面命令删除不掉的请运行下面命令
find ./ -name luci-theme-argon | xargs rm -rf

# 拉取 argon 源码
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

#其他第三方package
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
#git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest
#git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go

#取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 替换默认主题为 luci-theme-argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

#删除默认密码
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# Modify default IP
sed -i 's/192.168.1.1/192.168.68.1/g' package/base-files/files/bin/config_generate

