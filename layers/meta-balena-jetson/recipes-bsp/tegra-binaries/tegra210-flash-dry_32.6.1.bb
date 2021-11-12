SUMMARY = "Create signed and encrypted binaries for Jetson TX1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${BALENA_COREBASE}/COPYING.Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

IMAGE_ROOTFS_ALIGNMENT ?= "4"

DEPENDS = " \
    coreutils-native \
    virtual/bootloader \
    virtual/kernel \
    tegra-binaries \
    tegra-bootfiles \
    tegra210-flashtools-native \
    dtc-native \
    "

inherit deploy python3native perlnative

SRC_URI = " \
    file://resinOS-flash210-tx1.xml \
    file://partition_specification210_tx1.txt \
    file://bldtb_t210_tx1.bindiff \
    file://boot0_t210_tx1.bindiff \
    "

KERNEL_DEVICETREE:jetson-tx1 = "${DEPLOY_DIR_IMAGE}/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb"
DTBFILE ?= "${@os.path.basename(d.getVar('KERNEL_DEVICETREE', True).split()[0])}"

IMAGE_TEGRAFLASH_FS_TYPE ??= "ext4"
IMAGE_TEGRAFLASH_ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${IMAGE_TEGRAFLASH_FS_TYPE}"

BL_IS_CBOOT = "${@'1' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else '0'}"

LDK_DIR = "${TMPDIR}/work-shared/L4T-${SOC_FAMILY}-${PV}-${PR}/Linux_for_Tegra"
B = "${WORKDIR}/build"
S = "${WORKDIR}"
LNXFILE="u-boot.bin"
BINARY_INSTALL_PATH = "/opt/tegra-binaries"

tegraflash_roundup_size() {
    local actsize=$(stat -L -c "%s" "$1")
    local blks=$(expr \( $actsize + 4095 \) / 4096)
    expr $blks \* 4096
}

BOOTFILES=" \
    eks.img \
    nvtboot_recovery.bin \
    nvtboot.bin \
    nvtboot_cpu.bin \
    warmboot.bin \
    rp4.blob \
    sc7entry-firmware.bin \
"

