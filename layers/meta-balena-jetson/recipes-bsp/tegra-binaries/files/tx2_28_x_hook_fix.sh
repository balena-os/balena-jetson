#!/bin/sh

set -o errexit

flash() {
    for line in $(cat $1); do
        part_name=$(echo $line | cut -d ':' -f 1)
        file_name=$(echo $line | cut -d ':' -f 2)

        dd oflag=dsync if="/opt/tegra-binaries/$update_dir/$file_name" of="/dev/disk/by-partlabel/$part_name"
    done
}

#!/bin/sh

set -o errexit

DURING_UPDATE=${DURING_UPDATE:-0}
num_parts=$(sfdisk -l /dev/mmcblk0 | grep mmcblk0p | wc -l)

# If rolling back from a 32.x system, we need
# to rework the layout as it is expected by L4T 28.x
# tegra firmware
if [ "16" -ne ${num_parts} ]; then
    for (( i=1; i <= ${num_parts}; ++i ))
    do
        if sfdisk --part-label /dev/mmcblk0 ${i} | grep -q "resin"; then
           echo "Keeping BalenaOS partition ${i}"
        else
           sfdisk --delete /dev/mmcblk0 ${i} || true
        fi
    done

    start="8192"
    sectors="8191"
    partitions=$(cat /opt/tegra-binaries/partition_specification.txt)
    i=1;
    for n in ${partitions}; do
        part_name=$(echo ${n} | cut -d ":" -f 1)
        file_name=$(echo ${n} | cut -d ":" -f 2)
        # In older OS releases we don't have parted, only fdisk and sfdisk
        sed -e "s/\s*\([\+0-9a-zA-Z]*\).*/\1/" << EOF | fdisk /dev/mmcblk0 || true
        n
        ${i}
        ${start}
        +${sectors}
        w
EOF
        sfdisk --part-label /dev/mmcblk0 ${i} ${part_name} || true
        ((i=i+1))
        dd if=/opt/tegra-binaries/${file_name} of=/dev/mmcblk0 conv=notrunc seek=${start}
        start=$(expr ${start} \+ ${sectors} \+ 1)
    done

    # Ensure MBR has 16 partitions
    sed -e "s/\s*\([\+0-9a-zA-Z]*\).*/\1/" << EOF | fdisk /dev/mmcblk0 || true
    x
    l
    16
    r
    w
EOF

else
    flash "/opt/tegra-binaries/partition_specification.txt"
fi


# Allow write to boot part
echo 0 > /sys/block/mmcblk0boot0/force_ro
dd if=/opt/tegra-binaries/boot0.img of=/dev/mmcblk0boot0 ; sync
echo 1 > /sys/block/mmcblk0boot0/force_ro

sync
