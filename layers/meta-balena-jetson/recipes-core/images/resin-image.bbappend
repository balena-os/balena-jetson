include resin-image.inc

IMAGE_FSTYPES_append = " hostapp-ext4"

DEVICE_SPECIFIC_SPACE_jetson-nano = "49152"

do_image_resinos-img_jetson-nano[depends] += " tegra210-flash:do_deploy"
device_specific_configuration_jetson-nano() {
    partitions=$(cat ${DEPLOY_DIR_IMAGE}/tegra-binaries/partition_specification210.txt)
    NVIDIA_PART_OFFSET=2048
    START=${NVIDIA_PART_OFFSET}
    for n in ${partitions}; do
      part_name=$(echo $n | cut -d ':' -f 1)
      file_name=$(echo $n | cut -d ':' -f 2)
      part_size=$(echo $n | cut -d ':' -f 3)
      file_path=$(find ${DEPLOY_DIR_IMAGE}/bootfiles -name $file_name)
      END=$(expr ${START} \+ ${part_size} \- 1)
      parted -s ${RESIN_RAW_IMG} unit s mkpart $part_name ${START} ${END}
      dd if=$file_path of=${RESIN_RAW_IMG} conv=notrunc seek=${START} bs=512
      START=$(expr ${START} \+ ${NVIDIA_PART_OFFSET})
    done
}


# We leave this space way larger than currently
# needed because other larger partitions are
# added from one Jetpack release to another
DEVICE_SPECIFIC_SPACE_jetson-xavier = "270336"

# Binaries are signed and packed into
# a partition and the flaser script
# gets them from there. Can't store them
# raw due to partition alignments which
# trigger checksum mismatches during flash

do_image_resinos-img_jetson-xavier[depends] += " tegra194-flash-dry:do_deploy"
device_specific_configuration_jetson-xavier() {
    START=${RESIN_IMAGE_ALIGNMENT}
    BOOTFILES_FS="xavier-bootfiles.img"
    dd if=/dev/zero of=${WORKDIR}/${BOOTFILES_FS} seek=81920 count=0 bs=1024
    mkfs.vfat -n "bootfiles" -S 512 -F 16 ${WORKDIR}/${BOOTFILES_FS}
    bootfiles=$(cat ${DEPLOY_DIR_IMAGE}/tegra-binaries/partition_specification194.txt)
    for n in ${bootfiles}; do
       part_name=$(echo $n | cut -d ':' -f 1)
       file_name=$(echo $n | cut -d ':' -f 2)
       file_path=$(find ${DEPLOY_DIR_IMAGE}/bootfiles -name $file_name)
       mcopy -n -o -i ${WORKDIR}/${BOOTFILES_FS} -sv ${file_path} ::
    done
    END=$(expr ${START} \+ 81920)
    parted -s ${RESIN_RAW_IMG} unit KiB mkpart "bootfiles" ${START} ${END}
    dd if=${WORKDIR}/${BOOTFILES_FS} of=${RESIN_RAW_IMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${START})
}