do_configure() {
    local destdir="${WORKDIR}/tegraflash"
    local f
    PATH="${STAGING_BINDIR_NATIVE}/tegra210-flash:${PATH}"
    rm -rf "${WORKDIR}/tegraflash"
    mkdir -p "${WORKDIR}/tegraflash"
    oldwd=`pwd`
    cd "${WORKDIR}/tegraflash"
    ln -s "${STAGING_DATADIR}/tegraflash/${MACHINE}.cfg" .
    cp "${DEPLOY_DIR_IMAGE}/${LNXFILE}" ./${LNXFILE}
    cp "${DEPLOY_DIR_IMAGE}/${DTBFILE}" ./${DTBFILE}
    ln -s "${STAGING_DATADIR}/tegraflash/board_config_${MACHINE}.xml" .
    boardcfg=board_config_${MACHINE}.xml


    if [ -n "${KERNEL_ARGS}" ]; then
        fdtput -t s ./${DTBFILE} /chosen bootargs "${KERNEL_ARGS}"
    else
        fdtput -d ./${DTBFILE} /chosen bootargs
    fi

    for f in ${BOOTFILES}; do
        cp "${STAGING_DATADIR}/tegraflash/$f" .
    done

    # In 32.3.1 we get these from their own packages and no longer
    # from flashtools native (BSP archive)
    ln -s "${DEPLOY_DIR_IMAGE}/cboot-${MACHINE}.bin" ./cboot.bin
    ln -sf "${DEPLOY_DIR_IMAGE}/tos-${MACHINE}.img" ./tos-mon-only.img

    ln -s ${STAGING_BINDIR_NATIVE}/tegra210-flash .
    mkdir -p ${DEPLOY_DIR_IMAGE}/bootfiles

    # tegraflash.py script will sign all binaries
    # mentioned for signing in flash.xml.in
    sed -i -e "s/\[DTBNAME\]/${DTBFILE}/g" ${WORKDIR}/partition_specification210_tx1.txt
    cp ${WORKDIR}/resinOS-flash210-tx1.xml flash.210.in

    # prep env for tegraflash
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra210-flash/${SOC_FAMILY}-flash-helper.sh ./
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra210-flash/tegraflash.py ./
    ln -sf ${STAGING_BINDIR_NATIVE}/tegra210-flash/
    rm -rf signed

    local destdir="$1"
    local gptsize="$2"
    local ebtsize=$(tegraflash_roundup_size cboot.bin)
    local nvcsize=$(tegraflash_roundup_size nvtboot.bin)
    local tbcsize=$(tegraflash_roundup_size nvtboot_cpu.bin)
    local dtbsize=$(tegraflash_roundup_size ${DTBFILE})
    local bpfsize=$(tegraflash_roundup_size sc7entry-firmware.bin)
    local wb0size=$(tegraflash_roundup_size warmboot.bin)
    local tossize=$(tegraflash_roundup_size tos-mon-only.img)

    # flash.xml comes with placeholders for partition
    # names and binaries to be signed
    cat "flash.210.in" | sed -e "s,EBTFILE,cboot.bin," \
        -e "s,EBTFILE,cboot.bin," -e"s,EBTSIZE,$ebtsize," \
        -e "/NCTFILE/d" -e"s,NCTTYPE,data," \
        -e "/SOSFILE/d" \
        -e "s,NXC,NVC," -e"s,NVCTYPE,bootloader," -e"s,NVCFILE,nvtboot.bin," \
        -e "s,MPBTYPE,data," -e"/MPBFILE/d" \
        -e "s,MBPTYPE,data," -e"/MBPFILE/d" \
        -e "s,BXF,BPF," -e"s,BPFFILE,sc7entry-firmware.bin," \
        -e "/BPFDTB-FILE/d" \
        -e "s,WX0,WB0," -e"s,WB0TYPE,WB0," -e"s,WB0FILE,warmboot.bin," \
        -e "s,TXS,TOS," -e"s,TOSFILE,tos-mon-only.img," \
        -e "s,EXS,EKS," -e"s,EKSFILE,eks.img," \
        -e " s,DTBFILE,${DTBFILE}," \
        -e " s,LNXFILE,${LNXFILE}," \
        -e "s,FBTYPE,data," -e"/FBFILE/d" \
        -e "s,DXB,DTB," \
        -e "s,TXC,TBC," -e"s,TBCTYPE,bootloader," -e"s,TBCFILE,nvtboot_cpu.bin," \
        -e "s,PPTSIZE,16896," \
        > ./flash.xml

    # Disable cboot logo
    dd if=/dev/zero of=./bmp.blob count=1 bs=70


    # Need to switch back to default values from flashing, otherwise bootloader dtb offset inside boot0.img will
    # change and will generate signature failure in MB2.
    bldtbdtsname="/home/acostach/work/xavier_nx/balena-jetson/build_tx1/tmp/work-shared/jetson-tx1/kernel-source/arch/arm64/boot/dts/../../../../nvidia/platform/t210/jetson/kernel-dts/tegra210-jetson-tx1-p2597-2180-a01-devkit.dts"

    # Do not overide this hardcoded dtb for carrier boards, this is used for bldtb in boot0.img
    fdtput -t s ./${DTBFILE} / "nvidia,dtsfilename" $bldtbdtsname


    # Sign binaries
    python3 tegraflash.py --bl cboot.bin --bct ${MACHINE}.cfg --odmdata ${ODMDATA} --bldtb ${DTBFILE} --applet nvtboot_recovery.bin --boardconfig $boardcfg --cfg flash.xml --chip 0x21 --cmd "sign" ${BOOTFILES} --keep & \
    export _PID=$! ; wait ${_PID} || true

    rm -rf ${DEPLOY_DIR_IMAGE}/bootfiles/*

    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/u-boot.bin.encrypt seek=576 count=32 bs=1 conv=notrunc
    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/u-boot.bin.encrypt seek=1712 skip=32 count=32 bs=1 conv=notrunc
    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/u-boot.bin.encrypt seek=501520 skip=64 count=16 bs=1 conv=notrunc
    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/u-boot.bin.encrypt seek=530416 skip=80 count=32 bs=1 conv=notrunc
    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb.encrypt seek=272 skip=112 count=32 bs=1 conv=notrunc
    dd if=${WORKDIR}/bldtb_t210_tx1.bindiff of=${_PID}/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb.encrypt seek=1232 skip=144 count=64 bs=1 conv=notrunc

    # These will be used for boot0.img and flashable image
    cp -r -L ${_PID}/*.encrypt ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp -r -L ${_PID}/*.hash ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp -r -L ${_PID}/*.bin ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp -r -L ${_PID}/*.bct ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp -r -L ${_PID}/*.blob ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp -r -L ${_PID}/*.img ${DEPLOY_DIR_IMAGE}/bootfiles/
    cp ${WORKDIR}/partition_specification210_tx1.txt ${DEPLOY_DIR_IMAGE}/bootfiles/

    rm -rf ${_PID}

    cp ${DEPLOY_DIR_IMAGE}/${DTBFILE} ${DEPLOY_DIR_IMAGE}/bootfiles/

    # Currently this is the most complicated hw/sw partitions combination,
    # because BFS0 and BFS1 structure from boot0.img, version and nonces must
    # match the KFS0 and KFS1 ones from the partitions in mmcblk0.
    curr=0
    for i in {1..64}; do
        dd if=${DEPLOY_DIR_IMAGE}/bootfiles/jetson-tx1.bct of=boot0.img bs=1 seek=$curr conv=notrunc
        curr=$(expr $curr \+ 16384)
    done

    curr=784
    for i in {1..64}; do
        dd if=${DEPLOY_DIR_IMAGE}/bootfiles/jetson-tx1.bct.hash of=boot0.img bs=1 seek=$curr conv=notrunc
        curr=$(expr $curr \+ 16384)
    done

    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/cboot.bin.encrypt of=boot0.img bs=1 seek=2801664 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/cboot.bin.hash of=boot0.img bs=1 seek=2801944 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/flash.xml.bin of=boot0.img bs=1 seek=1425408 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/nvtboot.bin of=boot0.img bs=1 seek=1048576 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/nvtboot.bin.encrypt of=boot0.img bs=1 seek=1048576 conv=notrunc

    curr=9036
    add=300
    for i in {1..128}; do
        dd if=${DEPLOY_DIR_IMAGE}/bootfiles/nvtboot.bin.hash of=boot0.img bs=1 seek=$curr conv=notrunc
        curr=$(expr $curr \+ $add)

        if [[ $add -eq 16084 ]]; then
           add=300;
        elif [[ $add -eq 300 ]]; then
           add=16084
        fi
    done

    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/nvtboot_cpu.bin.encrypt of=boot0.img bs=1 seek=1556480 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/nvtboot_cpu.bin.hash of=boot0.img bs=1 seek=1556760 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/sc7entry-firmware.bin.encrypt of=boot0.img bs=1 seek=3932160 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/sc7entry-firmware.bin.hash of=boot0.img bs=1 seek=3932440 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb.encrypt of=boot0.img bs=1 seek=1753088 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb.hash of=boot0.img bs=1 seek=1753368 conv=notrunc

    # Below sb dtb blob does not get generated in the yocto build during signing, however it seems that we can boot without it for now
    #dd if=${DEPLOY_DIR_IMAGE}/bootfiles/tegra210-jetson-tx1-p2597-2180-a01-devkit.dtb.sb of=boot0.img bs=1 seek=1754112 conv=notrunc

    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/warmboot.bin.encrypt of=boot0.img bs=1 seek=3801088 conv=notrunc
    dd if=${DEPLOY_DIR_IMAGE}/bootfiles/warmboot.bin.hash of=boot0.img bs=1 seek=3801360 conv=notrunc
    dd if=/dev/zero of=boot0.img bs=1 seek=4194303 count=1 conv=notrunc

    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img seek=1168 count=16 bs=1 conv=notrunc
    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img seek=1232 skip=16 count=16 bs=1 conv=notrunc
    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img skip=32 seek=1425408 count=1632 bs=1 conv=notrunc
    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img skip=1664 seek=1427503 count=1489 bs=1 conv=notrunc
    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img skip=3153 seek=1753360 count=32 bs=1 conv=notrunc
    dd if=${WORKDIR}/boot0_t210_tx1.bindiff of=boot0.img skip=3185 seek=1754320 count=32 bs=1 conv=notrunc

    # This goes to mmcblk0boot0
    cp boot0.img ${DEPLOY_DIR_IMAGE}/bootfiles/

}

do_install() {
    install -d ${D}/${BINARY_INSTALL_PATH}
    cp -r ${DEPLOY_DIR_IMAGE}/bootfiles/* ${D}/${BINARY_INSTALL_PATH}/
    cp ${WORKDIR}/partition_specification210_tx1.txt ${D}/${BINARY_INSTALL_PATH}/
}

do_deploy() {
    rm -rf ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
    mkdir -p ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
    cp -r ${D}/${BINARY_INSTALL_PATH}/* ${DEPLOYDIR}/$(basename ${BINARY_INSTALL_PATH})
}

FILES:${PN} += "${BINARY_INSTALL_PATH}"

INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

do_install[nostamp] = "1"
do_deploy[nostamp] = "1"
do_configure[nostamp] = "1"

do_configure[depends] += " virtual/bootloader:do_deploy"
do_configure[depends] += " tegra-binaries:do_preconfigure"
do_configure[depends] += " virtual/kernel:do_deploy"
do_configure[depends] += " cboot:do_deploy"
do_configure[depends] += " tos-prebuilt:do_deploy"
do_populate_lic[depends] += " tegra-binaries:do_unpack"

addtask do_deploy before do_package after do_install

COMPATIBLE_MACHINE = "jetson-tx1"
