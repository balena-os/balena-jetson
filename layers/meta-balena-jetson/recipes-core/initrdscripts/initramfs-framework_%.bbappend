FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

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
