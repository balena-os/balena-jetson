#!/bin/bash

# Ensure reduntant boot is enabled
if /usr/bin/tegra-boot-control -e ; then
    echo "Tegra redundant boot: enabled successfully"
else
    echo "Tegra redundant boot: failed to enable!"
fi;

# If the boot process was
# able to start the rollback service, we can
# mark the current boot as successful
if /usr/bin/tegra-boot-control -m ; then
    echo "Tegra redundant boot: marked successful boot"

    if /usr/bin/tegra-bootinfo -b ; then
        echo "Tegra redundant boot: recorded successful boot"
    else
        echo "Tegra redundant boot: failed to record successful boot"
    fi
fi
