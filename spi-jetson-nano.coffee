deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove power from the board and insert frelshy burnt SD-CARD.'
BOARD_POWERON  = 'Power on the board.'

module.exports =
	version: 1
	slug: 'spi-jetson-nano'
	aliases: [ 'spi-jetson-nano' ]
	name: 'SPI Jetson Nano'
	arch: 'aarch64'
	state: 'experimental'
	community: 'true'

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
		machine: 'spi-jetson-nano'
		image: 'resin-image'
		fstype: 'resinos-img'
		version: 'yocto-warrior'
		deployArtifact: 'resin-image-spi-jetson-nano.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
