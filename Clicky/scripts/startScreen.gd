extends Control

onready var serverIPAddress = $serverIPAddress
onready var deviceIPAddress = $deviceIPAddress

func _ready():
	deviceIPAddress.text = Network.ipAddress
	
func _on_createServer_pressed():
	Network.createServer()
	hide()

func _on_joinServer_pressed():
	if serverIPAddress.text != "":
		hide()
		Network.ipAddress = serverIPAddress.text
		Network.joinServer()
