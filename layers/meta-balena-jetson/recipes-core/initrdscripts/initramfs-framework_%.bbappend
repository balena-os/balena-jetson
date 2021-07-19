FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_jetson-xavier = " \
    file://blockdev \
"

SRC_URI_append_jetson-xavier-nx-devkit-emmc = " \
    file://blockdev \
"

SRC_URI_append_jetson-xavier-nx-devkit = " \
    file://blockdev \
"

do_install_append_jetson-xavier() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

do_install_append_jetson-xavier-nx-devkit-emmc() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

do_install_append_jetson-xavier-nx-devkit() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

PACKAGES_append_jetson-xavier = " \
    initramfs-module-blockdev \
"

PACKAGES_append_jetson-xavier-nx-devkit-emmc = " \
    initramfs-module-blockdev \
"

PACKAGES_append_jetson-xavier-nx-devkit = " \
    initramfs-module-blockdev \
"

# Run this script after 01-udev
# to populate /dev with emmc partitions
SUMMARY_initramfs-module-blockdev = "Trigger ioctl to force re-read emmc partitions"
FILES_initramfs-module-blockdev = "/init.d/02-blockdev"


SRC_URI_append = " \
    file://governor \
"

do_install_append_() {
    install -m 0755 ${WORKDIR}/governor ${D}/init.d/01-governor
}


PACKAGES_append = " \
    initramfs-module-governor \
"

SUMMARY_initramfs-module-governor = "Set arm cores governor to performance"
FILES_initramfs-module-governor = "/init.d/01-governor"
