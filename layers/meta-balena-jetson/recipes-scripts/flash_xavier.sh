#/bin/bash
# L4T BSP version 32.1
# This script was tested using Ubuntu 18.04

BL="Linux_for_Tegra/bootloader"
BSPTAR="l4t-jetson-driver-package-32-1-JAX-TX2"

print_usage() {
    echo "Error: $1"
    echo "***********************************************"
    echo "Flashing steps:"
    echo "1) Put Jetson Xavier board in recovery mode"
    echo "2) Execute: sudo ./flash_xavier <balenaOS.img>"
    echo "***********************************************"
    exit 1
}

replace_file() {
    echo "Replacing $2 with $1"
    if [ -f $2 ]; then
        rm $2
    fi
    cp $1 $2
}

if [ "${USER}" != "root" ]; then
	print_usage "Please run script with sudo"
	exit 1;
fi

if [ ! -x "$(command -v base64)" ]; then
    print_usage "Please install coreutils package"
    exit 1
fi

if [ ! -x "$(command -v wget)" ]; then
    print_usage "Please install wget"
    exit 1
fi

if [ ! -f $1 ]; then
    print_usage "Provided BalenaOS image path does not exist"
    exit 1
fi

if [ 0 -eq $# ]; then
    print_usage "Please provide path to BalenaOS image"
fi;

echo "============================================================================================="
echo "| While packages are being prepared, please take a moment to put the board in recovery mode |"
echo "============================================================================================="

sleep 2s

if [ ! -L "Linux_for_Tegra/jetson-xavier.conf" ]; then
    if [ ! -f "$BSPTAR" ]; then
        echo "L4T release not found... Downloading L4T BSP Release..."
        wget "https://developer.nvidia.com/embedded/dlc/$BSPTAR"
    fi

    echo "Unpacking BSP archive..."
    tar xf "$BSPTAR"

    if [ ! $? ] || [ ! -L "Linux_for_Tegra/jetson-xavier.conf" ]; then
        echo "Could not extract BSP package... Aborting"
        exit 1
    fi
else
    echo "Found L4T directory"
fi


echo "Using BalenaOS image file: $1"

inputimg=$1
name=""

if [ -d parts ]; then
    rm -rf parts
fi;

mkdir parts

for idx in 2 3 4 5 6 7
do
    start=$(parted -s ${inputimg} unit S print | tail -n ${idx} | tr '\n' ' '  | awk '{print $2}')
    size=$(parted -s ${inputimg} unit S print | tail -n ${idx} | tr '\n' ' '  | awk '{print $4}')
    name=$(parted -s ${inputimg} unit S print | tail -n ${idx} | tr '\n' ' '  | awk '{print $6}')

    start=$(echo ${start} | sed 's/s//g')
    size=$(echo ${size} | sed 's/s//g')

    echo "Extracting partition: ${name}...";
    dd if=$1 of="parts/${name}.img" skip=${start} count=${size} bs=512
    sync
done;

mkdir bootfiles
mount parts/bootfiles.img bootfiles/

bootfiles=$(ls "bootfiles/")
for bootfile in ${bootfiles}
do
    replace_bootfile=$(find Linux_for_Tegra -name $bootfile)
    if [ -z "$replace_bootfile" ]; then
        continue;
    fi
    echo "Replacing $replace_bootfile with $bootfile"
    rm $replace_bootfile
    replace_file "bootfiles/$bootfile" $replace_bootfile
done
sync

replace_file bootfiles/flash.xml "$BL/t186ref/cfg/flash_t194_sdmmc.xml"
replace_file bootfiles/tegra194-p2888-0001-p2822-0000-rootA.dtb  Linux_for_Tegra/kernel/dtb/tegra194-p2888-0001-p2822-0000.dtb
sync

umount bootfiles/
rmdir bootfiles

echo "Copying BalenaOS partitions..."
cp -r parts/resin-* Linux_for_Tegra/bootloader/

# at least an empty initrd needs to exist
# for mkbootimg to work
echo "" > "$BL/l4t_initrd.img"

sync
echo "Done"

if [ ! -x "Linux_for_Tegra/flash.sh" ]; then
    echo "flash.sh script not found in Linux_for_Tegra BSP directory... Aborting"
    exit 1
fi

# L4T flasher script appends args to device tree cmdline from many places
sed -i 's/console=ttyTCU0,115200n8 console=tty0/ /g' Linux_for_Tegra/p2972-0000.conf.common
sed -i 's/cmdline+=\"root=\/dev\/${target_rootdev} rw rootwait \"/echo Working/g ' Linux_for_Tegra/flash.sh
sed -i 's/sed -i \x27\/bootargs\/d\x27 temp.dts;/return; /g ' Linux_for_Tegra/flash.sh
cmd="sudo ./flash.sh --no-systemimg jetson-xavier mmcblk0p1"

# tegra flasher script needs to be run from
# whitin its' directory
cd Linux_for_Tegra

echo "Will proceed to flash board.."
eval $cmd

echo "Done flashing Jetson Xavier board! Please wait while the board restarts..."

exit 0
