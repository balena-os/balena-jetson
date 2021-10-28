FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# libuuid was split from the main
# util-linux later, after Dunfell
DEPENDS_remove = "util-linux-libuuid"
DEPENDS_append = " util-linux"

SRC_URI_append = " \
	file://0001-switch-retry-count-to-3.patch \
	file://active_slot_set.conf \
	file://set_active_tegra_boot_slot.sh \
"

# We use a drop-in and use tegra-boot-tools from it
# to mark the current slot as ok to boot from. We
# know it's ok since the service is running, as it
# wouldn't have been if the kernel crashed.

# Upon rollback to a release that does not have
# this feature implemented, the _a slots will
# be used by default.
do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system/rollback-altboot.service.d
    install -m 0644 ${WORKDIR}/active_slot_set.conf ${D}${sysconfdir}/systemd/system/rollback-altboot.service.d/
    install -m 0755 ${WORKDIR}/set_active_tegra_boot_slot.sh ${D}${bindir}/
    sed -i -e 's,@BINDIR@,${bindir},g' \
        -e 's,@BASE_BINDIR@,${base_bindir},g' \
        ${D}${sysconfdir}/systemd/system/rollback-altboot.service.d/active_slot_set.conf
}
