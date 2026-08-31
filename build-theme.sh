#!/bin/bash
# Direct IPK/APK builder - no SDK compile needed
# PeDitXOSui is a LuCI theme (static files only), no compilation required.

set -e

THEME_NAME="peditxosui"
THEME_TITLE="PeDitXOSui"
PKG_NAME="luci-theme-${THEME_NAME}"
PKG_VERSION="1.0.0"
PKG_RELEASE="01"
WORK_DIR="$(pwd)"

echo "=== Building ${PKG_NAME} ${PKG_VERSION}-${PKG_RELEASE} ==="

# Clean previous builds
rm -rf build-ipk build-apk

###############################################################################
# 1. Build IPK (OpenWrt 23.05+)
###############################################################################
echo "--- Building IPK ---"
IPK_DIR="${WORK_DIR}/build-ipk"
IPK_PKG="${IPK_DIR}/${PKG_NAME}"

# Package structure
mkdir -p "${IPK_PKG}/etc/config"
mkdir -p "${IPK_PKG}/etc/uci-defaults"
mkdir -p "${IPK_PKG}/www/luci-static/${THEME_NAME}"
mkdir -p "${IPK_PKG}/www/luci-static/resources"
mkdir -p "${IPK_PKG}/usr/lib/lua/luci/view/themes/${THEME_NAME}"
mkdir -p "${IPK_PKG}/usr/lib/lua/luci/view/${THEME_NAME}"
mkdir -p "${IPK_PKG}/usr/lib/lua/luci/controller"

