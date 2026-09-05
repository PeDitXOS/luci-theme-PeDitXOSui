# LuCI PeDitXOSui Theme
# Copyright 2025 PeDitX <t.me/peditx>
#
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

include $(TOPDIR)/rules.mk

THEME_NAME:=peditxosui
THEME_TITLE:=PeDitXOSui

PKG_NAME:=luci-theme-$(THEME_NAME)
PKG_VERSION:=1.1.0
PKG_RELEASE:=01

include $(INCLUDE_DIR)/package.mk

define Package/luci-theme-$(THEME_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=4. Themes
  DEPENDS:=+luci-base
  TITLE:=LuCI Theme For OpenWrt - $(THEME_TITLE)
  URL:=http://t.me/peditx
  PKGARCH:=all
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-theme-$(THEME_NAME)/install
	$(INSTALL_DIR) $(1)/www/luci-static/$(THEME_NAME)
	$(CP) -a ./htdocs/luci-static/$(THEME_NAME)/* $(1)/www/luci-static/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/themes/$(THEME_NAME)
	$(CP) -a ./luasrc/view/themes/$(THEME_NAME)/* $(1)/usr/lib/lua/luci/view/themes/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/$(THEME_NAME)
	$(CP) -a ./luasrc/view/$(THEME_NAME)/* $(1)/usr/lib/lua/luci/view/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) -a ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(CP) -a ./htdocs/luci-static/resources/* $(1)/www/luci-static/resources/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/30-luci-theme-$(THEME_NAME) $(1)/etc/uci-defaults/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) -a ./root/etc/config/$(THEME_NAME) $(1)/etc/config/ 2>/dev/null || true
endef

define Package/luci-theme-$(THEME_NAME)/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	uci -q delete luci.themes.$(THEME_TITLE)
	uci commit luci
}
exit 0
endef

$(eval $(call BuildPackage,luci-theme-$(THEME_NAME)))
