FILESEXTRAPATHS_append := ":${THISDIR}/files"

DEPENDS_${PN}_append_jetson-nano    = " tegra210-flash"

HOSTAPP_HOOKS_append_jetson-nano    = " 99-resin-uboot \
					99-resin-bootfiles-nano \
"

DEPENDS_${PN}_append_jetson-xavier  = " tegra194-flash-dry"

HOSTAPP_HOOKS_append_jetson-xavier  = " 99-resin-bootfiles-xavier"
