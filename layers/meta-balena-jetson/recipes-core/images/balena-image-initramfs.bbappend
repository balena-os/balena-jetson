PACKAGE_INSTALL:append = " tegra-firmware-xusb"

# Because of https://github.com/balena-os/balena-jetson/issues/90
# the TX1 does not have a 32.X release currently. Let's decrease
# the kernel size to allow for host extensions support for now.
#PACKAGE_INSTALL:append:jetson-tx1 = " kernel-module-bcmdhd"
PACKAGE_INSTALL:append:jetson-xavier-nx-devkit-emmc = " util-linux-blockdev initramfs-module-blockdev"
PACKAGE_INSTALL:append:jetson-xavier-nx-devkit = " util-linux-blockdev initramfs-module-blockdev"

PACKAGE_INSTALL:remove:spacely-tx2 = " mdraid"
