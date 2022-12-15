deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the Floyd Nano BB02 Rev.A (eMMC) board in recovery mode, ensure USB2.0 port 1 is in Device mode and connect it it your PC with USB cable.'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'floyd-nano'
	name: 'Floyd Nano BB02A eMMC'
	arch: 'aarch64'
	state: 'discontinued'
	community: true

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-nano-emmc/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-nano-emmc/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-nano-emmc/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'floyd-nano'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-floyd-nano.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
