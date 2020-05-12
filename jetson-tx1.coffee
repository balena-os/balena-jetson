deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWERON = 'Press and hold for 1 second the POWER push button.'

postProvisioningInstructions = [
	instructions.BOARD_SHUTDOWN
	instructions.REMOVE_INSTALL_MEDIA
	instructions.BOARD_REPOWER
]

module.exports =
	version: 1
	slug: 'jetson-tx1'
	aliases: [ 'jetson-tx1' ]
	name: 'Nvidia Jetson TX1'
	arch: 'aarch64'
	state: 'released'
	private: false

	stateInstructions:
		postProvisioning: postProvisioningInstructions

	instructions: [
		instructions.ETCHER_SD
		instructions.EJECT_SD
		instructions.FLASHER_WARNING
		BOARD_POWERON
	].concat(postProvisioningInstructions)

	imageDownloadAlerts: [{
		type: "warning",
		message: "Please ensure the board was running L4T 32.3.1 before flashing BalenaOS. Flashing will not work if the board has the older L4T 28.X partitions"
	}]

	gettingStartedLink:
		windows: 'https://docs.resin.io/jetson-tx1/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.resin.io/jetson-tx1/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.resin.io/jetson-tx1/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'jetson-tx1'
		image: 'resin-image-flasher'
		fstype: 'resinos-img'
		version: 'yocto-warrior'
		deployArtifact: 'resin-image-flasher-jetson-tx1.resinos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
