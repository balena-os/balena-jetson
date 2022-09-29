FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://uefi_jetson_prebuilt_balena.bin \
    file://BOOTAA64_balena.efi \
"

do_install() {
    install -d ${D}${EFIDIR}
    install -m 0644 ${WORKDIR}/BOOTAA64_balena.efi ${D}${EFIDIR}/${EFI_BOOT_IMAGE}
}


do_deploy:append() {
     install -m 0644 ${WORKDIR}/uefi_jetson_prebuilt_balena.bin ${DEPLOYDIR}/uefi_jetson.bin
     mkdir -p ${DEPLOYDIR}/bootfiles/EFI/BOOT/
     cp ${WORKDIR}/BOOTAA64_balena.efi ${DEPLOYDIR}/bootfiles/EFI/BOOT/BOOTAA64.efi
}

DEPENDS:remove = "nvdisp-init"
