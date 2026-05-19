FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0006-common.mk-Add-current-directory-as-git-safe-director.patch"
