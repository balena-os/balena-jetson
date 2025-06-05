inherit kernel-resin deploy

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SCMVERSION="n"

# Prevent delayed booting
# and support using partition label to load rootfs
# in the case of jetson-xavier and tx2 flasher
SRC_URI:append = " \
    file://0001-Support-referencing-the-root-partition-label-from-GP.patch \
    file://0001-dont-export-rpmb-as-part.patch \
    file://fix-brcmfmac-compilation.patch \
    file://hardware-nvidia-platform-t210-porg.patch \
"

TODO: Rework these patches so that they apply
#file://0001-revert-random-fix-crng_ready-test.patch 
#    file://xhci-ring-Don-t-show-incorrect-WARN-message-about.patch 
# //0002-Update-qmi_wwan-to-kernel-4.14.patch

SRC_URI:append:jetson-tx2 = " \
    file://0001-Expose-spidev-to-the-userspace.patch \
    file://0002-mttcan-ivc-enable.patch \
    file://tegra186-tx2-cti-ASG001-USB3.dtb \
    file://tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb \
    file://tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb \
    file://tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb \
    file://tegra186-tx2-blackboard.dtb \
    file://realsense_powerlinefrequency_control_fix_linux-yocto_4.4.patch \
    file://0001-mttcan_ivc-Fix-build-failure-with-kernel-4.9.patch \
    file://0001-gasket-Backport-gasket-driver-from-linux-coral.patch \
    file://0011-Import-rtl88x2CE_WiFi_linux_v5.12.1.8-2-g58609677a.2.patch \
    file://0012-rtl8822ce-fix-compilation-errors.patch \
    file://0013-nvidia-net-wireless-realtek-clean-up-indentation-iss.patch \
    file://0014-realtek-rtl8822ce-Enable-802.11D-and-802.11K.patch \
    file://0015-drivers-bluetooth-realtek-Update-rtk_bt-to-5.12.1.8.patch \
    file://0016-rtl8822ce-core-Fix-build-comment-unused-function.patch \
    file://0017-rtl8822ce-os_dep-Fix-rssi-monitor-event-behavior.patch \
"

SRC_URI:append:jetson-xavier = " \
    file://0001-use-pllaon-as-clock-source-for-mttcan1-and-mttcan2.patch \
"

SRC_URI:append:jetson-xavier-nx-devkit-seeed-2mic-hat = " \
    file://tegra194-p3668-all-p3509-0000-seeed-2mic-hat.dtb \
"

SRC_URI:append:astro-tx2 = " \
    file://tegra186-tx2-cti-ASG001-revG+.dtb \
"

SRC_URI:append:jn30b-nano = " \
    file://tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb \
"
SRC_URI:append:floyd-nano = " \
    file://floyd-nano-Port-32.3.1-Floyd-patches-to-32.5.1.patch \
"

SRC_URI:append:jetson-nano = " \
    file://0001-gasket-Backport-gasket-driver-from-linux-coral.patch \
    file://nvidia-platform-t210-enable-SPI0-pins-on-40-pin-head.patch \
"

SRC_URI:append:jetson-nano-emmc = " \
    file://nano-mark-gpio-as-disabled-when-freed.patch \
    file://0001-gasket-Backport-gasket-driver-from-linux-coral.patch \
    file://nvidia-platform-t210-enable-SPI0-pins-on-40-pin-head.patch \
    file://tegra210-p3448-0002-p3449-0000-b00-auvidea-jn30d.dtb \
"

SRC_URI:append:photon-nano = " \
    file://0001-cti-photon-merge-CDC-MBIM-driver-changes-from-bsp.patch \
    file://tegra210-nano-cti-NGX003.dtb \
    file://tegra210-nano-cti-NGX004.dtb \
"

SRC_URI:append:photon-tx2-nx = " \
    file://0001-cti-photon-merge-CDC-MBIM-driver-changes-from-bsp.patch \
    file://tegra186-tx2-nx-cti-NGX003.dtb \
    file://tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb \
    file://tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb \
"

SRC_URI:append:photon-xavier-nx = " \
    file://0001-cti-photon-merge-CDC-MBIM-driver-changes-from-bsp.patch \
    file://tegra194-xavier-nx-cti-NGX003.dtb \
"

SRC_URI:append:cnx100-xavier-nx = " \
    file://tegra194-xavier-nx-cnx100.dtb \
"

SRC_URI:append:jetson-tx2-nx-devkit = " \
    file://tegra186-p3636-0001-p3509-0000-a01-auvidea-jn30d.dtb \
"

TEGRA_INITRAMFS_INITRD = "0"

