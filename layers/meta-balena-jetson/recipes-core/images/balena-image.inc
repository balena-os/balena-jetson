IMAGE_FSTYPES:append = " balenaos-img"

do_rootfs:balenaos-img:jetson-nano[depends] += " tegra210-flash:do_deploy \
                                                linux-tegra:do_deploy \
"

do_rootfs:balenaos-img:jetson-nano-emmc[depends] += " tegra210-flash:do_deploy \
                                                linux-tegra:do_deploy \
"

do_rootfs:balenaos-img:jetson-nano-2gb-devkit[depends] += " tegra210-flash:do_deploy \
                                                linux-tegra:do_deploy \
"

DTBFILE ?= "${@os.path.basename(d.getVar('KERNEL_DEVICETREE', True).split()[0])}"
DTBFILE:jetson-nano = "tegra210-p3448-0000-p3449-0000-b00.dtb"
DTBFILE:jetson-nano-emmc = "tegra210-p3448-0002-p3449-0000-b00.dtb"
DTBFILE:jetson-nano-2gb-devkit = "tegra210-p3448-0003-p3542-0000.dtb"
DTBFILE:jn30b-nano = "tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb"
DTBFILE:photon-nano = "tegra210-nano-cti-NGX003.dtb"
DTBFILE:photon-tx2-nx = "tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb"
DTBFILE:floyd-nano="tegra210-p3448-0002-p3449-0000-b00-floyd-nano.dtb"
DTBFILE:cnx100-xavier-nx = "tegra194-xavier-nx-cnx100.dtb"

BALENA_BOOT_PARTITION_FILES:append = " \
    dispatcher.d/50-sample-script:/dispatcher.d/50-sample-script \
"

NANO_BOOT_PARTITION_FILES = " \
    bootfiles/nvtboot_cpu.bin.encrypt:/bootfiles/TBC \
    bootfiles/${DTBFILE}.encrypt:/bootfiles/RP1 \
    bootfiles/cboot.bin.encrypt:/bootfiles/EBT \
    bootfiles/warmboot.bin.encrypt:/bootfiles/WB0 \
    bootfiles/sc7entry-firmware.bin.encrypt:/bootfiles/BPF \
    bootfiles/tos-mon-only.img.encrypt:/bootfiles/TOS \
    bootfiles/eks.img:/bootfiles/EKS \
    bootfiles/u-boot.bin.encrypt:/bootfiles/LNX \
    bootfiles/${DTBFILE}.encrypt:/bootfiles/DTB \
    bootfiles/rp4.blob:/bootfiles/RP4 \
    bootfiles/bmp.blob:/bootfiles/BMP \
"

# Name update files as partition names for easier updating
BALENA_BOOT_PARTITION_FILES:append:jetson-nano = " ${NANO_BOOT_PARTITION_FILES} "
BALENA_BOOT_PARTITION_FILES:append:jetson-nano-emmc = "${NANO_BOOT_PARTITION_FILES}"
BALENA_BOOT_PARTITION_FILES:append:jetson-nano-2gb-devkit = "${NANO_BOOT_PARTITION_FILES}"

do_rootfs:balenaos-img:jetson-tx2[depends] += " tegra186-flash-dry:do_deploy \
                                               linux-tegra:do_deploy \
"

# The space resinOS takes will amount to 1GiB
IMAGE_ROOTFS_SIZE = "487424"

# Need space for all the above signed update binaries
BALENA_BOOT_SIZE:jetson-nano = "80960"
BALENA_BOOT_SIZE:jetson-nano-2gb-devkit = "80960"
BALENA_BOOT_SIZE:jetson-nano-emmc = "80960"
BALENA_BOOT_SIZE:jetson-tx2="80960"
BALENA_BOOT_SIZE:jetson-tx1="80960"

IMAGE_PACKAGES_NANO = " \
    tegra210-flash \
    tegra-nvpmodel \
    tegra-configs-nvstartup \
    tegra-configs-udev \
    jetson-dtbs \
    mtd-utils \
"

IMAGE_INSTALL:append:jetson-nano = "${IMAGE_PACKAGES_NANO}"
IMAGE_INSTALL:append:jetson-nano-emmc = "${IMAGE_PACKAGES_NANO}"
IMAGE_INSTALL:append:jetson-nano-2gb-devkit = "${IMAGE_PACKAGES_NANO}"

IMAGE_INSTALL:append:jetson-tx2 = " \
    tegra186-flash-dry \
    parted \
    gptfdisk \
    fan-startup \
    tegra-nvpmodel \
    tegra-configs-nvstartup \
    tegra-configs-udev \
    tegra-firmware-brcm \
    tegra-brcm-patchram \
    linux-firmware-bcm4354 \
    tegra-firmware-xusb \
    tegra-firmware-rtl8822 \
    bt-scripts \
    jetson-dtbs \
    kernel-module-bcmdhd \
    kernel-module-rtk-btusb \
    kernel-module-rtl8822ce \
"

IMAGE_INSTALL:append:jetson-tx1 = " \
    tegra210-flash-dry \
    parted \
    tegra-nvpmodel \
    tegra-configs-nvstartup \
    tegra-configs-udev \
    tegra-firmware-brcm \
    tegra-brcm-patchram \
    linux-firmware-bcm4354 \
    bt-scripts \
"

IMAGE_INSTALL:remove = "kernel-image-initramfs"
