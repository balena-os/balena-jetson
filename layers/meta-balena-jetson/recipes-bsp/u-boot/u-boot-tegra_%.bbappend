FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBOOT_KCONFIG_SUPPORT = "1"

inherit resin-u-boot

RESIN_BOOT_PART_jetson-nano = "0xC"
RESIN_DEFAULT_ROOT_PART_jetson-nano = "0xD"

SRC_URI_append_jetson-nano = " \
	file://0001-Integrate-with-Balena-u-boot-environment.patch \
"

# In l4t 28.2 below partitions were 0xC and 0xD
RESIN_BOOT_PART_jetson-tx2 = "0x18"
RESIN_DEFAULT_ROOT_PART_jetson-tx2 = "0x19"

SRC_URI_append_jetson-tx2 = " \
    file://0001-Add-part-index-command.patch \
    file://tx2-Integrate-with-Balena-u-boot-environment.patch \
    file://0001-Increase-default-u-boot-environment-size.patch \
"
