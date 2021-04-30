extends Line2D

var parent
var thePlayer
var rightStick
var forwardGuy
var radius
var targetPos

func _ready():
	thePlayer = get_parent().get_node("thePlayer")
	rightStick = get_parent().get_node("rightStick")
	parent = thePlayer
	forwardGuy = get_parent().get_node("forwardGuy")
	radius = thePlayer.getRadius()
	width = 2
	targetPos = thePlayer.global_position + radius * thePlayer.getForward()
	add_point(Vector2(forwardGuy.position.x, forwardGuy.position.y), 0)
	add_point(Vector2(targetPos.x, targetPos.y), 1)
	
func _physics_process(delta):
	if rightStick.get("inputFlag"):
		parent = rightStick
	else:
		parent = thePlayer
		
	targetPos = parent.global_position + radius * parent.getNonZeroForward()
	set_point_position(0, Vector2(forwardGuy.position.x, forwardGuy.position.y))
	set_point_position(1, Vector2(targetPos.x, targetPos.y))


