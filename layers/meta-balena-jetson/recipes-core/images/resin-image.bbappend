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

RESIN_BOOT_PARTITION_FILES_append_jetson-tx2 = " \
    boot/extlinux.conf:/extlinux/extlinux.conf \
"

NVIDIA_PART_OFFSET_jetson-tx2="4097"
DEVICE_SPECIFIC_SPACE_jetson-tx2="49152"

do_image_resinos-img_jetson-tx2[depends] += " tegra186-flash-dry:do_deploy"

device_specific_configuration_jetson-tx2() {
    partitions=$(cat ${DEPLOY_DIR_IMAGE}/tegra-binaries/partition_specification186.txt)
    start=${NVIDIA_PART_OFFSET}
    for n in ${partitions}; do
        part_name=$(echo $n | cut -d ':' -f 1)
        file_name=$(echo $n | cut -d ':' -f 2)
        part_size=$(echo $n | cut -d ':' -f 3)
        file_path=$(find ${DEPLOY_DIR_IMAGE}/bootfiles -name $file_name)
        end=$(expr ${start} \+ ${part_size} \- 1)
        parted -s ${RESIN_RAW_IMG} unit s mkpart $part_name ${start} ${end}
        dd if=$file_path of=${RESIN_RAW_IMG} conv=notrunc seek=${start} bs=512
        start=$(expr ${end} \+ 1)
    done

    idx=1
    while [ $idx -lt 24];
    do
        # parted sets type to Linux Filesystem (type 20 at 0x400) regardless of msftdata
        # flag toggle, therefore use sfdisk to set the partition type. Needs to be
        # done after all partitions are added
        echo 'type=11' | sfdisk -N ${idx} ${RESIN_RAW_IMG}
        idx=$(expr ${idx} \+ 1)
    done

    # another issue with parted is incorrect number of partition entries
    # in gpt header at position 0x250. Fix gpt header so it can be interpreted
    # by the first bootloaders
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${RESIN_RAW_IMG}
    x
    l
    28
    r
    w
EOF
}
