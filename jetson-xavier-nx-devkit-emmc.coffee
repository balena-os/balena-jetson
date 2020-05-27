deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the NVidia Jetson Xavier board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use the Jetson Flash tool to flash the board. Jetson Flash tool can be found at https://github.com/balena-os/jetson-flash'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'
module.exports =
	version: 1
	slug: 'jetson-xavier-nx-devkit-emmc'
	aliases: [ 'jetson-xavier-nx-devkit-emmc' ]
	name: 'Nvidia Jetson Xavier NX Devkit eMMC'
	arch: 'aarch64'
	state: 'new'
	private: false

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.resin.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.resin.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.resin.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier-nx-devkit-emmc'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-warrior'
		deployArtifact: 'resin-image-jetson-xavier-nx-devkit-emmc.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 37
			path: '/config.json'

	initialization: commonImg.initialization
