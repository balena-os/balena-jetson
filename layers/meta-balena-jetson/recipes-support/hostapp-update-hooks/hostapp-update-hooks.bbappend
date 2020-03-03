FILESEXTRAPATHS_append := ":${THISDIR}/files"

DEPENDS_${PN}_append_jetson-nano    = " tegra210-flash"

HOSTAPP_HOOKS_append_jetson-nano    = " 99-resin-uboot \
					99-resin-bootfiles-nano \
"

DEPENDS_${PN}_append_jetson-xavier  = " tegra194-flash-dry"

# Xavier does not use u-boot, but for rollbacks to work
# we need to update the resinOS_uEnv.txt file
HOSTAPP_HOOKS_append_jetson-xavier  = " \
    99-resin-uboot \
    99-resin-bootfiles-xavier \
"

DEPENDS_${PM}_append_jetson-tx2 = " tegra186-flash-dry"

HOSTAPP_HOOKS_append_jetson-tx2 = " \
    99-resin-uboot \
    50-resin-bootfiles-jetson-tx2 \
"

HOSTAPP_HOOKS_append_jetson-tx1 = " \
    99-resin-uboot \
    50-resin-bootfiles-jetson-tx1 \
"
