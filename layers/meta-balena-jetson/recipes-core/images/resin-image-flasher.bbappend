include resin-image.inc

RESIN_BOOT_PARTITION_FILES_append_jetson-tx2 = " \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
"

RESIN_BOOT_PARTITION_FILES_append_jetson-tx2 = " \
    boot/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
RESIN_BOOT_PARTITION_FILES_append_jetson-tx1 = " \
    boot/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
