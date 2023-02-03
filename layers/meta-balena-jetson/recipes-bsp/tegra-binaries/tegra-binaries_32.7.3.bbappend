SRC_URI:remove = "${L4T_URI_BASE}/${L4T_BSP_PREFIX}_Linux_R${L4T_VERSION}_aarch64.tbz2;name=l4t"
SRC_URI:remove = "${L4T_URI_BASE}/secureboot_R${L4T_VERSION}_aarch64.tbz2;downloadfilename=${L4T_BSP_PREFIX}_secureboot_${L4T_VERSION}.tbz2;name=sb"
SRC_URI:append = "https://developer.nvidia.com/downloads/remksjetpack-463r32releasev73t186jetsonlinur3273aarch64tbz2;downloadfilename=Jetson_Linux_R${L4T_VERSION}_aarch64.tbz2;name=l4t \
                  https://developer.nvidia.com/downloads/remsdksjetpack-463r32releasev73t186securebootr3273aarch64tbz2;downloadfilename=${L4T_BSP_PREFIX}_secureboot_${L4T_VERSION}.tbz2;name=sb"
