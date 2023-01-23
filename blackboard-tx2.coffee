deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWEROFF = 'Remove and re-connect power to the board.'
BOARD_POWERON = 'Press and hold for 1 second the POWER push button.'

postProvisioningInstructions = [
	instructions.BOARD_SHUTDOWN
	instructions.REMOVE_INSTALL_MEDIA
	instructions.BOARD_REPOWER
]

module.exports =
	version: 1
	slug: 'blackboard-tx2'
	aliases: [ 'blackboard-tx2' ]
	name: 'Nvidia blackboard TX2'
	arch: 'aarch64'
	state: 'discontinued'
	community: true

	stateInstructions:
		postProvisioning: postProvisioningInstructions

	instructions: [
		instructions.ETCHER_SD
		instructions.EJECT_SD
		instructions.FLASHER_WARNING
		BOARD_POWEROFF
		BOARD_POWERON
	].concat(postProvisioningInstructions)

	gettingStartedLink:
		windows: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/jetson-tx2/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'blackboard-tx2'
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-flasher-blackboard-tx2.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
