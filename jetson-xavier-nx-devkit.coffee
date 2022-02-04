deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the NVidia Jetson Xavier NX Devkit SD-CARD board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'jetson-xavier-nx-devkit'
	aliases: [ 'jetson-xavier-nx-devkit' ]
	name: 'Nvidia Jetson Xavier NX Devkit SD-CARD'
	arch: 'aarch64'
	state: 'released'

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier-nx-devkit'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-jetson-xavier-nx-devkit.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
