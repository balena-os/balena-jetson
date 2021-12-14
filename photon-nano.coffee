deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_FLASH    = 'Place carrier board in force recovery and flash the OS file with <a href=\"https://github.com/balena-os/jetson-flash/\">jetson-flash</a>.'
BOARD_POWEROFF = 'After the Nano eMMC module is flashed, remove power from the board.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'photon-nano'
	aliases: [ 'photon-nano' ]
	name: 'CTI Photon Nano'
	arch: 'aarch64'
	state: 'released'
	community: true

	instructions: [
		BOARD_FLASH
		BOARD_POWEROFF
		BOARD_POWERON
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'photon-nano'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-dunfell'
		deployArtifact: 'balena-image-photon-nano.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
