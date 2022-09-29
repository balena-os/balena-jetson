do_install:prepend:tegra234() {
    cp ${DEPLOY_DIR_IMAGE}/extlinux/extlinux.conf ${B}/
}


do_compile() {
    cp -L ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin ${B}/${KERNEL_IMAGETYPE}
    if [ -n "${UBOOT_EXTLINUX_FDT}" ]; then
        cp -L ${DEPLOY_DIR_IMAGE}/${DTBFILE} ${B}/
    fi
}

