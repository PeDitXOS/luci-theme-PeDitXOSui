#!/bin/bash
# Direct IPK/APK builder - no SDK, no ar, no compilation needed.
# PeDitXOSui is a LuCI theme (static files only).

set -e

THEME_NAME="peditxosui"
THEME_TITLE="PeDitXOSui"
PKG_NAME="luci-theme-${THEME_NAME}"
PKG_VERSION="1.3.7"
PKG_RELEASE="01"
WORK_DIR="$(pwd)"

echo "=== Building ${PKG_NAME} ${PKG_VERSION}-${PKG_RELEASE} ==="

# Clean previous builds
rm -rf build-ipk build-apk artifacts-ipk artifacts-apk

###############################################################################
# Helper: create package directory structure
###############################################################################
build_file_tree() {
    local DEST="$1"
    mkdir -p "${DEST}/etc/config"
    mkdir -p "${DEST}/etc/uci-defaults"
    mkdir -p "${DEST}/www/luci-static/${THEME_NAME}"
    mkdir -p "${DEST}/www/luci-static/resources"
    mkdir -p "${DEST}/usr/lib/lua/luci/view/themes/${THEME_NAME}"
    mkdir -p "${DEST}/usr/lib/lua/luci/view/${THEME_NAME}"
    mkdir -p "${DEST}/usr/lib/lua/luci/controller"

    [ -d "htdocs/luci-static/${THEME_NAME}" ] && cp -a htdocs/luci-static/${THEME_NAME}/* "${DEST}/www/luci-static/${THEME_NAME}/"
    [ -d "htdocs/luci-static/resources" ] && cp -a htdocs/luci-static/resources/* "${DEST}/www/luci-static/resources/"
    [ -d "luasrc/view/themes/${THEME_NAME}" ] && cp -a luasrc/view/themes/${THEME_NAME}/* "${DEST}/usr/lib/lua/luci/view/themes/${THEME_NAME}/"
    [ -d "luasrc/view/${THEME_NAME}" ] && cp -a luasrc/view/${THEME_NAME}/* "${DEST}/usr/lib/lua/luci/view/${THEME_NAME}/"
    [ -d "luasrc/controller" ] && cp -a luasrc/controller/*.lua "${DEST}/usr/lib/lua/luci/controller/"
    [ -f "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" ] && cp -a "root/etc/uci-defaults/30-luci-theme-${THEME_NAME}" "${DEST}/etc/uci-defaults/"
    [ -f "root/etc/config/${THEME_NAME}" ] && cp -a "root/etc/config/${THEME_NAME}" "${DEST}/etc/config/"

    # Remove any empty directories
    find "${DEST}" -type d -empty -delete 2>/dev/null || true
}

###############################################################################
# 1. Build IPK (OpenWrt 23.05+)
###############################################################################
echo "--- Building IPK ---"
IPK_PKG="${WORK_DIR}/build-ipk/${PKG_NAME}"
build_file_tree "${IPK_PKG}"

FILE_COUNT=$(find "${IPK_PKG}" -type f | wc -l | tr -d ' ')
INSTALLED_SIZE=$(du -s "${IPK_PKG}" | awk '{print $1}')
echo "  Files: ${FILE_COUNT}, Size: ${INSTALLED_SIZE}KB"

# CONTROL directory
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
Installed-Size: ${INSTALLED_SIZE}
Maintainer: PeDitX <t.me/peditx>
URL: https://github.com/PeDitXOS/luci-theme-PeDitXOSui
Description: LuCI Theme For OpenWrt - PeDitXOSui
 Modern HTML5 dashboard UI with dark/light mode, glassmorphism design,
 WiFi & LAN device detection, static DHCP lease, and responsive layout.
EOF

# postinst: register theme in LuCI
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

# postrm: unregister theme
cat > "${IPK_PKG}/CONTROL/postrm" << 'POSTRM'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    uci -q delete luci.themes.PeDitXOSui
    uci commit luci
}
exit 0
POSTRM
chmod 0755 "${IPK_PKG}/CONTROL/postrm"

# conffiles
cat > "${IPK_PKG}/CONTROL/conffiles" << EOF
/etc/config/${THEME_NAME}
/etc/uci-defaults/30-luci-theme-${THEME_NAME}
EOF

# Build IPK as gzipped tarballs (opkg format = data.tar.gz + control.tar.gz + debian-binary)
mkdir -p "${WORK_DIR}/build-ipk/tmp"

# data.tar.gz (everything except CONTROL)
tar -C "${IPK_PKG}" --exclude='./CONTROL' -czf "${WORK_DIR}/build-ipk/tmp/data.tar.gz" .

# control.tar.gz
tar -C "${IPK_PKG}/CONTROL" -czf "${WORK_DIR}/build-ipk/tmp/control.tar.gz" .

# debian-binary
echo "2.0" > "${WORK_DIR}/build-ipk/tmp/debian-binary"

# IPK = gzipped tar containing these three files
IPK_FILE="${WORK_DIR}/artifacts-ipk/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.ipk"
mkdir -p "${WORK_DIR}/artifacts-ipk"
tar -C "${WORK_DIR}/build-ipk/tmp" -czf "${IPK_FILE}" debian-binary control.tar.gz data.tar.gz

echo "  IPK: ${IPK_FILE}"
echo "  Size: $(du -h "${IPK_FILE}" | awk '{print $1}')"

###############################################################################
# 2. Build APK (OpenWrt 25.12+)
###############################################################################
echo "--- Building APK ---"
APK_PKG="${WORK_DIR}/build-apk/${PKG_NAME}"
build_file_tree "${APK_PKG}"

APK_FILE="${WORK_DIR}/artifacts-apk/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.apk"
mkdir -p "${WORK_DIR}/artifacts-apk"

if command -v zstd &>/dev/null; then
    tar -C "${APK_PKG}" -cf - . | zstd -o "${APK_FILE}"
    echo "  APK (zstd): ${APK_FILE}"
else
    APK_FILE="${APK_FILE}.tar.gz"
    tar -C "${APK_PKG}" -czf "${APK_FILE}" .
    echo "  APK (tar.gz): ${APK_FILE}"
fi
echo "  Size: $(du -h "${APK_FILE}" | awk '{print $1}')"

echo ""
echo "=== Build Complete ==="
echo ""
ls -lh "${WORK_DIR}/artifacts-ipk/" "${WORK_DIR}/artifacts-apk/"
echo ""
echo "Install on OpenWrt:"
echo "  opkg install ${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_all.ipk"
