deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the Jetson Nano 2GB Devkit and insert the freshly burnt sd-card.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'jetson-nano-2gb-devkit'
	name: 'Nvidia Jetson Nano 2GB Devkit SD'
	arch: 'aarch64'
	state: 'released'

	instructions: [
		instructions.ETCHER_SD
		BOARD_POWEROFF
		BOARD_POWERON
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
		version: 'yocto-dunfell'
		deployArtifact: 'balena-image-jetson-nano-2gb-devkit.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 14
			path: '/config.json'

	initialization: commonImg.initialization
