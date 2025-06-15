FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-proc-dont-trigger-mount-error-with-invalid-options-o.patch \
"
