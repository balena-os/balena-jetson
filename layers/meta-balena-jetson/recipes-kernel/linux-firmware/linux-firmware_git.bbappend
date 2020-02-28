IWLWIFI_FW_MIN_API[8265] = "22"

PACKAGES =+ "${PN}-iwlwifi-9260"
FILES_${PN}-iwlwifi-9260 = " \
    ${nonarch_base_libdir}/firmware/iwlwifi-9260-* \
    "

LICENSE_${PN}-iwlwifi-9260 = "Firmware-iwlwifi_firmware"
RDEPENDS_${PN}-iwlwifi-9260 = "${PN}-iwlwifi-license"
