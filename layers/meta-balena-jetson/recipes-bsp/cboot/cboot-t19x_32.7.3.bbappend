FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "${L4T_URI_BASE}/cboot_src_t19x.tbz2;downloadfilename=cboot_src_t19x-${PV}.tbz2;subdir=${BP}"
SRC_URI:append = "https://developer.nvidia.com/downloads/remack-sdksjetpack-463r32releasev73sourcest186cbootsrct19tbz2;downloadfilename=cboot_src_t19x-${PV}.tbz2;subdir=${BP}"

SRC_URI:append:jetson-xavier-nx-devkit = " \
	file://0030-removable_boot-Reset-if-SD-CARD-not-found-or-loading.patch \
"

SRC_URI:append = " file://0031-tegra194-Set-SD-eMMC-boot-order-as-default-priority.patch "
