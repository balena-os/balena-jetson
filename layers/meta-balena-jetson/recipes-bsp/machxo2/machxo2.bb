EXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit allarch systemd

DESCRIPTION = "Recipe for installing FPGA firmware on the srd3-tx2"
LICENSE = "CLOSED"

SRC_URI = " file://machxo2.bin"

RDEPENDS_${PN} = " bash"

S = "${WORKDIR}"

do_install () {
    install -d ${D}/lib/firmware
    install -m 0644 ${WORKDIR}/machxo2.bin ${D}/lib/firmware/machxo2.bin
}

FILES_${PN} += " /lib/firmware/machxo2.bin"

COMPATIBLE_MACHINE = "(srd3-tx2)"
