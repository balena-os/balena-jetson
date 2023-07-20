do_compile:prepend:tegra194() {
    for f in ${S}/bootloader/${NVIDIA_BOARD}/tegra194-*-bpmp-*.dtb;
    do
        if [ $(basename "$f") = "tegra194-a02-bpmp-p2888-a01.dtb" ]; then
            echo "Changing parents for can1 and can2 in file $f"
            for dtnode in can1 can2
            do
                fdtput -t x ${f} "/clocks/clock@$dtnode" "allowed-parents" "121" "5b" "13a" "5e"
            done
         fi
    done
}

