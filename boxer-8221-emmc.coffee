deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the AAEON BOXER 8221AI eMMC board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use the Jetson Flash tool to flash the board. Jetson Flash tool can be found at https://github.com/balena-os/jetson-flash'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'boxer-8221-emmc'
	aliases: [ 'boxer-8221-emmc' ]
	name: 'AAEON BOXER 8221AI eMMC'
	arch: 'aarch64'
	state: 'released'

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
		machine: 'boxer-8221-emmc'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-boxer-8221-emmc.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
