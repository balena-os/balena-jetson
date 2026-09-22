# jetson-flash needs this directory to exist in the image
# even if it is empty

FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI:append = " \
        file://50-sample-script \
        file://00-wifi-powersave-disable.conf \
"

do_install:append() {
    # Disable Wi-Fi power save mode to prevent SDIO bus drops
    install -d ${D}${libdir}/NetworkManager/conf.d/
    install -m 0644 ${WORKDIR}/00-wifi-powersave-disable.conf ${D}${libdir}/NetworkManager/conf.d/
}

do_deploy:append() {
    mkdir -p "${DEPLOYDIR}/dispatcher.d/"
    install -m 0755 "${WORKDIR}/50-sample-script" "${DEPLOYDIR}/dispatcher.d/"
}
