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

func _ready():
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
	
func _physics_process(delta):
	# ------ Animation Here ------
	if Input.is_action_pressed("move_up"):
		$AnimationPlayer.play("walk_up")
	elif Input.is_action_pressed("move_right"):
		$AnimationPlayer.play("walk_right")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		$AnimationPlayer.play("walk_right")
		$Sprite.flip_h = true
	elif Input.is_action_pressed("move_down"):
		$AnimationPlayer.play("walk_down")
	else:
		$AnimationPlayer.stop()
	
	# ------ Movement Logic Here ------
	directionInput.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	directionInput.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if directionInput.length_squared() != 0:
		forward = directionInput.normalized()
		nonZeroForward = forward
		back = -forward
		nonZeroBack = back
		right = (forward.cross(Vector3.FORWARD)).normalized()
		nonZeroRight = right
		left = -right
		nonZeroLeft = left
	else:
		forward = directionInput.normalized()
		back = -forward
		right = (forward.cross(Vector3.FORWARD)).normalized()
		left = -right
	
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
	