# Copy theme files
[ -d "htdocs/luci-static/${THEME_NAME}" ] && cp -a htdocs/luci-static/${THEME_NAME}/* "${IPK_PKG}/www/luci-static/${THEME_NAME}/"
[ -d "htdocs/luci-static/resources" ] && cp -a htdocs/luci-static/resources/* "${IPK_PKG}/www/luci-static/resources/"
[ -d "luasrc/view/themes/${THEME_NAME}" ] && cp -a luasrc/view/themes/${THEME_NAME}/* "${IPK_PKG}/usr/lib/lua/luci/view/themes/${THEME_NAME}/"
[ -d "luasrc/view/${THEME_NAME}" ] && cp -a luasrc/view/${THEME_NAME}/* "${IPK_PKG}/usr/lib/lua/luci/view/${THEME_NAME}/"
[ -d "luasrc/controller" ] && cp -a luasrc/controller/*.lua "${IPK_PKG}/usr/lib/lua/luci/controller/"
[ -f "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" ] && cp -a "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" "${IPK_PKG}/etc/uci-defaults/"
[ -f "root/etc/config/${THEME_NAME}" ] && cp -a "root/etc/config/${THEME_NAME}" "${IPK_PKG}/etc/config/"

# Count installed files
FILE_COUNT=$(find "${IPK_PKG}" -type f | wc -l | tr -d ' ')
echo "  Files to install: ${FILE_COUNT}"

# Create control file (IPK uses Ar control format)
mkdir -p "${IPK_PKG}/CONTROL"
cat > "${IPK_PKG}/CONTROL/control" << EOF
Package: ${PKG_NAME}
Version: ${PKG_VERSION}-${PKG_RELEASE}
Depends: luci-base
Source: https://github.com/PeDitXOS/luci-theme-PeDitXOSui
License: Apache-2.0
LicenseFiles: LICENSE
Section: luci
Architecture: all
Installed-Size: $(du -s "${IPK_PKG}" | awk '{print $1}')
Maintainer: PeDitX <t.me/peditx>
URL: https://github.com/PeDitXOS/luci-theme-PeDitXOSui
Description: LuCI Theme For OpenWrt - PeDitXOSui
 Modern HTML5 dashboard UI with dark/light mode, glassmorphism design,
 WiFi & LAN device detection, static DHCP lease, and responsive layout.
EOF

# Create postinst script
cat > "${IPK_PKG}/CONTROL/postinst" << 'POSTINST'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    uci -q batch << UCI
set luci.themes.PeDitXOSui=/luci-static/peditxosui
set luci.main.mediaurlbase=/luci-static/peditxosui
commit luci
UCI
}
exit 0
POSTINST
chmod 0755 "${IPK_PKG}/CONTROL/postinst"

# Create postrm script
cat > "${IPK_PKG}/CONTROL/postrm" << 'POSTRM'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    uci -q delete luci.themes.PeDitXOSui
    uci commit luci
}
exit 0
POSTRM
chmod 0755 "${IPK_PKG}/CONTROL/postrm"

# Create conffiles
cat > "${IPK_PKG}/CONTROL/conffiles" << EOF
/etc/config/${THEME_NAME}
/etc/uci-defaults/30-luci-theme-${THEME_NAME}
EOF

# Build IPK tar.gz
mkdir -p "${IPK_DIR}/tmp"
(cd "${IPK_PKG}" && tar czf "${IPK_DIR}/tmp/data.tar.gz" --exclude='./CONTROL' --exclude='.' .)
(cd "${IPK_PKG}/CONTROL" && tar czf "${IPK_DIR}/tmp/control.tar.gz" .)

# Create package version file
echo "2.0" > "${IPK_DIR}/tmp/debian-binary"

# Create IPK (ar archive)
IPK_FILE="${IPK_DIR}/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.ipk"
(cd "${IPK_DIR}/tmp" && ar rc "${IPK_FILE}" debian-binary control.tar.gz data.tar.gz)

# Copy IPK to artifacts
mkdir -p artifacts-ipk
cp "${IPK_FILE}" artifacts-ipk/

echo "  IPK: ${IPK_FILE}"
echo "  Size: $(du -h "${IPK_FILE}" | cut -f1)"

###############################################################################
# 2. Build APK (OpenWrt 25.12+)
###############################################################################
echo "--- Building APK ---"
APK_DIR="${WORK_DIR}/build-apk"
APK_PKG="${APK_DIR}/${PKG_NAME}"

# APK uses same structure
mkdir -p "${APK_PKG}/etc/config"
mkdir -p "${APK_PKG}/etc/uci-defaults"
mkdir -p "${APK_PKG}/www/luci-static/${THEME_NAME}"
mkdir -p "${APK_PKG}/www/luci-static/resources"
mkdir -p "${APK_PKG}/usr/lib/lua/luci/view/themes/${THEME_NAME}"
mkdir -p "${APK_PKG}/usr/lib/lua/luci/view/${THEME_NAME}"
mkdir -p "${APK_PKG}/usr/lib/lua/luci/controller"

# Copy theme files
[ -d "htdocs/luci-static/${THEME_NAME}" ] && cp -a htdocs/luci-static/${THEME_NAME}/* "${APK_PKG}/www/luci-static/${THEME_NAME}/"
[ -d "htdocs/luci-static/resources" ] && cp -a htdocs/luci-static/resources/* "${APK_PKG}/www/luci-static/resources/"
[ -d "luasrc/view/themes/${THEME_NAME}" ] && cp -a luasrc/view/themes/${THEME_NAME}/* "${APK_PKG}/usr/lib/lua/luci/view/themes/${THEME_NAME}/"
[ -d "luasrc/view/${THEME_NAME}" ] && cp -a luasrc/view/${THEME_NAME}/* "${APK_PKG}/usr/lib/lua/luci/view/${THEME_NAME}/"
[ -d "luasrc/controller" ] && cp -a luasrc/controller/*.lua "${APK_PKG}/usr/lib/lua/luci/controller/"
[ -f "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" ] && cp -a "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" "${APK_PKG}/etc/uci-defaults/"
[ -f "root/etc/config/${THEME_NAME}" ] && cp -a "root/etc/config/${THEME_NAME}" "${APK_PKG}/etc/config/"

# Create APK manifest
mkdir -p "${APK_DIR}/tmp"
cat > "${APK_DIR}/tmp/APKBUILD" << EOF
pkgname=${PKG_NAME}
pkgver=${PKG_VERSION}
pkgrel=${PKG_RELEASE}
pkgdesc="LuCI Theme For OpenWrt - PeDitXOSui"
url="https://github.com/PeDitXOS/luci-theme-PeDitXOSui"
arch="all"
license="Apache-2.0"
depends="luci-base"
source=""
builddir="${APK_PKG}"

package() {
    cp -a "\${builddir}/"* "\${pkgdir}/"
}
EOF

# Build APK (tar.zst format for OpenWrt 25.12)
APK_FILE="${APK_DIR}/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.apk"

if command -v zstd &>/dev/null; then
    # Create APK as tar.zst (OpenWrt APK format)
    (cd "${APK_PKG}" && tar cf - . | zstd -o "${APK_FILE}")
    mkdir -p artifacts-apk
    cp "${APK_FILE}" artifacts-apk/
    echo "  APK: ${APK_FILE}"
    echo "  Size: $(du -h "${APK_FILE}" | cut -f1)"
else
    # Fallback: create as .tar.gz
    APK_FILE="${APK_DIR}/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.apk.tar.gz"
    (cd "${APK_PKG}" && tar czf "${APK_FILE}" .)
    mkdir -p artifacts-apk
    cp "${APK_FILE}" artifacts-apk/
    echo "  APK (tar.gz fallback): ${APK_FILE}"
    echo "  Size: $(du -h "${APK_FILE}" | cut -f1)"
fi

echo ""
echo "=== Build Complete ==="
echo "  IPK: artifacts-ipk/"
echo "  APK: artifacts-apk/"
echo ""
echo "Install on OpenWrt:"
echo "  IPK: opkg install luci-theme-${THEME_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.ipk"
echo "  APK: apk add ${APK_FILE}"
