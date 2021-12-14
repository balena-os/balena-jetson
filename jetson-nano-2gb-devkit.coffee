deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the NVidia Jetson Nano 2GB Devkit in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing of the Nano SD-CARD module is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'jetson-nano-2gb-devkit'
	name: 'Nvidia Jetson Nano 2GB Devkit SD'
	arch: 'aarch64'
	state: 'released'

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-nano-2gb-devkit'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-jetson-nano-2gb-devkit.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 14
			path: '/config.json'

	initialization: commonImg.initialization
