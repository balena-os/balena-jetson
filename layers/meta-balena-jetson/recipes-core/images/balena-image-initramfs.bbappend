PACKAGE_INSTALL:append = " tegra-firmware-xusb"

# Because of https://github.com/balena-os/balena-jetson/issues/90
# the TX1 does not have a 32.X release currently. Let's decrease
# the kernel size to allow for host extensions support for now.
#PACKAGE_INSTALL:append:jetson-tx1 = " kernel-module-bcmdhd"
PACKAGE_INSTALL:remove:jetson-tx1 = "tegra-firmware-xusb"

PACKAGE_INSTALL:remove:astro-tx2 = " mdraid"
PACKAGE_INSTALL:remove:blackboard-tx2 = " mdraid"
PACKAGE_INSTALL:remove:jetson-tx2-4-gb = " mdraid"
PACKAGE_INSTALL:remove:jetson-tx2 = " mdraid"
PACKAGE_INSTALL:remove:n310-tx2 = " mdraid"
PACKAGE_INSTALL:remove:n510-tx2 = " mdraid"
PACKAGE_INSTALL:remove:orbitty-tx2 = " mdraid"
PACKAGE_INSTALL:remove:spacely-tx2 = " mdraid"

PACKAGE_INSTALL:remove = " initramfs-module-recovery"
