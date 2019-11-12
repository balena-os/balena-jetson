FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBOOT_KCONFIG_SUPPORT = "1"

inherit resin-u-boot

RESIN_BOOT_PART_jetson-nano = "0xC"
RESIN_DEFAULT_ROOT_PART_jetson-nano = "0xD"

SRCREV = "8e576d30001dc06552b017fab22e00fe7145b8da"

# These changes are necessary since balenaOS 2.39.0
# for all boards that use u-boot
SRC_URI_append = " \
        file://0001-Increase-default-u-boot-environment-size.patch \
        file://0001-menu-Use-default-menu-entry-from-extlinux.conf.patch \
"

SRC_URI_append_jetson-nano = " \
	file://nano-Integrate-with-Balena-u-boot-environment.patch \
"

# In l4t 28.2 below partitions were 0xC and 0xD
RESIN_BOOT_PART_jetson-tx2 = "0x18"
RESIN_DEFAULT_ROOT_PART_jetson-tx2 = "0x19"

SRC_URI_append_jetson-tx2 = " \
    file://0001-Add-part-index-command.patch \
    file://tx2-Integrate-with-Balena-u-boot-environment.patch \
"
