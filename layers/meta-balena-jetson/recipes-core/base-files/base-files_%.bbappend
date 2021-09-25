FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "\
           file://fstab2 \
"

do_install_append () {
	install -m 0644 ${WORKDIR}/fstab2 ${D}${sysconfdir}/fstab
}
