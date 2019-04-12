do_install_append() {
    # disable fb console
    rm -rf ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service
}
