deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWERON = 'Connect power to the carrier board.'
BOARD_SHUTDOWN = 'The device is performing a shutdown. Please wait until the SYS LED is turned off.'

postProvisioningInstructions = [
	BOARD_SHUTDOWN
	instructions.REMOVE_INSTALL_MEDIA
	instructions.BOARD_REPOWER
]

module.exports =
	version: 1
	slug: 'orbitty-tx2'
	aliases: [ 'orbitty-tx2' ]
	name: 'CTI Orbitty TX2'
	arch: 'aarch64'
	state: 'released'

	stateInstructions:
		postProvisioning: postProvisioningInstructions

	instructions: [
		instructions.ETCHER_SD
		instructions.EJECT_SD
		instructions.FLASHER_WARNING
		BOARD_POWERON
	].concat(postProvisioningInstructions)

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'orbitty-tx2'
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-flasher-orbitty-tx2.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
