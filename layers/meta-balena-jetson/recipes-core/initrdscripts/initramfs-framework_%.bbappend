FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:jetson-xavier = " \
    file://blockdev \
"

SRC_URI:append:jetson-xavier-nx-devkit-emmc = " \
    file://blockdev \
"

SRC_URI:append:jetson-xavier-nx-devkit = " \
    file://blockdev \
"

do_install:append:jetson-xavier() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

do_install:append:jetson-xavier-nx-devkit-emmc() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

do_install:append:jetson-xavier-nx-devkit() {
    install -m 0755 ${WORKDIR}/blockdev ${D}/init.d/02-blockdev
}

PACKAGES:append:jetson-xavier = " \
    initramfs-module-blockdev \
"

PACKAGES:append:jetson-xavier-nx-devkit-emmc = " \
    initramfs-module-blockdev \
"

PACKAGES:append:jetson-xavier-nx-devkit = " \
    initramfs-module-blockdev \
"

# Run this script after 01-udev
# to populate /dev with emmc partitions
SUMMARY:initramfs-module-blockdev = "Trigger ioctl to force re-read emmc partitions"
FILES:initramfs-module-blockdev = "/init.d/02-blockdev"


SRC_URI:append = " \
    file://governor \
"

do_install:append:() {
    install -m 0755 ${WORKDIR}/governor ${D}/init.d/01-governor
}


PACKAGES:append = " \
    initramfs-module-governor \
"

SUMMARY:initramfs-module-governor = "Set arm cores governor to performance"
FILES:initramfs-module-governor = "/init.d/01-governor"
