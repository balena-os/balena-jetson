FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

RDEPENDS:${PN} = ""
# Remove this when using Go >= 1.13
GOBUILDFLAGS = "-v ${GO_LDFLAGS}"
