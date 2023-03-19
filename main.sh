
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
git clone --depth 1 https://github.com/AlexZhuo/luci-app-bandwidthd
git clone --depth 1 https://github.com/sirpdboy/netspeedtest && mvdir netspeedtest
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall
git clone --depth 1 -b luci-smartdns-new-version https://github.com/xiaorouji/openwrt-passwall passwall && mv -n passwall/luci-app-passwall ./;rm -rf passwall
git clone --depth 1 https://github.com/sirpdboy/luci-theme-opentopd
git clone --depth 1 https://github.com/esirplayground/luci-app-poweroff
git clone --depth 1 https://github.com/destan19/OpenAppFilter && mvdir OpenAppFilter
git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced
git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr
git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb
git clone --depth 1 https://github.com/QiuSimons/openwrt-mos && mv -n openwrt-mos/*mosdns ./ ; rm -rf openwrt-mos
git clone --depth 1 https://github.com/cyzzc/openwrt_nezha && mvdir openwrt_nezha

svn export https://github.com/immortalwrt/packages/trunk/net/smartdns
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
svn export https://github.com/fw876/helloworld/trunk/sagernet-core
svn export https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus
svn export https://github.com/fw876/helloworld/trunk/lua-neturl
svn export https://github.com/fw876/helloworld/trunk/redsocks2
svn export https://github.com/fw876/helloworld/trunk/microsocks

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

bash diy/create_acl_for_luci.sh -a >/dev/null 2>&1
bash diy/convert_translation.sh -a >/dev/null 2>&1

rm -rf create_acl_for_luci.err & rm -rf create_acl_for_luci.ok
rm -rf create_acl_for_luci.warn

exit 0
