extends KinematicBody2D

export var MAX_SPEED = 150
export var RADIUS_MULTIPLIER = 4

var directionInput

var forward
var nonZeroForward
var back
var nonZeroBack
var left
var nonZeroLeft
var right
var nonZeroRight

var radius
var inputFlag
var recallFlag
var thePlayer

func _ready():
	thePlayer = get_parent().get_node("thePlayer")
	directionInput = Vector3.ZERO
	forward = Vector3(0, 1, 0)
	nonZeroForward = forward
	back = -forward
	nonZeroBack = back
	right = Vector3(1, 0, 0)
	nonZeroRight = right
	left = -right
	nonZeroLeft = left
	radius = $CollisionShape2D.shape.radius * RADIUS_MULTIPLIER
	inputFlag = false

func _physics_process(delta):
	# ------ Movement Logic Here ------
	directionInput.x = Input.get_action_strength("rightStickRight") - Input.get_action_strength("rightStickLeft")
	directionInput.y = Input.get_action_strength("rightStickDown") - Input.get_action_strength("rightStickUp")
	
	# if there's input
	if directionInput.length_squared() != 0:
		inputFlag = true
		forward = directionInput.normalized()
		nonZeroForward = forward
		back = -forward
		nonZeroBack = back
		right = (forward.cross(Vector3.FORWARD)).normalized()
		nonZeroRight = right
		left = -right
		nonZeroLeft = left
	# I don't think these are necessary calculations since non one is accessing it's directions
	elif inputFlag == true:
		forward = directionInput.normalized()
		back = -forward
		right = (forward.cross(Vector3.FORWARD)).normalized()
		left = -right
	elif inputFlag == false:
		position = thePlayer.position
		forward = directionInput.normalized()
		back = -forward
		right = (forward.cross(Vector3.FORWARD)).normalized()
		left = -right	
	# recall
	if Input.is_action_just_pressed("recallMonsters"):
		inputFlag = false
	
	move_and_collide(delta * MAX_SPEED * Vector2(forward.x, forward.y))

func getPosition():
	return global_position

func getRight():
	return Vector2(right.x, right.y)
	
func getNonZeroRight():
	return Vector2(nonZeroRight.x, nonZeroRight.y)
	
func getLeft():
	return Vector2(left.x, left.y)
	
func getNonZeroLeft():
	return Vector2(nonZeroLeft.x, nonZeroLeft.y)
	
func getForward():
	return Vector2(forward.x, forward.y)
	
func getNonZeroForward():
	return Vector2(nonZeroForward.x, nonZeroForward.y)
		
func getBack():
	return Vector2(back.x, back.y)
	
func getNonZeroBack():
	return Vector2(nonZeroBack.x, nonZeroBack.y)

func getRadius():
	return radius
	
