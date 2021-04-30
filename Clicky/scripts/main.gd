extends Node

# node traversal is done through resource manager
onready var resourceManagerScene = preload("res://scenes/resourceManager.tscn")

func _ready():
	# Start Menu Stuff
	
	
	# resourceManager
	loadResources()

func loadResources():

	#instance the resource manager
	var resourceManager = resourceManagerScene.instance()
	add_child(resourceManager)

