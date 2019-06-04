FILESEXTRAPATHS_append := ":${THISDIR}/files"

DEPENDS_${PN}_append_jetson-nano = " tegra210-flash"

HOSTAPP_HOOKS_append_jetson-nano = " \
    99-resin-uboot \
    99-resin-bootfiles-nano \
"

DEPENDS_${PM}_append_jetson-tx2 = " tegra186-flash-dry"

HOSTAPP_HOOKS_append_jetson-tx2 = " \
    99-resin-uboot \
    50-resin-bootfiles-jetson-tx2 \
"
