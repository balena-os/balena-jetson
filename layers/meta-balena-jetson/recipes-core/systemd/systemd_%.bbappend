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


do_install_append_jetson-tx1(){
    # Same as for the jetson nano, since both are tegra210
    echo "" > ${D}/${sysconfdir}/systemd/system.conf.d/watchdog.conf
}
