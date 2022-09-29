FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://uefi_jetson_prebuilt_balena.bin \
    file://BOOTAA64_balena.efi \
"

do_deploy:append() {
     install -d ${DEPLOYDIR}
     install -m 0644 ${S}/uefi_jetson_prebuilt_balena.bin ${DEPLOYDIR}/uefi_jetson.bin
     mkdir -p ${DEPLOYDIR}/bootfiles/EFI/BOOT/
     cp ${S}/BOOTAA64_balena.efi ${DEPLOYDIR}/bootfiles/EFI/BOOT/BOOTAA64.efi
}
