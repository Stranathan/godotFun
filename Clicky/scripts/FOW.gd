extends Sprite

onready var resourceManager = get_node("../")
onready var clicky = resourceManager.get_node("aClicky")
onready var size = texture.get_size() * scale.x / 2;

#func _ready():
		
func _physics_process(_delta):
	
	var clickyPos = Vector2(clicky.position.x / size.x, clicky.position.y / size.y)
	material.set_shader_param("aClickyPos", clickyPos);
	if resourceManager.get_node("rocket"):
		var rocketPos = Vector2(resourceManager.get_node("rocket").position.x / size.x, resourceManager.get_node("rocket").position.y / size.y)
		material.set_shader_param("rocketPos", rocketPos);
	else:
		material.set_shader_param("rocketPos", clickyPos);
