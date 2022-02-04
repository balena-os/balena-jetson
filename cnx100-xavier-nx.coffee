deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the carrier board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'
module.exports =
	version: 1
	slug: 'cnx100-xavier-nx'
	aliases: [ 'cnx100-xavier-nx' ]
	name: 'Auvidea CNX100 Xavier NX'
	arch: 'aarch64'
	state: 'released'
	community: true

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-xavier-nx-devkit-emmc/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'cnx100-xavier-nx'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-cnx100-xavier-nx.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 9
			path: '/config.json'

	initialization: commonImg.initialization
