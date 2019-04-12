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
