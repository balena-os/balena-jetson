deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the Jetson Xavier NX Devkit SD-CARD with Seed Respeaker 2MIC HAT and insert the freshly burnt sd-card.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'jetson-xavier-nx-devkit-seeed-2mic-hat'
	aliases: [ 'jetson-xavier-nx-devkit-seeed-2mic-hat' ]
	name: 'Nvidia Jetson Xavier NX Devkit SD Seeed ReSpeaker-2Mic'
	arch: 'aarch64'
	state: 'released'
	community: true

	instructions: [
		instructions.ETCHER_SD
		BOARD_POWEROFF
		BOARD_POWERON
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-xavier-nx-devkit/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-xavier-nx-devkit/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-xavier-nx-devkit/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier-nx-devkit-seeed-2mic-hat'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-jetson-xavier-nx-devkit-seeed-2mic-hat.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
