FILESEXTRAPATHS_append := "${THISDIR}/${PN}"

# We use this for the Jetson Nano to HUP from
# any older release that doesn't boot using UUID but PARTUUID
SRC_URI_append = "file://os-helpers-fs-Fallback-to-labels-and-partlabels-if-s.patch"