BALENA_CONFIGS:remove:astro-tx2 = " mdraid"
BALENA_CONFIGS:remove:blackboard-tx2 = " mdraid"
BALENA_CONFIGS:remove:jetson-tx2-4-gb = " mdraid"
BALENA_CONFIGS:remove:jetson-tx2 = " mdraid"
BALENA_CONFIGS:remove:n310-tx2 = " mdraid"
BALENA_CONFIGS:remove:n510-tx2 = " mdraid"
BALENA_CONFIGS:remove:orbitty-tx2 = " mdraid"
BALENA_CONFIGS:remove:spacely-tx2 = " mdraid"

BALENA_CONFIGS:append = " tegra-wdt-t21x debug_kmemleak "

BALENA_CONFIGS[tegra-wdt-t21x] = " \
    CONFIG_TEGRA21X_WATCHDOG=m \
"

BALENA_CONFIGS[debug_kmemleak] = " \
    CONFIG_HAVE_DEBUG_KMEMLEAK=n \
    CONFIG_DEBUG_KMEMLEAK=n \
    CONFIG_HAVE_DEBUG_KMEMLEAK=n \
    CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y \
    CONFIG_DEBUG_KMEMLEAK_SCAN_ON=n \
    CONFIG_FUNCTION_TRACER=n \
    CONFIG_HAVE_FUNCTION_TRACER=n \
    CONFIG_PSTORE=n \
"

# These should be for all boards that come from tx2
BALENA_CONFIGS:append:jetson-tx2 = " tpg eqos_disable_eee"
BALENA_CONFIGS[tpg] = " \
                CONFIG_VIDEO_TEGRA_VI_TPG=m \
"

# Fixes reported ethernet issues
# See: elinux.org/Jetson/FAQ/BSP
BALENA_CONFIGS[eqos_disable_eee] = " \
                CONFIG_EQOS_DISABLE_EEE=y \
"

BALENA_CONFIGS:append:jetson-tx1 = " compat"
BALENA_CONFIGS:append:jetson-tx2 = " compat"
BALENA_CONFIGS[compat] = " \
                CONFIG_COMPAT=y \
"

BALENA_CONFIGS:remove:jetson-tx1 = " brcmfmac"
BALENA_CONFIGS:append:jetson-tx2 = " uvc"
BALENA_CONFIGS[uvc] = " \
                CONFIG_USB_VIDEO_CLASS=m \
                CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y \
"

BALENA_CONFIGS_DEPS[uvc] = " \
                CONFIG_MEDIA_CAMERA_SUPPORT=y \
                CONFIG_VIDEO_V4L2_SUBDEV_API=y \
                CONFIG_VIDEO_V4L2=m \
                CONFIG_VIDEOBUF2_CORE=m \
                CONFIG_VIDEOBUF2_MEMOPS=m \
                CONFIG_VIDEOBUF2_VMALLOC=m \
                CONFIG_MEDIA_USB_SUPPORT=y \
                CONFIG_USB_GSPCA=m \
                CONFIG_SND_USB=y \
                CONFIG_SND_USB_AUDIO=m \
"

BALENA_CONFIGS:append:jetson-tx2 = " egalax"
BALENA_CONFIGS[egalax] = " \
                CONFIG_TOUCHSCREEN_EGALAX=m \
"

BALENA_CONFIGS:append:jetson-tx2 = " serial"
BALENA_CONFIGS[serial] = " \
                CONFIG_USB_SERIAL_GENERIC=y \
"

BALENA_CONFIGS:append:jetson-tx2 = " spi"
BALENA_CONFIGS[spi] = " \
                CONFIG_SPI=y \
                CONFIG_SPI_MASTER=y \
                CONFIG_SPI_SPIDEV=m \
"
BALENA_CONFIGS_DEPS[spi] = " \
                CONFIG_QSPI_TEGRA186=y \
                CONFIG_SPI_TEGRA144=y \
"

BALENA_CONFIGS:append:jetson-tx2 = " gamepad"
BALENA_CONFIGS[gamepad] = " \
                CONFIG_JOYSTICK_XPAD=m \
"
BALENA_CONFIGS_DEPS[gamepad] = " \
                CONFIG_INPUT_JOYSTICK=y \
                CONFIG_USB_ARCH_HAS_HCD=y \
"

BALENA_CONFIGS:append:jetson-tx2 = " can"
BALENA_CONFIGS[can] = " \
                CONFIG_CAN=y \
                CONFIG_CAN_RAW=y \
                CONFIG_CAN_DEV=y \
                CONFIG_MTTCAN=n \
                CONFIG_MTTCAN_IVC=y \
"

BALENA_CONFIGS:append:jetson-tx2 = " gasket"
BALENA_CONFIGS[gasket] = " \
        CONFIG_STAGING_GASKET_FRAMEWORK=m \
        CONFIG_STAGING_APEX_DRIVER=m \
"

