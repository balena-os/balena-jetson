FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	file://drop-in.conf \
"

do_install_append() {
        for systemd_file in ${SYSTEMD_SERVICE_resin-mounts}; do
                install -d ${D}${systemd_unitdir}/system/${systemd_file}.d/
		install -m 0644 drop-in.conf ${D}${systemd_unitdir}/system/${systemd_file}.d/10-after_systemd-sysctl.conf
        done
}
