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

IMAGE_ROOTFS_SIZE = "487424"
RESIN_BOOT_SIZE = "80960"

PARTITION_TABLE_TYPE = "gpt"

IMAGE_INSTALL_append_jetson-nano = " tegra210-flash"
