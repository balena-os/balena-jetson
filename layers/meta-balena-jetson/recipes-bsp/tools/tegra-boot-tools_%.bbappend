FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-switch-retry-count-to-1.patch \
	file://active_slot_set.conf \
"

do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system/rollback-altboot.service.d
    install -m 0644 ${WORKDIR}/active_slot_set.conf ${D}${sysconfdir}/systemd/system/rollback-altboot.service.d/
}
