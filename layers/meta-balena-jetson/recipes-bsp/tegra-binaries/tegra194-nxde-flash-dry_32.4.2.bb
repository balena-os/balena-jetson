SUMMARY = "Create flash artifacts without flashing the Jetson NX"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${RESIN_COREBASE}/COPYING.Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

IMAGE_ROOTFS_ALIGNMENT ?= "4"

DEPENDS = " \
    coreutils-native \
    virtual/bootloader \
    virtual/kernel \
    tegra-binaries \
    tegra-bootfiles \
    tegra194-flashtools-native \
    dtc-native \
    "

inherit deploy pythonnative perlnative

SRC_URI = " \
    file://resinOS-flash194_nxde.xml \
    file://partition_specification194_nxde.txt \
    "

KERNEL_DEVICETREE_jetson-xavier-nx-devkit-emmc = "${DEPLOY_DIR_IMAGE}/tegra194-p3668-all-p3509-0000.dtb"
DTBFILE ?= "${@os.path.basename(d.getVar('KERNEL_DEVICETREE', True).split()[0])}"
LNXSIZE ?= "67108864"

IMAGE_TEGRAFLASH_FS_TYPE ??= "ext4"
IMAGE_TEGRAFLASH_ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${IMAGE_TEGRAFLASH_FS_TYPE}"

LDK_DIR = "${TMPDIR}/work-shared/L4T-${SOC_FAMILY}-${PV}-${PR}/Linux_for_Tegra"
B = "${WORKDIR}/build"
S = "${WORKDIR}"
LNXFILE="${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin"
IMAGE_TEGRAFLASH_KERNEL ?= "${DEPLOY_DIR_IMAGE}/${LNXFILE}"
BINARY_INSTALL_PATH = "/opt/tegra-binaries"

OS_KERNEL_CMDLINE = "${@bb.utils.contains('DEVELOPMENT_IMAGE','1','console=ttyTHS0,115200n8 console=tty1 debug loglevel=7','console=null quiet splash vt.global_cursor_default=0 consoleblank=0',d)}"
ROOTA_ARGS="root=LABEL=resin-rootA ro rootwait rootfstype=ext4 ${KERNEL_ARGS} ${OS_KERNEL_CMDLINE}"
ROOTB_ARGS="root=LABEL=resin-rootB ro rootwait rootfstype=ext4 ${KERNEL_ARGS} ${OS_KERNEL_CMDLINE}"

BOOTFILES = "\
    adsp-fw.bin \
    bmp.blob \
    bpmp_t194.bin \
    camera-rtcpu-rce.img \
    eks.img \
    mb1_t194_prod.bin \
    nvtboot_applet_t194.bin \
    nvtboot_t194.bin \
    preboot_c10_prod_cr.bin \
    mce_c10_prod_cr.bin \
    mts_c10_prod_cr.bin \
    nvtboot_cpu_t194.bin \
    nvtboot_recovery_t194.bin \
    nvtboot_recovery_cpu_t194.bin \
    preboot_d15_prod_cr.bin \
    slot_metadata.bin \
    spe_t194.bin \
    warmboot_t194_prod.bin \
    xusb_sil_rel_fw \
    cbo.dtb \
"

