IMAGE_FSTYPES_append = " resinos-img"

do_rootfs_resinos-img_jetson-nano[depends] += " tegra210-flash:do_deploy \
                                                virtual/kernel:do_deploy \
"

# Name update files as partition names for easier updating
RESIN_BOOT_PARTITION_FILES_jetson-nano = " \
    boot/extlinux.conf:/extlinux/extlinux.conf \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
    bootfiles/nvtboot_cpu.bin.encrypt:/bootfiles/TBC \
    bootfiles/tegra210-p3448-0000-p3449-0000-a02.dtb.encrypt:/bootfiles/RP1 \
    bootfiles/cboot.bin.encrypt:/bootfiles/EBT \
    bootfiles/warmboot.bin.encrypt:/bootfiles/WB0 \
    bootfiles/sc7entry-firmware.bin.encrypt:/bootfiles/BPF \
    bootfiles/tos-mon-only.img.encrypt:/bootfiles/TOS \
    bootfiles/eks.img:/bootfiles/EKS \
    bootfiles/u-boot-dtb.bin.encrypt:/bootfiles/LNX \
    bootfiles/tegra210-p3448-0000-p3449-0000-a02.dtb.encrypt:/bootfiles/DTB \
    bootfiles/rp4.blob:/bootfiles/RP4 \
    bootfiles/bmp.blob:/bootfiles/BMP \
"

do_rootfs_resinos-img_jetson-tx2[depends] += " tegra186-flash-dry:do_deploy \
                                               virtual/kernel:do_deploy \
"


RESIN_BOOT_PARTITION_FILES_jetson-tx2 = " \
    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/${KERNEL_IMAGETYPE} \
    boot/extlinux.conf:/extlinux/extlinux.conf \
"

IMAGE_ROOTFS_SIZE = "487424"

RESIN_BOOT_SIZE_jetson-nano = "80960"
RESIN_BOOT_SIZE_jetson-tx2="101440"

PARTITION_TABLE_TYPE = "gpt"

IMAGE_INSTALL_append_jetson-nano = " tegra210-flash"
IMAGE_INSTALL_append_jetson-tx2 = " \
    tegra186-flash-dry \
    parted \
    gptfdisk \
    tegra-firmware-brcm \
    tegra-brcm-patchram \
    bluez5 \
    bt-scripts \
    linux-firmware-bcm4354 \
    fan-startup \
    tegra-nvpmodel \
    tegra-configs-nvstartup \
    tegra-configs-udev \
"
