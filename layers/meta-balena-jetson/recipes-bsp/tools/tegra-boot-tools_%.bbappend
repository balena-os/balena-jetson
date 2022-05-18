FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# libuuid was split from the main
# util-linux later, after Dunfell
DEPENDS:remove = "util-linux-libuuid"
DEPENDS:append = " util-linux"

SRC_URI += " \
	file://mark_active_tegra_boot_slot.sh \
	file://mark-active-slot.service \
"

# Once redundant boot is enabled, each boot
# needs to be marked as successful once
# the system is up to prevent the tegra
# bootloaders from decrementing boot count
# and reverting to the previous slot. If
# redundant boot is disabled, default slot _a
# is used.
SYSTEMD_PACKAGES += " ${PN}"
SYSTEMD_SERVICE:${PN} += " mark-active-slot.service"

# Upon rollback to a release that does not have
# this feature implemented, the _a slots will
# be used by default, without changing behavior.
do_install:append() {
    install -m 0755 ${WORKDIR}/mark_active_tegra_boot_slot.sh ${D}${bindir}/
    install -m 0644 ${WORKDIR}/mark-active-slot.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += " \
    /lib/systemd/system/mark-active-slot.service \
"
