FILESEXTRAPATHS:prepend := "${THISDIR}/tegra-firmware:"

SRC_URI:append:jetson-tx2 = " \
    file://rtl8822cu_fw \
    file://rtl8822cu_config \
"

do_install:append:jetson-tx2() {
    install -d ${D}${nonarch_base_libdir}
    cp -r ${WORKDIR}/rtl8822cu_* ${D}${nonarch_base_libdir}/firmware/
}
