IMAGE_ROOTFS_MAXSIZE = "12300"
IMAGE_ROOTFS_MAXSIZE_jetson-tx2 = "16400"

PACKAGE_INSTALL_append = " tegra-firmware-xusb"
PACKAGE_INSTALL_append_jetson-tx2 = " kernel-module-bcmdhd"
