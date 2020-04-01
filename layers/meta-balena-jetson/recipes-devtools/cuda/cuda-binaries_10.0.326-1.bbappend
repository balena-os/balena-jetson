FILESEXTRAPATHS_append := ":${THISDIR}/files"

# This recipe doesn't find the repo in our DEVNET mirror
# for some reason, just copy the file here in "files" directory
SRC_URI = "file://cuda-repo-l4t-10-0-local-10.0.326_1.0-1_arm64.deb "
