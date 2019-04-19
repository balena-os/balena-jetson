do_install_append() {
    # disable fb console
    rm -rf ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service
}

do_install_append_jetson-nano(){
    # On jetson nano, tegra_wdt_t21x module pings
    # the watchdog internally unless a userspace
    # daemon like systemd opens /dev/watchdog.
    #
    # If device is closed, even by using magic close 'V',
    # the module will trigger reboot thinking that the keepalive
    # daemon died.
    # Prevent systemd from opening device and let the module handle
    # keepalive internally.
    echo "" > ${D}/${sysconfdir}/systemd/system.conf.d/watchdog.conf
}
