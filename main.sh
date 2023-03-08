
#!/bin/bash
function git_clone() {
  git clone --depth 1 $1 $2 || true
 }
function git_sparse_clone() {
  branch="$1" rurl="$2" localdir="$3" && shift 3
  git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
  cd $localdir
  git sparse-checkout init --cone
  git sparse-checkout set $@
  mv -n $@ ../
  cd ..
  rm -rf $localdir
  }
function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}
git clone --depth 1 https://github.com/sirpdboy/luci-theme-opentopd
git clone --depth 1 https://github.com/esirplayground/luci-app-poweroff
git clone --depth 1 https://github.com/destan19/OpenAppFilter && mvdir OpenAppFilter
git clone --depth 1 https://github.com/AlexZhuo/luci-app-bandwidthd.git
# git clone --depth 1 https://github.com/QiuSimons/openwrt-mos && mv -n openwrt-mos/*mosdns ./ ; rm -rf openwrt-mos
git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced
git clone --depth 1 https://github.com/sirpdboy/netspeedtest speedtest && mv -f speedtest/*/ ./ && rm -rf speedtest
git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr
git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb

svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
svn export https://github.com/fw876/helloworld/trunk/sagernet-core
svn export https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus
svn export https://github.com/fw876/helloworld/trunk/lua-neturl
svn export https://github.com/fw876/helloworld/trunk/redsocks2
svn export https://github.com/fw876/helloworld/trunk/microsocks
svn export https://github.com/fw876/helloworld/trunk/lua-neturl
svn export https://github.com/immortalwrt/packages/trunk/net/smartdns

git_sparse_clone master "https://github.com/coolsnowwolf/packages" "leanpack" net/miniupnpd net/mwan3 multimedia/UnblockNeteaseMusic-Go \
multimedia/UnblockNeteaseMusic net/amule net/baidupcs-web multimedia/gmediarender net/go-aliyundrive-webdav \
net/qBittorrent-static net/qBittorrent libs/qtbase libs/qttools libs/rblibtorrent \
net/uugamebooster net/verysync net/dnsforwarder net/nps net/microsocks net/tcpping net/redsocks2

git_sparse_clone master "https://github.com/immortalwrt/packages" "immpack" net/sub-web \
net/smartdns net/dnsproxy net/haproxy net/v2raya net/cdnspeedtest \
net/subconverter net/ngrokc net/oscam net/njitclient net/scutclient net/gost net/gowebdav \
admin/bpytop libs/jpcre2 libs/wxbase libs/rapidjson libs/libcron libs/quickjspp libs/toml11 \
utils/cpulimit utils/filebrowser

git_sparse_clone develop "https://github.com/Ysurac/openmptcprouter-feeds" "enmptcp" luci-app-snmpd \
luci-app-packet-capture luci-app-mail msmtp
git_sparse_clone master "https://github.com/x-wrt/com.x-wrt" "x-wrt" natflow lua-ipops luci-app-macvlan

git_sparse_clone openwrt-21.02 "https://github.com/openwrt/openwrt" "21openwrt" package/libs/mbedtls \
git_sparse_clone openwrt-21.02 "https://github.com/openwrt/packages" "21packages" \
net/openvpn utils/cgroupfs-mount utils/coremark net/xray-core net/nginx net/uwsgi net/ddns-scripts admin/netdata
git_sparse_clone openwrt-21.02 "https://github.com/openwrt/openwrt" "21openwrt" package/libs/mbedtls \

mv -n openwrt-passwall/* ./ ; rm -Rf openwrt-passwall
mv -n openwrt-package/* ./ ; rm -Rf openwrt-package

rm -rf ./*/.git & rm -f ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?2. Clash For OpenWRT?3. Applications?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
-e 's/ca-certificates/ca-bundle/' \
*/Makefile

sed -i 's/luci-lib-ipkg/luci-base/g' luci-app-store/Makefile
sed -i "/minisign:minisign/d" luci-app-dnscrypt-proxy2/Makefile
sed -i 's/+dockerd/+dockerd +cgroupfs-mount/' luci-app-docker*/Makefile
sed -i '$i /etc/init.d/dockerd restart &' luci-app-docker*/root/etc/uci-defaults/*
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile
sed -i 's/\(+luci-compat\)/\1 +luci-theme-argon/' luci-app-argon-config/Makefile
sed -i 's/\(+luci-compat\)/\1 +luci-theme-argonne/' luci-app-argonne-config/Makefile
sed -i 's/ +uhttpd-mod-ubus//' luci-app-packet-capture/Makefile
sed -i 's/	ip.neighbors/	luci.ip.neighbors/' luci-app-wifidog/luasrc/model/cbi/wifidog/wifidog_cfg.lua
sed -i "s/nas/services/g" `grep nas -rl luci-app-fileassistant`
sed -i "s/NAS/Services/g" `grep NAS -rl luci-app-fileassistant`
find -type f -name Makefile -exec sed -ri  's#mosdns[-_]neo#mosdns#g' {} \;

bash diy/create_acl_for_luci.sh -a >/dev/null 2>&1
bash diy/convert_translation.sh -a >/dev/null 2>&1

rm -rf create_acl_for_luci.err & rm -rf create_acl_for_luci.ok
rm -rf create_acl_for_luci.warn

exit 0
