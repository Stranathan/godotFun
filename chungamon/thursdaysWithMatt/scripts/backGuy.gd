extends KinematicBody2D

var tolerance
var thePlayer
var rightStick
var parent
var radius
var directionIDNum

func _ready():
	directionIDNum = 3
	thePlayer = get_parent().get_node("thePlayer")
	rightStick = get_parent().get_node("rightStick")
	parent = thePlayer
	radius = parent.getRadius() # parent's collision shape radius
	tolerance = radius / 2.0
	global_position = parent.global_position + radius * parent.getBack()
	
func _physics_process(delta):
	
	if rightStick.get("inputFlag"):
		parent = rightStick
	else:
		parent = thePlayer
		
	# ----- Rotation Input -----
	if Input.is_action_just_pressed("turnMonstersRight"):
		directionIDNum += 1
		# mod rotation ID nums to create circle
		if directionIDNum >= 5:
			directionIDNum = 1
	elif Input.is_action_just_pressed("turnMonstersLeft"):
		directionIDNum -= 1
		# mod rotation ID nums to create circle
		if directionIDNum <= 0:
			directionIDNum = 4
			
	# ----- translation of parent -----
	move_and_collide(delta * parent.getForward() * parent.get("MAX_SPEED"))
	
	# ----- translation in the direction to targetPos (radius  directionID direction)
	var offsetVector
	match directionIDNum:
		1:
			offsetVector = parent.getNonZeroForward()
		2:
			offsetVector = parent.getNonZeroRight()
		3:
			offsetVector = parent.getNonZeroBack()
		4:
			offsetVector = parent.getNonZeroLeft()

	var targetPos = parent.position + radius * offsetVector
	var relativeDifferenceUnitVector = (targetPos - position).normalized()
	
	# ----- translation to desired position -----
	if (targetPos - position).length_squared() > 5:
		move_and_collide(delta * relativeDifferenceUnitVector *  parent.get("MAX_SPEED"))
	else:
		position.linear_interpolate(targetPos, delta)
