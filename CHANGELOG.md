Change log
-----------

# v2.38.0+rev1
## (2019-06-17)

* Update the meta-balena submodule from v2.37.0 to v2.38.0 [Alexandru Costache]

<details>
<summary> View details </summary>

## meta-balena-2.38.0
### (2019-06-14)

* Fix VERSION_ID os-release to be semver complient [Andrei Gherzan]
* Introduce META_BALENA_VERSION in os-release [Andrei Gherzan]
* Fix a case where changes to u-boot were not regenerating the config file at build time and using stale values. [Zubair Lutfullah Kakakhel]
* Use all.rp_filter=2 as the default value in balenaOS [Andrei Gherzan]
* Persist bluetooth storage data over reboots [Andrei Gherzan]
* Drop support for morty and krogoth Yocto versions [Andrei Gherzan]
* Add Yocto Warrior support [Zubair Lutfullah Kakakhel]
* Set both VERSION_ID and VERSION in os-release to host OS version [Andrei Gherzan]
* Bump balena-engine to 18.9.6 [Zubair Lutfullah Kakakhel]
* Downgrade balena-supervisor to v9.15.7 [Andrei Gherzan]
* Switch from dropbear to openSSH [Andrei Gherzan]
* Rename meta-resin-common to meta-balena-common [Andrei Gherzan]
* Add wifi firmware for rtl8192su [Zubair Lutfullah Kakakhel]
</details>

# v2.37.0+rev2
## (2019-06-14)

* jetson-xavier.coffee: Add coffee file for Jetson Xavier [Alexandru Costache]

# v2.37.0+rev1
## (2019-06-05)

* Update meta-balena from v2.32.0 to v2.37.0 [Alexandru Costache]
* Update to trigger VersionBot with `meta-balena` [Alexandru Costache]

# v2.32.0+rev2
## (2019-04-25)

* Fix primary partition number [Gergely Imreh]

# v2.32.0+rev1
## (2019-04-19)

* jetson-nano.svg: Add icon for Jetson Nano [Alexandru Costache]
* usb-modeswitch: Fix crash on 64 bit platforms [Alexandru Costache]
* jetson-nano.coffee: Added coffee file [Alexandru Costache]
