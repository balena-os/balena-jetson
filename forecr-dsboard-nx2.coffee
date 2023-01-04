deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the NVidia Jetson Xavier NX board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'
module.exports =
	version: 1
	slug: 'forecr-dsboard-nx2'
	aliases: [ 'forecr-dsboard-nx2' ]
	name: 'Forecr DSBOARD-NX2'
	arch: 'aarch64'
	state: 'new'

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/forecr-dsboard-nx2/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/forecr-dsboard-nx2/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/forecr-dsboard-nx2/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'forecr-dsboard-nx2'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-forecr-dsboard-nx2.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
