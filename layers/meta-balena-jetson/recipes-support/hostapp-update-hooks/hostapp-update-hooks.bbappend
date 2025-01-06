FILESEXTRAPATHS:append := ":${THISDIR}/files"

DEPENDS:append:jetson-nano    = " tegra210-flash"

HOSTAPP_HOOKS:append:jetson-nano    = " 99-resin-uboot \
					99-resin-bootfiles-nano \
"

DEPENDS:append:jetson-nano-emmc = " tegra210-flash"

HOSTAPP_HOOKS:append:jetson-nano-emmc = " 99-resin-uboot \
                                          99-resin-bootfiles-nano \
"

DEPENDS:append:jetson-nano-2gb-devkit    = " tegra210-flash"

HOSTAPP_HOOKS:append:jetson-nano-2gb-devkit = " 99-resin-uboot \
                                                99-resin-bootfiles-nano \
"

DEPENDS:append:jetson-tx2 = " tegra186-flash-dry"

HOSTAPP_HOOKS:append:jetson-tx2 = " \
    99-resin-uboot \
    50-resin-bootfiles-jetson-tx2 \
"

HOSTAPP_HOOKS:append:jetson-tx1 = " \
    99-resin-uboot \
    50-resin-bootfiles-jetson-tx1 \
"
