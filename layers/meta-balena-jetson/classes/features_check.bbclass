# The Dunfell release renames distro_features_check to features_check
# The meta-tegra layer is currently based on Dunfell
inherit distro_features_check

python() {
    if 'dunfell' in d.getVar('DISTRO_CODENAME'):
        bb.fatal("Please remove this class as dunfell includes a features_check class already")
}
