extends Node


var radarIcon = "anotherClicky"

var theName = "testEnemy"
var readySwitch = false

onready var resourceManager = get_node("../")

func _process(_delta):
	if !readySwitch:
		resourceManager.get_node("hud/radar").enemyReady()
		readySwitch = true
	else:
		return	