BALENA_CONFIGS:append:jetson-nano = " gasket"
BALENA_CONFIGS:append:jetson-nano-emmc = " gasket"

BALENA_CONFIGS:append:photon-nano = " tlc591xx"
BALENA_CONFIGS:append:photon-tx2-nx = " tlc591xx"
BALENA_CONFIGS:append:photon-xavier-nx = " tlc591xx"
BALENA_CONFIGS:append:cnx100-xavier-nx = " tlc591xx"
BALENA_CONFIGS[tlc591xx] = " \
                CONFIG_LEDS_TLC591XX=m \
"

BALENA_CONFIGS:append:photon-nano = " cdc-wdm"
BALENA_CONFIGS:append:photon-tx2-nx = " cdc-wdm"
BALENA_CONFIGS:append:photon-xavier-nx = " cdc-wdm"
BALENA_CONFIGS:append:cnx100-xavier-nx = " cdc-wdm"
BALENA_CONFIGS[cdc-wdm] = " \
                CONFIG_USB_WDM=m \
"

BALENA_CONFIGS:append:photon-nano = " sierra-net"
BALENA_CONFIGS:append:photon-tx2-nx = " sierra-net"
BALENA_CONFIGS:append:photon-xavier-nx = " sierra-net"
BALENA_CONFIGS:append:cnx100-xavier-nx = " sierra-net"
BALENA_CONFIGS[sierra-net] = " \
                CONFIG_USB_SIERRA_NET=m \
"

BALENA_CONFIGS_DEPS[sierra-net] = " \
                CONFIG_USB_USBNET=m \
"

BALENA_CONFIGS:append:photon-nano = " cdc-ncm"
BALENA_CONFIGS:append:photon-tx2-nx = " cdc-ncm"
BALENA_CONFIGS:append:photon-xavier-nx = " cdc-ncm"
BALENA_CONFIGS:append:cnx100-xavier-nx = " cdc-ncm"
BALENA_CONFIGS[cdc-ncm] = " \
                CONFIG_USB_NET_CDC_NCM=m \
"

BALENA_CONFIGS_DEPS[cdc-ncm] = " \
                CONFIG_USB_USBNET=m \
"

BALENA_CONFIGS:append:photon-nano = " mii"
BALENA_CONFIGS:append:photon-tx2-nx = " mii"
BALENA_CONFIGS:append:photon-xavier-nx = " mii"
BALENA_CONFIGS:append:cnx100-xavier-nx = " mii"
BALENA_CONFIGS[mii] = " \
                CONFIG_MII=m \
"

BALENA_CONFIGS:append = " cfginput"
BALENA_CONFIGS[cfginput] = " \
		CONFIG_INPUT_LEDS=m \
		CONFIG_FF_MEMLESS=m \
		CONFIG_INPUT_MOUSEDEV=m \
		CONFIG_INPUT_JOYDEV=m \
		CONFIG_JOYSTICK_XPAD=m \
		CONFIG_INPUT_KEYCHORD=m \
"

BALENA_CONFIGS:append = " rtl8822ce "
BALENA_CONFIGS[rtl8822ce] = " \
		CONFIG_RTL8822CE=m \
		CONFIG_RTK_BTUSB=m \
"

# Switch nfs and backlight drivers as modules
# to shrink down the kernel image size starting
# with BalenaOS 2.65.0
BALENA_CONFIGS:append = " nfsfs backlight "
BALENA_CONFIGS[nfsfs] = " \
    CONFIG_NFS_FS=m \
    CONFIG_NFS_V2=m \
    CONFIG_NFS_V3=m \
    CONFIG_NFS_V4=m \
    CONFIG_NFSD_V3=y \
    CONFIG_NFSD_V4=y \
"

BALENA_CONFIGS[backlight] = " \
    CONFIG_BACKLIGHT_PWM=m \
    CONFIG_BACKLIGHT_LP855X=m \
    CONFIG_BACKLIGHT_CLASS_DEVICE=m \
"

BALENA_CONFIGS:append:jetson-tx2 = " optimize-size"
BALENA_CONFIGS[optimize-size] = " \
    CONFIG_CC_OPTIMIZE_FOR_SIZE=y \
"

