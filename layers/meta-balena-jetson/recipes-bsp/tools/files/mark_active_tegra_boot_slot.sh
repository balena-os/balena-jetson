#!/bin/sh

# Ensure reduntant boot is enabled
if /usr/bin/tegra-boot-control -e ; then
    echo "Tegra redundant boot: enabled successfully"
else
    echo "Tegra redundant boot: failed to enable!"
fi;

# If the boot process was
# able to start the rollback service, we can
# mark the current boot as successful
# Othrwise if not marked, the old kernel
# and dtb slots will be used after 3 attempts
# as per https://forums.developer.nvidia.com/t/failed-bootloader-watchdog-recovery/154380/5
if /usr/bin/tegra-boot-control -m ; then
    echo "Tegra redundant boot: marked successful boot"
else
    echo "Tegra redundant boot: failed to record successful boot"
fi

