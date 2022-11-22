include balena-image.inc

BALENA_BOOT_PARTITION_FILES:append:jetson-tx2 = " \ 
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
    extlinux/extlinux.conf_flasher:/extlinux/extlinux.conf \
"
