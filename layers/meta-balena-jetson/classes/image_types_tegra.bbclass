inherit image_types image_types_cboot python3native perlnative

def tegra_kernel_image(d):
    if d.getVar('IMAGE_UBOOT'):
        return '${DEPLOY_DIR_IMAGE}/${IMAGE_UBOOT}-${MACHINE}.bin'
    if d.getVar('INITRAMFS_IMAGE'):
        if bb.utils.to_boolean(d.getVar('INITRAMFS_IMAGE_BUNDLE')):
            img = '${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.cboot'
        else:
            img = '${DEPLOY_DIR_IMAGE}/${INITRD_IMAGE}-${MACHINE}.cboot'
        return img
    return '${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.cboot'

IMAGE_TEGRAFLASH_KERNEL ?= "${@tegra_kernel_image(d)}"
DATAFILE ??= ""
IMAGE_TEGRAFLASH_DATA ??= ""

BL_IS_CBOOT = "${@'1' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else '0'}"
TEGRA_SPIFLASH_BOOT ??= ""
TEGRA_ROOTFS_AND_KERNEL_ON_SDCARD ??=""

CBOOTFILENAME = "cboot.bin"
CBOOTFILENAME_tegra194 = "cboot_t194.bin"
TOSIMGFILENAME = "tos-trusty.img"
TOSIMGFILENAME_tegra194 = "tos-trusty_t194.img"
TOSIMGFILENAME_tegra210 = "tos-mon-only.img"
BMPBLOBFILENAME = "bmp.blob"

BUP_PAYLOAD_DIR = "payloads_t${@d.getVar('NVIDIA_CHIP')[2:]}x"
FLASHTOOLS_DIR = "${SOC_FAMILY}-flash"
FLASHTOOLS_DIR_tegra194 = "tegra186-flash"

IMAGE_TYPES += "cpio.gz.cboot.bup-payload"
