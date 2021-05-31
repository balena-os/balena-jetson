include balena-image.inc

BALENA_BOOT_PARTITION_FILES_append_jetson-tx2 = " \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
"

BALENA_BOOT_PARTITION_FILES_append_jetson-tx2-4gb = " \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
"
BALENA_BOOT_PARTITION_FILES_append_jetson-tx2 = " \
    boot/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
BALENA_BOOT_PARTITION_FILES_append_jetson-tx2-4gb = " \
    boot/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
BALENA_BOOT_PARTITION_FILES_append_jetson-tx1 = " \
    boot/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
