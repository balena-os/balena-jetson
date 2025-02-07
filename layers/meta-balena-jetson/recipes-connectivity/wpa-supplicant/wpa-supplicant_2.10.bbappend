FILESEXTRAPATHS:append := ":${THISDIR}/wpa-supplicant"

# Taken from https://gitlab.archlinux.org/archlinux/packaging/packages/wpa_supplicant/-/commit/f9f28aa84d08297a5bf324d248b882fdb2f98c82
SRC_URI += " \
    file://0009-OpenSSL-Apply-connection-flags-before-reading-certif.patch \
    file://0010-Don-t-upgrade-SSL-security-level-to-1-when-setting-c.patch \
"

do_install:append () {
        echo "openssl_ciphers=DEFAULT@SECLEVEL=0" >> ${D}${sysconfdir}/wpa_supplicant.conf
}
