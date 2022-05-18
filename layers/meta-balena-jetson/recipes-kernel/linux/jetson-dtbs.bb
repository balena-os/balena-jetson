FILESEXTRAPATHS:append := ":${THISDIR}/linux-tegra"

DESCRIPTION = "Package for deploying custom dtbs to rootfs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://tegra186-tx2-6.dtb \
	file://tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb \
	file://tegra186-tx2-cti-ASG001-USB3.dtb \
	file://tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb \
	file://tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb \
	file://tegra186-tx2-blackboard.dtb \
	file://tegra186-tx2-cti-ASG001-revG+.dtb \
	file://tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb \
	file://tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb \
	file://tegra210-nano-cti-NGX003.dtb \
	file://tegra210-nano-cti-NGX003-IMX477-2CAM.dtb \
	file://tegra210-nano-cti-NGX004.dtb \
	file://tegra210-p3448-0000-p3449-0000-b00-basler-camera.dtb \
	file://tegra186-tx2-nx-cti-NGX003.dtb \
	file://tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb \
	file://tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb \
"

do_install[depends] += " linux-tegra:do_deploy "

S = "${WORKDIR}"
DTBNAME = "${@os.path.basename(d.getVar('KERNEL_DEVICETREE', True).split()[0])}"

do_install:jetson-tx2() {
	install -d ${D}/boot/
	install -m 0644 ${WORKDIR}/tegra186-tx2-6.dtb ${D}/boot/tegra186-tx2-6.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb ${D}/boot/tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-cti-ASG001-USB3.dtb ${D}/boot/tegra186-tx2-cti-ASG001-USB3.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb ${D}/boot/tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb ${D}/boot/tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-blackboard.dtb ${D}/boot/tegra186-tx2-blackboard.dtb
	install -m 0644 "${DEPLOY_DIR_IMAGE}/${DTBNAME}" "${D}/boot/${DTBNAME}"
	install -m 0644 ${WORKDIR}/tegra186-tx2-cti-ASG001-revG+.dtb ${D}/boot/tegra186-tx2-cti-ASG001-revG+.dtb
}

do_install:jetson-nano() {
	install -d ${D}/boot/
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra210-p3448-0000-p3449-0000-a02.dtb ${D}/boot/tegra210-p3448-0000-p3449-0000-a02.dtb
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra210-p3448-0000-p3449-0000-b00.dtb ${D}/boot/tegra210-p3448-0000-p3449-0000-b00.dtb
	install -m 0644 ${WORKDIR}/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb ${D}/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb
	install -m 0644 ${WORKDIR}/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb ${D}/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb
	install -m 0644 ${WORKDIR}/tegra210-nano-cti-NGX003.dtb ${D}/boot/tegra210-nano-cti-NGX003.dtb
	install -m 0644 ${WORKDIR}/tegra210-nano-cti-NGX004.dtb ${D}/boot/tegra210-nano-cti-NGX004.dtb
	install -m 0644 ${WORKDIR}/tegra210-p3448-0000-p3449-0000-b00-basler-camera.dtb ${D}/boot/tegra210-p3448-0000-p3449-0000-b00-basler-camera.dtb
}


do_install:jetson-nano-emmc() {
	install -d ${D}/boot/
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra210-p3448-0002-p3449-0000-b00.dtb ${D}/boot/tegra210-p3448-0002-p3449-0000-b00.dtb
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra210-p3448-0002-p3449-0000-a02.dtb  ${D}/boot/tegra210-p3448-0002-p3449-0000-a02.dtb
	install -m 0644 ${WORKDIR}/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb ${D}/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb
	install -m 0644 ${WORKDIR}/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb ${D}/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb
	install -m 0644 ${WORKDIR}/tegra210-nano-cti-NGX003.dtb ${D}/boot/tegra210-nano-cti-NGX003.dtb
	install -m 0644 ${WORKDIR}/tegra210-nano-cti-NGX003-IMX477-2CAM.dtb ${D}/boot/tegra210-nano-cti-NGX003-IMX477-2CAM.dtb
	install -m 0644 ${WORKDIR}/tegra210-nano-cti-NGX004.dtb ${D}/boot/tegra210-nano-cti-NGX004.dtb
}

do_install:jetson-nano-2gb-devkit() {
	install -d ${D}/boot/
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra210-p3448-0003-p3542-0000.dtb  ${D}/boot/tegra210-p3448-0003-p3542-0000.dtb
}

do_install:jetson-tx2-nx-devkit() {
	install -d ${D}/boot/
	install -m 0644 ${DEPLOY_DIR_IMAGE}/tegra186-p3636-0001-p3509-0000-a01.dtb ${D}/boot/tegra186-p3636-0001-p3509-0000-a01.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-nx-cti-NGX003.dtb  ${D}/boot/tegra186-tx2-nx-cti-NGX003.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb  ${D}/boot/tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb  ${D}/boot/tegra186-tx2-nx-cti-NGX003-IMX477-2CAM.dtb
	install -m 0644 ${WORKDIR}/tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb  ${D}/boot/tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb
}

FILES:${PN}:jetson-tx2 += " \
	/boot/tegra186-tx2-6.dtb \
	/boot/tegra186-tx2-cti-ASG006-IMX274-6CAM.dtb \
	/boot/tegra186-tx2-cti-ASG001-USB3.dtb \
	/boot/tegra186-tx2-aetina-n510-p3489-0888-a00-00-base.dtb \
	/boot/tegra186-tx2-aetina-n310-p3489-0888-a00-00-base.dtb \
	/boot/tegra186-tx2-blackboard.dtb \
	/boot/tegra186-quill-p3310-1000-c03-00-base.dtb \
	/boot/tegra186-tx2-cti-ASG001-revG+.dtb \
	/boot/${DTBNAME} \
"


FILES:${PN}:jetson-nano += " \
	/boot/tegra210-p3448-0000-p3449-0000-a02.dtb \
	/boot/tegra210-p3448-0000-p3449-0000-b00.dtb \
	/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb \
	/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb \
	/boot/tegra210-nano-cti-NGX003.dtb \
	/boot/tegra210-nano-cti-NGX004.dtb \
	/boot/tegra210-p3448-0000-p3449-0000-b00-basler-camera.dtb \
"

FILES:${PN}:jetson-nano-emmc += " \
	/boot/tegra210-p3448-0002-p3449-0000-b00.dtb \
	/boot/tegra210-p3448-0002-p3449-0000-a02.dtb \
	/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b.dtb \
	/boot/tegra210-p3448-0002-p3449-0000-b00-jn30b-cam1-flip.dtb \
	/boot/tegra210-nano-cti-NGX003.dtb \
	/boot/tegra210-nano-cti-NGX003-IMX477-2CAM.dtb \
	/boot/tegra210-nano-cti-NGX004.dtb \
"

FILES:${PN}:jetson-nano-2gb-devkit += " \
        /boot/tegra210-p3448-0003-p3542-0000.dtb \
"

FILES:${PN}:jetson-tx2-nx-devkit += " \
	/boot/tegra186-p3636-0001-p3509-0000-a01.dtb \
	/boot/tegra186-tx2-nx-cti-NGX003.dtb \
	/boot/tegra186-tx2-nx-cti-NGX003-IMX219-2CAM.dtb \
	/boot/tegra186-tx2-nx-cti-NGX003-IMX477-2CAM.dtb \
	/boot/tegra186-tx2-nx-cti-NGX003-ARDU-IMX477-2CAM.dtb \
"