signfile() {
    local destdir="${WORKDIR}/tegraflash"
    local lnxfile="${LNXFILE}"
    local f
    PATH="${STAGING_BINDIR_NATIVE}/tegra186-flash:${PATH}"
    export cbootfilename=cboot_t194.bin

    export BOARDID=${TEGRA_BOARDID}
    export FAB=${TEGRA_FAB}
    export localbootfile=boot.img

    cp ${STAGING_DATADIR}/tegraflash/flashvars .
    . ./flashvars

    export bins=" mb2_bootloader nvtboot_recovery_t194.bin; \
        mts_preboot preboot_c10_prod_cr.bin; \
        mts_mce mce_c10_prod_cr.bin; \
        mts_proper mts_c10_prod_cr.bin; \
        bpmp_fw bpmp_t194.bin; \
        bpmp_fw_dtb tegra194-a02-bpmp-p3668-a00.dtb; \
        spe_fw spe_t194.bin; \
        tlk tos-trusty_t194.img; \
        eks eks.img; \
        bootloader_dtb ${DTBFILE}"

    cat flash.xml.in | sed \
        -e"s,LNXFILE,${localbootfile}," -e"s,LNXSIZE,${LNXSIZE}," \
        -e"s,TEGRABOOT,nvtboot_t194.bin," \
        -e"s,MTSPREBOOT,preboot_c10_prod_cr.bin," \
        -e"s,MTS_MCE,mce_c10_prod_cr.bin," \
        -e"s,MTSPROPER,mts_c10_prod_cr.bin," \
        -e"s,MB1FILE,mb1_t194_prod.bin," \
        -e"s,BPFFILE,bpmp_t194.bin," \
        -e"s,BPFDTB_FILE,tegra194-a02-bpmp-p3668-a00.dtb," \
        -e"s,TBCFILE,$cbootfilename," \
        -e"s,TBCDTB-FILE,${DTBFILE}," \
        -e"s,CAMERAFW,camera-rtcpu-rce.img," \
        -e"s,SPEFILE,spe_t194.bin," \
	-e"s,VERFILE,bsp_version," \
        -e"s,WB0BOOT,warmboot_t194_prod.bin," \
        -e"s,TOSFILE,tos-trusty_t194.img," \
        -e"s,EKSFILE,eks.img," \
        -e"s, DTB_FILE, ${DTBFILE}," \
        -e"s,CBOOTOPTION_FILE,cbo.dtb," \
        -e"s,RECNAME,recovery," -e"s,RECSIZE,66060288," -e"s,RECDTB-NAME,recovery-dtb," -e"s,BOOTCTRLNAME,kernel-bootctrl," \
        -e"/RECFILE/d" -e"/RECDTB-FILE/d" -e"/BOOTCTRL-FILE/d" \
        > $destdir/flash.xml


     tegraflashpy=$(which tegraflash.py)

     python $tegraflashpy --bl nvtboot_recovery_cpu_t194.bin \
     --sdram_config tegra194-mb1-bct-memcfg-p3668-0001-a00.cfg,tegra194-memcfg-sw-override.cfg  \
     --odmdata 0xB8190000 \
     --applet mb1_t194_prod.bin \
     --cmd "sign" \
     --soft_fuses tegra194-mb1-soft-fuses-l4t.cfg  \
     --cfg flash.xml \
     --chip 0x19 \
     --device_config tegra19x-mb1-bct-device-qspi-p3668.cfg \
     --misc_cold_boot_config tegra194-mb1-bct-misc-l4t.cfg \
     --misc_config tegra194-mb1-bct-misc-flash.cfg \
     --pinmux_config tegra19x-mb1-pinmux-p3668-a01.cfg \
     --gpioint_config tegra194-mb1-bct-gpioint-p3668-0001-a00.cfg \
     --pmic_config tegra194-mb1-bct-pmic-p3668-0001-a00.cfg \
     --pmc_config tegra19x-mb1-padvoltage-p3668-a01.cfg \
     --prod_config tegra19x-mb1-prod-p3668-0001-a00.cfg \
     --scr_config tegra194-mb1-bct-scr-cbb-mini-p3668.cfg \
     --scr_cold_boot_config tegra194-mb1-bct-scr-cbb-mini-p3668.cfg \
     --br_cmd_config tegra194-mb1-bct-reset-p3668-0001-a00.cfg \
     --dev_params tegra194-br-bct-qspi.cfg \
     --bin "${bins}"
}

