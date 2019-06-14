inherit kernel-resin deploy

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Prevent delayed booting
SRC_URI_append = " \
    file://0001-revert-random-fix-crng_ready-test.patch \
"

SRC_URI_append_jetson-xavier = " file://0001-Support-referencing-the-root-partition-label-from-GP.patch "

TEGRA_INITRAMFS_INITRD = "0"

RESIN_CONFIGS_append = " tegra-wdt-t21x"
RESIN_CONFIGS[tegra-wdt-t21x] = " \
    CONFIG_TEGRA21X_WATCHDOG=m \
"

RESIN_CONFIGS_append = " fatconfig"

RESIN_CONFIGS[fatconfig] = " \
    CONFIG_MSDOS_FS=y \
    CONFIG_VFAT_FS=y \
    CONFIG_NLS_ASCII=y \
    CONFIG_NLS_CODEPAGE_437=y \
"

KERNEL_ROOTSPEC = "\${resin_kernel_root} ro rootwait"

generate_extlinux_conf() {
    install -d ${D}/${KERNEL_IMAGEDEST}/extlinux
    rm -f ${D}/${KERNEL_IMAGEDEST}/extlinux/extlinux.conf
    kernelRootspec="${KERNEL_ROOTSPEC}" ; cat >${D}/${KERNEL_IMAGEDEST}/extlinux/extlinux.conf << EOF
DEFAULT primary
TIMEOUT 10
MENU TITLE Boot Options
LABEL primary
      MENU LABEL primary ${KERNEL_IMAGETYPE}
      LINUX /${KERNEL_IMAGETYPE}
      APPEND \${cbootargs} ${kernelRootspec} \${os_cmdline}
EOF
}

do_install[postfuncs] += "generate_extlinux_conf"
do_install[depends] += "${@['', '${INITRAMFS_IMAGE}:do_image_complete'][(d.getVar('INITRAMFS_IMAGE', True) or '') != '' and (d.getVar('TEGRA_INITRAMFS_INITRD', True) or '') == "1"]}"

do_deploy_append(){
    mkdir -p "${DEPLOYDIR}/boot/"
    install -m 0600 "${D}/boot/extlinux/extlinux.conf" "${DEPLOYDIR}/boot/"
}

FILES_${KERNEL_PACKAGE_NAME}-image_append = "/boot/extlinux/extlinux.conf"
