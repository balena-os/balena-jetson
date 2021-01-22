FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

RDEPENDS_${PN} = ""
# Remove this when using Go >= 1.13
GOBUILDFLAGS = "-v ${GO_LDFLAGS}"
