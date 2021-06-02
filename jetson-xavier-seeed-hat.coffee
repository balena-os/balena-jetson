deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the Jetson Xavier NX Devkit SD-CARD and insert the freshly burnt sd-card.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'jetson-xavier-seeed-hat'
	aliases: [ 'jetson-xavier-seeed-hat' ]
	name: 'Nvidia Jetson Xavier NX Devkit with seeed HAT'
	arch: 'aarch64'
	state: 'new'

	instructions: [
		instructions.ETCHER_SD
		BOARD_POWEROFF
		BOARD_POWERON
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier-seeed-hat'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-dunfell'
		deployArtifact: 'balena-image-jetson-xavier-seeed-hat.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
