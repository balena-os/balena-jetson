inherit kernel-resin deploy

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Prevent delayed booting
# and support using partition label to load rootfs
# in the case of jetson-xavier and tx2 flasher
SRC_URI_append = " \
    file://0001-revert-random-fix-crng_ready-test.patch \
    file://0001-Support-referencing-the-root-partition-label-from-GP.patch \
"

TEGRA_INITRAMFS_INITRD = "0"

RESIN_CONFIGS_append = " tegra-wdt-t21x debug_kmemleak"
RESIN_CONFIGS[tegra-wdt-t21x] = " \
    CONFIG_TEGRA21X_WATCHDOG=m \
"

RESIN_CONFIGS[debug_kmemleak] = " \
    CONFIG_HAVE_DEBUG_KMEMLEAK=n \
    CONFIG_DEBUG_KMEMLEAK=n \
    CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y \
    CONFIG_DEBUG_KMEMLEAK_SCAN_ON=n \
"

KERNEL_ROOTSPEC_jetson-nano = "\${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC_jetson-tx2 = " \${resin_kernel_root} ro rootwait sdhci_tegra.en_boot_part_access=1"
KERNEL_ROOTSPEC_jetson-xavier = ""

# Since 32.1 on tx2, after kernel is loaded sd card becomes mmcblk2 opposed
# to u-boot where it was 1. This is another cause of failure of
# previous flasher images.  Use label to distinguish rootfs
KERNEL_ROOTSPEC_FLASHER_jetson-tx2 = " root=LABEL=flash-rootA ro rootwait sdhci_tegra.en_boot_part_access=1 flasher"

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
    kernelRootspec="${KERNEL_ROOTSPEC_FLASHER}" ; cat >${D}/${KERNEL_IMAGEDEST}/extlinux/extlinux.conf_flasher << EOF
DEFAULT primary
TIMEOUT 10
MENU TITLE Boot Options
LABEL primary
      MENU LABEL primary ${KERNEL_IMAGETYPE}
      LINUX /${KERNEL_IMAGETYPE}
      APPEND ${KERNEL_ARGS} ${kernelRootspec} \${os_cmdline}
EOF
}

do_install[postfuncs] += "generate_extlinux_conf"
do_install[depends] += "${@['', '${INITRAMFS_IMAGE}:do_image_complete'][(d.getVar('INITRAMFS_IMAGE', True) or '') != '' and (d.getVar('TEGRA_INITRAMFS_INITRD', True) or '') == "1"]}"

do_deploy_append(){
    mkdir -p "${DEPLOYDIR}/boot/"
    install -m 0600 "${D}/boot/extlinux/extlinux.conf" "${DEPLOYDIR}/boot/"
    install -m 0600 "${D}/boot/extlinux/extlinux.conf_flasher" "${DEPLOYDIR}/boot/"
}

FILES_${KERNEL_PACKAGE_NAME}-image_append = "/boot/extlinux/extlinux.conf /boot/extlinux/extlinux.conf_flasher"
