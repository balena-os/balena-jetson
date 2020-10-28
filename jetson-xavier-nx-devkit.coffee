deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the Jetson Xavier NX Devkit SD-CARD and insert the freshly burnt sd-card.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'jetson-xavier-nx-devkit'
	aliases: [ 'jetson-xavier-nx-devkit' ]
	name: 'Nvidia Jetson Xavier NX Devkit SD-CARD'
	arch: 'aarch64'
	state: 'new'

	instructions: [
		instructions.ETCHER_SD
		BOARD_POWEROFF
		BOARD_POWERON
	]

	gettingStartedLink:
		windows: 'https://docs.resin.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.resin.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.resin.io/jetson-xavier-nx-devkit-sd-card/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-xavier-nx-devkit'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-warrior'
		deployArtifact: 'resin-image-jetson-xavier-nx-devkit.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
