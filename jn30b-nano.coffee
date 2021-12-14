deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the Auvidea JN30B Nano board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing of the Nano eMMC module is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'jn30b-nano'
	aliases: [ 'jn30b-nano' ]
	name: 'Auvidea JN30B Nano'
	arch: 'aarch64'
	state: 'released'
	community: 'true'

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-nano/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jn30b-nano'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-jn30b-nano.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition: 12
			path: '/config.json'

	initialization: commonImg.initialization
