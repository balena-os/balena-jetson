deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_POWERON = 'Connect power to the N310 carrier board.'

postProvisioningInstructions = [
	instructions.BOARD_SHUTDOWN
	instructions.REMOVE_INSTALL_MEDIA
	instructions.BOARD_REPOWER
]

module.exports =
	version: 1
	slug: 'n310-tx2'
	aliases: [ 'n310-tx2' ]
	name: 'Aetina N310 TX2'
	arch: 'aarch64'
	state: 'discontinued'
	community: true

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
		machine: 'n310-tx2'
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-honister'
		deployArtifact: 'balena-image-flasher-n310-tx2.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
