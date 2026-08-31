# LuCI PeDitXOSui Theme
# Copyright 2025 PeDitX <t.me/peditx>
#
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=PeDitXOSui Theme for LuCI
LUCI_DEPENDS:=+luci-base
LUCI_PKGARCH:=all

PKG_NAME:=luci-theme-peditxosui
PKG_VERSION:=1.0.0
PKG_RELEASE:=01

PKG_BUILD_DEPENDS:=luci-base/host

include $(TOPDIR)/feeds/luci/luci.mk

# Define package install
define Package/luci-theme-peditxosui/install
	$(INSTALL_DIR) $(1)/www/luci-static/peditxosui
	$(CP) ./htdocs/luci-static/peditxosui/* $(1)/www/luci-static/peditxosui/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/themes/peditxosui
	$(CP) ./luasrc/view/themes/peditxosui/* $(1)/usr/lib/lua/luci/view/themes/peditxosui/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/peditxosui
	$(CP) ./luasrc/view/peditxosui/* $(1)/usr/lib/lua/luci/view/peditxosui/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(CP) ./htdocs/luci-static/resources/* $(1)/www/luci-static/resources/

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/30-luci-theme-peditxosui $(1)/etc/uci-defaults/

	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./root/etc/config/peditxosui $(1)/etc/config/
endef
