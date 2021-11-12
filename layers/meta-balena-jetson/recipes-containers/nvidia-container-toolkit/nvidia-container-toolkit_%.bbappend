# We don't need to build or install docker-ce and cuda-toolkit
RDEPENDS:${PN} = ""

# Remove this when using Go >= 1.13
GOBUILDFLAGS = "-v ${GO_LDFLAGS}"
