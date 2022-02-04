deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the CTI Photon TX2 NX board in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href=\"https://github.com/balena-os/jetson-flash\">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'

module.exports =
	version: 1
	slug: 'photon-tx2-nx'
	aliases: [ 'photon-tx2-nx' ]
	name: 'CTI Photon TX2 NX'
	arch: 'aarch64'
	state: 'released'
	community: true

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://www.balena.io/docs/learn/getting-started/jetson-nano-emmc/nodejs/#adding-your-first-device'
		osx: 'https://www.balena.io/docs/learn/getting-started/jetson-nano-emmc/nodejs/#adding-your-first-device'
		linux: 'https://www.balena.io/docs/learn/getting-started/jetson-nano-emmc/nodejs/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'photon-tx2-nx'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-photon-tx2-nx.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 24
			path: '/config.json'

	initialization: commonImg.initialization
