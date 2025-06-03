#!/bin/bash

# 添加第三方软件源，防止依赖缺失
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default

# Easytier
git clone --depth 1 -b main https://github.com/EasyTier/luci-app-easytier.git package/package-easytier

# 更新所有 feeds
./scripts/feeds update -a

# 不删除 small 依赖的包，避免依赖缺失
# rm -rf feeds/luci/applications/luci-app-mosdns
# rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns}
# rm -rf feeds/packages/utils/v2dat

# 替换 golang 包为 kenzok8 的版本（支持 golang 1.22+）
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/kenzok8/golang feeds/packages/lang/golang

# 安装所有 feeds
./scripts/feeds install -a

# 去掉 gn 包的 -Werror，避免编译因警告失败
find feeds/packages/devel/gn -type f -exec sed -i 's/-Werror//g' {} +