L4TVER=" l4tver=${L4T_VERSION}"
KERNEL_ROOTSPEC:jetson-nano = "\${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC:jetson-nano-emmc = "\${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC:jetson-nano-2gb-devkit = "\${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC:jn30b-nano = "\${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC:jetson-tx2 = " \${resin_kernel_root} ro rootwait gasket.dma_bit_mask=32 pcie_aspm=off"
KERNEL_ROOTSPEC:jetson-tx1 = " \${resin_kernel_root} ro rootwait"
KERNEL_ROOTSPEC:jetson-xavier = ""
KERNEL_ROOTSPEC:jetson-xavier-nx-devkit-emmc = ""

# Since 32.1 on tx2, after kernel is loaded sd card becomes mmcblk2 opposed
# to u-boot where it was 1. This is another cause of failure of
# previous flasher images.  Use label to distinguish rootfs
KERNEL_ROOTSPEC_FLASHER:jetson-tx2 = " root=LABEL=flash-rootA ro rootwait flasher gasket.dma_bit_mask=32 pcie_aspm=off"
KERNEL_ROOTSPEC_FLASHER:jetson-tx1 = " root=LABEL=flash-rootA ro rootwait flasher"
KERNEL_ROOTSPEC:append="${L4TVER}"
KERNEL_ROOTSPEC_FLASHER:append="${L4TVER}"

EXTLINUX_FDT="FDT default"

generate_extlinux_conf() {
    mkdir -p ${DEPLOY_DIR_IMAGE}/extlinux || true
    kernelRootspec="${KERNEL_ROOTSPEC}" ; cat >${DEPLOY_DIR_IMAGE}/extlinux/extlinux.conf << EOF
DEFAULT primary
TIMEOUT 10
MENU TITLE Boot Options
LABEL primary
      MENU LABEL primary ${KERNEL_IMAGETYPE}
      LINUX /${KERNEL_IMAGETYPE}
      ${EXTLINUX_FDT}
      APPEND \${cbootargs} ${kernelRootspec} \${os_cmdline} sdhci_tegra.en_boot_part_access=1
EOF
    kernelRootspec="${KERNEL_ROOTSPEC_FLASHER}" ; cat >${DEPLOY_DIR_IMAGE}/extlinux/extlinux.conf_flasher << EOF
DEFAULT primary
TIMEOUT 10
MENU TITLE Boot Options
LABEL primary
      MENU LABEL primary ${KERNEL_IMAGETYPE}
      LINUX /${KERNEL_IMAGETYPE}
      APPEND \${cbootargs} ${kernelRootspec} \${os_cmdline} sdhci_tegra.en_boot_part_access=1
EOF
}

do_deploy[nostamp] = "1"
do_deploy[postfuncs] += "generate_extlinux_conf"
do_install[depends] += "${@['', '${INITRAMFS_IMAGE}:do_image_complete'][(d.getVar('INITRAMFS_IMAGE', True) or '') != '' and (d.getVar('TEGRA_INITRAMFS_INITRD', True) or '') == "1"]}"

do_deploy:append:spacely-tx2() {
   cp ${WORKDIR}/tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb "${DEPLOYDIR}"
}

do_deploy:append:orbitty-tx2() {
   cp ${WORKDIR}/tegra186-tx2-cti-ASG001-USB3.dtb "${DEPLOYDIR}"
}

do_deploy:append:n510-tx2() {
    cp ${WORKDIR}/tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb "${DEPLOYDIR}"
}
do_deploy:append:n310-tx2() {
    cp ${WORKDIR}/tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb "${DEPLOYDIR}"
}

do_deploy:append:jetson-xavier-nx-devkit-seeed-2mic-hat() {
    cp ${WORKDIR}/tegra194-p3668-all-p3509-0000-seeed-2mic-hat.dtb "${DEPLOYDIR}"
}

do_deploy:append:blackboard-tx2() {
    cp ${WORKDIR}/tegra186-tx2-blackboard.dtb "${DEPLOYDIR}"
}

do_deploy:append:jn30b-nano() {
    cp ${WORKDIR}/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb "${DEPLOYDIR}"
}

do_deploy:append:photon-nano() {
    cp ${WORKDIR}/tegra210-nano-cti-NGX003.dtb "${DEPLOYDIR}"
    cp ${WORKDIR}/tegra210-nano-cti-NGX004.dtb "${DEPLOYDIR}"
}

do_deploy:append:photon-tx2-nx() {
    cp ${WORKDIR}/tegra186-tx2-nx-cti-NGX003.dtb "${DEPLOYDIR}"
    cp ${WORKDIR}/tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb "${DEPLOYDIR}"
    cp ${WORKDIR}/tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb "${DEPLOYDIR}"
}

do_deploy:append:photon-xavier-nx() {
    cp ${WORKDIR}/tegra194-xavier-nx-cti-NGX003.dtb "${DEPLOYDIR}"
}

do_deploy:append:cnx100-xavier-nx() {
    cp ${WORKDIR}/tegra194-xavier-nx-cnx100.dtb "${DEPLOYDIR}"
}

do_deploy:append:astro-tx2() {
    cp ${WORKDIR}/tegra186-tx2-cti-ASG001-revG+.dtb "${DEPLOYDIR}"
}

