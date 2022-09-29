inherit kernel-resin deploy

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SCMVERSION="n"

# Prevent delayed booting
# and support using partition label to load rootfs
# in the case of jetson-xavier and tx2 flasher

##SRC_URI:append = " 
##  file://0001-revert-random-fix-crng_ready-test.patch 
##    file://0001-Support-referencing-the-root-partition-label-from-GP.patch 
##    file://xhci-ring-Don-t-show-incorrect-WARN-message-about.patch 
##    file://0001-dont-export-rpmb-as-part.patch 
##"

BALENA_CONFIGS:remove = " mdraid"

BALENA_CONFIGS:append = " debug_kmemleak "

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

BALENA_CONFIGS:append = " compat"
BALENA_CONFIGS[compat] = " \
                CONFIG_COMPAT=y \
"

BALENA_CONFIGS:append = " cdc-wdm"
BALENA_CONFIGS[cdc-wdm] = " \
                CONFIG_USB_WDM=m \
"

BALENA_CONFIGS:append = " sierra-net"
BALENA_CONFIGS[sierra-net] = " \
                CONFIG_USB_SIERRA_NET=m \
"

BALENA_CONFIGS_DEPS[sierra-net] = " \
                CONFIG_USB_USBNET=m \
"

BALENA_CONFIGS:append = " cdc-ncm"
BALENA_CONFIGS[cdc-ncm] = " \
                CONFIG_USB_NET_CDC_NCM=m \
"

BALENA_CONFIGS_DEPS[cdc-ncm] = " \
                CONFIG_USB_USBNET=m \
"

BALENA_CONFIGS:append = " mii"

BALENA_CONFIGS:append:jetson = " rtl8822ce "
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
    CONFIG_NFS_V2=y \
    CONFIG_NFS_V3=y \
    CONFIG_NFS_V4=y \
    CONFIG_NFSD_V3=y \
    CONFIG_NFSD_V4=y \
"

BALENA_CONFIGS[backlight] = " \
    CONFIG_BACKLIGHT_PWM=m \
    CONFIG_BACKLIGHT_LP855X=m \
    CONFIG_BACKLIGHT_CLASS_DEVICE=m \
"

L4TVER=" l4tver=${L4T_VERSION}"

KERNEL_ROOTSPEC:append="${L4TVER}"
EXTLINUX_FDT="FDT default"

generate_extlinux_conf() {
    mkdir -p ${DEPLOY_DIR_IMAGE}/extlinux || true
    kernelRootspec="${KERNEL_ARGS}" ; cat >${DEPLOY_DIR_IMAGE}/extlinux/extlinux.conf << EOF
DEFAULT primary
TIMEOUT 10
MENU TITLE Boot Options
LABEL primary
      MENU LABEL primary ${KERNEL_IMAGETYPE}
      LINUX /boot/${KERNEL_IMAGETYPE}
      APPEND \${cbootargs} ${kernelRootspec} \${os_cmdline} sdhci_tegra.en_boot_part_access=1 root=LABEL=resin-rootA rootwait
EOF

}

RDEPENDS:${KERNEL_PACKAGE_NAME}-base = "${@'' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else '${KERNEL_PACKAGE_NAME}-image'}"

do_deploy[nostamp] = "1"
do_deploy[postfuncs] += "generate_extlinux_conf"
do_install[depends] += "${@['', '${INITRAMFS_IMAGE}:do_image_complete'][(d.getVar('INITRAMFS_IMAGE', True) or '') != '' and (d.getVar('TEGRA_INITRAMFS_INITRD', True) or '') == "1"]}"
#do_install[depends] += "${INITRAMFS_IMAGE}:do_image_complete"
