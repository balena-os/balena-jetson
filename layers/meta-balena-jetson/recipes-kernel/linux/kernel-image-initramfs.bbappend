# For Xavier devices, which don't use
# u-boot and load the kernel from a raw
# partition, we can free up some rootfs
# space that would otherwise be taken up by
# the kernel image.
do_install_append_jetson-xavier() {
    echo "" > ${D}/boot/${type}
}

do_install_append_jetson-xavier-nx-devkit-emmc() {
    echo "" > ${D}/boot/${type}
}
