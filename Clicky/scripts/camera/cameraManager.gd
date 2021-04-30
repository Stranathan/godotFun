extends Node

onready var focus = "clicky"
onready var resourceManager = get_node("../")

func _process(delta):
	if resourceManager.get_node("aClicky").get("rocketHasBeenShot"):
			if focus == "clicky":
				resourceManager.get_node("aClicky/Camera2D").current = true
				if resourceManager.has_node("rocket"):
					resourceManager.get_node("rocket/Camera2D").current = false
			elif focus == "rocket":
				resourceManager.get_node("aClicky/Camera2D").current = false
				if resourceManager.has_node("rocket"):
					resourceManager.get_node("rocket/Camera2D").current = true
	else:
		resourceManager.get_node("aClicky/Camera2D").current = true
		
