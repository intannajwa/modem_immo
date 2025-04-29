include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-nfttl
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Dotycat.com <support@dotycat.com>
PKG_LICENSE:=GPL-3.0

LUCI_TITLE:=LuCI App for nftables TTL Management
LUCI_DESCRIPTION:=This LuCI app allows configuration of TTL modification rules using nftables.
LUCI_DEPENDS:=+luci +nftables

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=$(LUCI_TITLE)
	PKGARCH:=all
	DEPENDS:=$(LUCI_DEPENDS)
endef

define Package/$(PKG_NAME)/description
	$(LUCI_DESCRIPTION)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
