deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the board and insert freshly burnt SD-CARD.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'jn30b-nano'
	aliases: [ 'jn30b-nano' ]
	name: 'Auvidea JN30B Nano'
	arch: 'aarch64'
	state: 'released'
	community: 'true'
	private: false

	instructions: [
		instructions.ETCHER_SD
		BOARD_POWEROFF
		BOARD_POWERON
	]

	gettingStartedLink:
		windows: 'https://docs.resin.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.resin.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.resin.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jn30b-nano'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-warrior'
		deployArtifact: 'resin-image-jn30b-nano.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
