# jetson-flash needs this directory to exist in the image
# even if it is empty

FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI:append = " \
        file://50-sample-script \
"

do_deploy:append() {
    mkdir -p "${DEPLOYDIR}/dispatcher.d/"
    install -m 0755 "${WORKDIR}/50-sample-script" "${DEPLOYDIR}/dispatcher.d/"
}
