# Fixes error: packages already installed
# by kernel-image-initramfs
do_install:append() {
        rm ${D}/boot/Image || true
}

