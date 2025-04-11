FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

inherit allarch systemd

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://99-nv-wifibt.rules \
    file://nvwifibt.service \
    file://nvwifibt-pre.sh \
    file://nvwifibt.sh \
    file://nvwifibt-unblock.service \
"

FILES:${PN} = " \
    ${nonarch_base_libdir}/udev/rules.d/99-nv-wifibt.rules \
    ${nonarch_base_libdir}/systemd/nvwifibt.sh \
    ${nonarch_base_libdir}/systemd/nvwifibt-pre.sh \
"

SYSTEMD_SERVICE:${PN} = "nvwifibt.service nvwifibt-unblock.service"

RDEPENDS:${PN} = " bash systemd"

do_install:append() {
    install -d ${D}/${systemd_unitdir}/system
    install -d ${D}/${nonarch_base_libdir}/udev/rules.d
    install -m 644 ${WORKDIR}/99-nv-wifibt.rules ${D}/${nonarch_base_libdir}/udev/rules.d
    install -m 644 ${WORKDIR}/nvwifibt.service ${D}/${systemd_unitdir}/system
    install -m 644 ${WORKDIR}/nvwifibt-unblock.service ${D}/${systemd_unitdir}/system
    install -m 755 ${WORKDIR}/nvwifibt.sh  ${D}/${systemd_unitdir}/
    install -m 755 ${WORKDIR}/nvwifibt-pre.sh  ${D}/${systemd_unitdir}/
}

COMPATIBLE_MACHINE="(jetson-tx1|jetson-tx2)"