do_configure() {
    local destdir="${WORKDIR}/tegraflash"
    local lnxfile="${LNXFILE}"
    local f
    PATH="${STAGING_BINDIR_NATIVE}/tegra186-flash:${PATH}"
    rm -rf "${WORKDIR}/tegraflash"
    mkdir -p "${WORKDIR}/tegraflash"
    oldwd=`pwd`
    cd "${WORKDIR}/tegraflash"
    ln -sf "${STAGING_DATADIR}/tegraflash/bsp_version" .
    ln -s "${STAGING_DATADIR}/tegraflash/${MACHINE}.cfg" .
    ln -s "${STAGING_DATADIR}/tegraflash/${MACHINE}-override.cfg" .
    ln -s "${DEPLOY_DIR_IMAGE}/cboot-${MACHINE}.bin" ./cboot_t194.bin
    ln -s "${DEPLOY_DIR_IMAGE}/tos-${MACHINE}.img" ./tos-trusty_t194.img

    mkdir -p ${DEPLOY_DIR_IMAGE}/bootfiles
    cp ./cboot_t194.bin ${DEPLOY_DIR_IMAGE}/bootfiles/

    for f in ${BOOTFILES}; do
        ln -s "${STAGING_DATADIR}/tegraflash/$f" .
        cp "${STAGING_DATADIR}/tegraflash/$f" ${DEPLOY_DIR_IMAGE}/bootfiles/
    done

    cp ${STAGING_DATADIR}/tegraflash/flashvars .
    . ./flashvars

    for f in ${STAGING_DATADIR}/tegraflash/tegra19[4x]-*.cfg; do
        ln -s $f .
        cp $f ${DEPLOY_DIR_IMAGE}/bootfiles/
    done

    for f in ${STAGING_DATADIR}/tegraflash/tegra194-*-bpmp-*.dtb; do
        ln -s $f .
        cp $f ${DEPLOY_DIR_IMAGE}/bootfiles/
    done

    if [ -n "${NVIDIA_BOARD_CFG}" ]; then
        ln -s "${STAGING_DATADIR}/tegraflash/board_config_${MACHINE}.xml" .
        boardcfg=board_config_${MACHINE}.xml
    else
        boardcfg=
    fi
    export boardcfg


    ln -s ${STAGING_BINDIR_NATIVE}/tegra186-flash .

    cp "${DEPLOY_DIR_IMAGE}/${DTBFILE}" ./${DTBFILE}

    # TODO: Do the A/B signed dtbs
    #cp ./${DTBFILE} ./tegra194-p2888-0001-p2822-0000-rootA.dtb
    #cp ./${DTBFILE} ./tegra194-p2888-0001-p2822-0000-rootB.dtb

    # Add rootA/rootB and save as separate dtbs to be used when
    # switching partitions
    bootargs="`fdtget ./${DTBFILE} /chosen bootargs 2>/dev/null`"
    fdtput -t s ./${DTBFILE} /chosen bootargs "$bootargs ${ROOTA_ARGS} shell"

    # TODO: Do the A/B signed dtbs. This implies changing the XML and partition template too.
    #fdtput -t s ./tegra194-p2888-0001-p2822-0000-rootB.dtb /chosen bootargs "$bootargs ${ROOTB_ARGS}"
    #fdtput -t s ./tegra194-p2888-0001-p2822-0000-rootB.dtb /chosen bootargs "$bootargs ${ROOTB_ARGS}"

    # Make bootable image from kernel and sign it
    cp ${DEPLOY_DIR_IMAGE}/${LNXFILE} ${LNXFILE}
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra186-flash/mkbootimg ./

    # mkbootimg really needs initrd, even if empty
    touch initrd
    ./mkbootimg --kernel ${LNXFILE} --ramdisk initrd --board mmcblk0p1 --output boot.img

    # prepare flash.xml.in to be used in signing
    cp ${WORKDIR}/resinOS-flash194_nxde.xml flash.xml.in

    # prep env for tegraflash
    rm -f ./slot_metadata.bin
    cp ${STAGING_DATADIR}/tegraflash/slot_metadata.bin ./
    mkdir ./rollback

    ln -sf ${STAGING_BINDIR_NATIVE}/tegra186-flash/rollback_parser.py ./rollback/
    ln -snf ${STAGING_DATADIR}/nv_tegra/rollback/t${@d.getVar('NVIDIA_CHIP')[2:]}x ./rollback/
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra186-flash/BUP_generator.py ./
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra186-flash/${SOC_FAMILY}-flash-helper.sh ./
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra186-flash/tegraflash.py ./

    # bup is based on the rootfs, which is not built at this point
    # not using it for the moment
    # sed -e 's,^function ,,' ${STAGING_BINDIR_NATIVE}/tegra186-flash/l4t_bup_gen.func > ./l4t_bup_gen.func
    rm -rf signed

    # Sign all tegra bins
    signfile

    # TODO: Do the A/B dtbs
    #signfile " tegra194-p2888-0001-p2822-0000-rootA.dtb"
    #signfile " tegra194-p2888-0001-p2822-0000-rootB.dtb"

    # Needed to embedd plain initramfs kernel and dtb to main image
    cp $localbootfile ${DEPLOY_DIR_IMAGE}/bootfiles/Image

    # TODO: Do the A/B dtbs
    #cp -r tegra194-p2888-0001-p2822-0000-root*.dtb ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp ${WORKDIR}/resinOS-flash194_nxde.xml ${DEPLOY_DIR_IMAGE}/bootfiles/flash.xml
    cp -r signed/* ${DEPLOY_DIR_IMAGE}/bootfiles/

    # TODO: Do the A/B dtbs
    #cp -r tegra194-p2888-0001-p2822-0000-root*_sigheader.dtb.encrypt ${DEPLOY_DIR_IMAGE}/bootfiles/
    dd if=/dev/zero of="${DEPLOY_DIR_IMAGE}/bootfiles/bmp.blob" bs=1K count=70
}


do_install() {
    install -d ${D}/${BINARY_INSTALL_PATH}
    cp -r ${S}/tegraflash/signed/* ${D}/${BINARY_INSTALL_PATH}
    # signed boot.img isn't needed in rootfs
    rm ${D}/${BINARY_INSTALL_PATH}/boot*im* || true

    # TODO: Do the A/B dtbs
    #cp ${S}/tegraflash/tegra194-p2888-0001-p2822-0000-rootA.dtb ${D}/${BINARY_INSTALL_PATH}/
    cp ${WORKDIR}/partition_specification194_nxde.txt ${D}/${BINARY_INSTALL_PATH}/
    #cp -r ${S}/tegraflash/tegra194-p2888-0001-p2822-0000-root*sigheader.dtb.encrypt ${D}/${BINARY_INSTALL_PATH}
    # When generating image, this will be default dtb containing cmdline with root set to resin-rootA
    #cp ${S}/tegraflash/tegra194-p2888-0001-p2822-0000-rootA_sigheader.dtb.encrypt ${DEPLOY_DIR_IMAGE}/bootfiles/tegra194-p2888-0001-p2822-0000_sigheader.dtb.encrypt
}

do_deploy() {
    rm -rf ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
    mkdir -p ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
    cp -r ${D}/${BINARY_INSTALL_PATH}/* ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
}

FILES_${PN} += "${BINARY_INSTALL_PATH}"

INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

# Binaries copied to DEPLOY_DIR_IMAGE
# to be included in the boot partition
# need to be redeployed on each build
# as this path is not cached
do_install[nostamp] = "1"
do_deploy[nostamp] = "1"
do_configure[nostamp] = "1"

do_configure[depends] += " tegra-binaries:do_preconfigure"
do_configure[depends] += " virtual/kernel:do_deploy \
                           virtual/bootloader:do_deploy \
"
do_configure[depends] += " cboot:do_deploy"
do_configure[depends] += " tos-prebuilt:do_deploy"

do_install[depends] += " virtual/kernel:do_deploy"
do_populate_lic[depends] += "tegra-binaries:do_unpack"

addtask do_deploy before do_package after do_install

COMPATIBLE_MACHINE = "jetson-xavier-nx-devkit-emmc"
