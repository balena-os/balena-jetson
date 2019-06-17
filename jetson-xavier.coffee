deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the NVidia Jetson Xavier board in recovery mode'
FLASH_SCRIPT = 'Unzip BalenaOS image and execute: sudo ./flash_xavier.sh <path_to_balenaOS.img>'
DONE_FLASHING  = 'Follow the instructions printed by the flashing script'
module.exports =
	version: 1
	slug: 'jetson-xavier'
	aliases: [ 'jetson-xavier' ]
	name: 'Nvidia Jetson Xavier'
	arch: 'aarch64'
	state: 'experimental'
	community: true

	instructions: [
		BOARD_PREPARE
		FLASH_SCRIPT
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.resin.io/jetson-xavier/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.resin.io/jetson-xavier/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.resin.io/jetson-xavier/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-sumo'
		deployArtifact: 'resin-image-jetson-xavier.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 2
			path: '/config.json'

	initialization: commonImg.initialization
