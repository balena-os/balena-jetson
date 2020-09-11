FILESEXTRAPATHS_append := ":${THISDIR}/linux-tegra"

inherit allarch systemd

DESCRIPTION = "Package for deploying custom dtbs to rootfs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " file://tegra186-tx2-6.dtb "

RDEPENDS_${PN} = " bash "

S = "${WORKDIR}"

do_install () {
    install -d ${D}/boot/
    install -m 0644 ${WORKDIR}/tegra186-tx2-6.dtb ${D}/boot/tegra186-tx2-6.dtb
}

FILES_${PN} += " /boot/tegra186-tx2-6.dtb"

COMPATIBLE_MACHINE = "(jetson-nano|jetson-nano-emmc|jetson-tx2)"
