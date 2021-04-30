extends Node

onready var resourceManager = get_node("../../../../")

func _on_clickyHotkey_pressed():
	
	resourceManager.get_node("aClicky").inControl = true
	if resourceManager.has_node("rocket"):
		resourceManager.get_node("rocket").inControl = false
		
	resourceManager.get_node("cameraManager").focus = "clicky"
