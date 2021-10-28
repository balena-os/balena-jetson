include balena-image.inc

BALENA_BOOT_PARTITION_FILES:append:jetson-tx2 = " \ 
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
"

BALENA_BOOT_PARTITION_FILES:append:jetson-tx2 = " \
    extlinux/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
BALENA_BOOT_PARTITION_FILES:append:jetson-tx1 = " \
    extlinux/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
