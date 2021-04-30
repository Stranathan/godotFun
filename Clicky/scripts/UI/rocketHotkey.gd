extends Node

onready var resourceManager = get_node("../../../../")

func _on_rocketHotkey_pressed():
	if resourceManager.has_node("rocket"):
		resourceManager.get_node("cameraManager").focus = "rocket"
		resourceManager.get_node("rocket").inControl = true
		resourceManager.get_node("aClicky").inControl = false
		
