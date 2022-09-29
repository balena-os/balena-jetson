include balena-image.inc

# TODO: Decrease this 
DEVICE_SPECIFIC_SPACE = "983040"

BALENA_BOOT_PARTITION_FILES:append = " \
    bootfiles/EFI/BOOT/BOOTAA64.efi:/EFI/BOOT/BOOTAA64.efi \
"

#    extlinux/extlinux.conf:/boot/extlinux/extlinux.conf 
#    ${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin:/boot/Image 


check_size() {
    file_path=${1}
    [ -f "${file_path}" ] || bbfatal "Specified path does not exist: ${file_path}"
    file_size=$(ls -l ${file_path} | awk '{print $5}')
    part_size=${2}

    if [ "$file_size" -ge "$part_size" ]; then
        bbfatal "File ${file_path} too big for raw partition!"
    fi;
}

do_image:balenaos-img:jetson-agx-orin-devkit[depends] += " tegra234-flash-dry:do_install"
device_specific_configuration:jetson-agx-orin-devkit() {
    partitions=$(cat ${DEPLOY_DIR_IMAGE}/tegra-binaries/partition_specification234.txt)
    NVIDIA_PART_OFFSET=20480
    START=${NVIDIA_PART_OFFSET}
    for n in ${partitions}; do
      part_name=$(echo $n | cut -d ':' -f 1)
      file_name=$(echo $n | cut -d ':' -f 2)
      part_size=$(echo $n | cut -d ':' -f 3)
      file_path=$(find ${DEPLOY_DIR_IMAGE}/bootfiles -name $file_name)
      END=$(expr ${START} \+ ${part_size} \- 1)
      echo ">>> file: ${file_path}, part: ${part_name}, start: ${START} - size: ${part_size} end: ${END}"
      parted -s ${BALENA_RAW_IMG} unit s mkpart $part_name ${START} ${END}
      if [ ! "$file_name" = "none.bin" ]; then
        check_size ${file_path} $(expr ${part_size} \* 512)
        dd if=$file_path of=${BALENA_RAW_IMG} conv=notrunc seek=${START} bs=512
      fi
      START=$(expr ${END} \+ 1)
    done
} 

