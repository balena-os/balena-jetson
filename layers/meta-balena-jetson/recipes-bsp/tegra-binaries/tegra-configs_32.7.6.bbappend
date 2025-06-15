do_install:append () {
    # Move udev rules into /usr/lib as /etc/udev/rules.d is bind mounted for custom rules
    install -d ${D}${nonarch_base_libdir}/udev/rules.d
    mv ${D}/etc/udev/rules.d/*.rules ${D}${nonarch_base_libdir}/udev/rules.d/
}

FILES:${PN}-udev += "${nonarch_base_libdir}/udev/rules.d"
