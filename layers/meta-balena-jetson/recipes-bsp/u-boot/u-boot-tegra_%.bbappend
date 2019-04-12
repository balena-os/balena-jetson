FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBOOT_KCONFIG_SUPPORT = "1"

inherit resin-u-boot

RESIN_BOOT_PART = "0xC"
RESIN_DEFAULT_ROOT_PART = "0xD"

SRC_URI_append = " \
	file://0001-Integrate-with-Balena-u-boot-environment.patch \
"
