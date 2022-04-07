FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:jetson-xavier-nx-devkit = " \
	file://0030-removable_boot-Reset-if-SD-CARD-not-found-or-loading.patch \
"
