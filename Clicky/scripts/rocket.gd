extends Area2D

onready var dir = Vector2.ZERO
onready var inControl = false
onready var speed = GameplaySettings.ROCKET_SPEED_OUT_OF_CONTROL

var teleportRightSwitch
var teleportLeftSwitch
onready var theGameUtils = get_node("../gameUtils")

onready var tweenNode = get_node("Tween")
# CHANGE ME ACCORDING TO TASTE
onready var ff = 100
	
func _physics_process(delta):
	if inControl:
		speed = GameplaySettings.ROCKET_SPEED_IN_CONTROL
	else:
		speed = GameplaySettings.ROCKET_SPEED_OUT_OF_CONTROL
	
	manageCam()
	position +=  transform.x * speed * delta
	
func manageCam():
	# --------------- Right teleport
	if position.x >= theGameUtils.boardWidth.x - ff and teleportRightSwitch == false:
#		position = Vector2(GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		position = Vector2(GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + 1.3 * ff, position.y)
		teleportRightSwitch = true
		teleportLeftSwitch = false
		
	if position.x < (GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + ff) and teleportRightSwitch == true:
#		position = Vector2(theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		position = Vector2(theGameUtils.boardWidth.x - 1.3 * ff, position.y)
		teleportRightSwitch = false	
		teleportLeftSwitch = true
		
	# --------------- Left teleport
	if position.x <= -theGameUtils.boardWidth.x + ff and teleportLeftSwitch == true:
#		position = Vector2(GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		position = Vector2(GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - 1.3 * ff, position.y)		
		teleportRightSwitch = true
		teleportLeftSwitch = false
	
	if position.x >= GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - ff and teleportLeftSwitch == false:
#		position = Vector2(-theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		position = Vector2(-theGameUtils.boardWidth.x + 1.3 * ff, position.y)
		teleportRightSwitch = false
		teleportLeftSwitch = true
	
	# --------------- Top && Bottom wrap
	if position.y >= theGameUtils.boardHeight.y - ff:
		position.y = -theGameUtils.boardHeight.y + 1.3 * ff

	if position.y < -theGameUtils.boardHeight.y + ff:
		position.y = theGameUtils.boardHeight.y - 1.3 * ff

		
func _unhandled_input(event):
	if inControl:
		if Input.is_action_just_pressed ("leftClick"):
#			var target = get_global_mouse_position()
#			dir = (target - position).normalized()
#			look_at(global_position + dir)
			var moveTarget = get_global_mouse_position()
			var forward = position.direction_to(moveTarget)
			tweenNode.interpolate_method(self, 'setRot', transform.x, forward, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
			tweenNode.start()
			
func _on_rocket_body_entered(body):
	get_node("../cameraManager").focus = "clicky"
	get_node("../aClicky").inControl = true
	get_node("../aClicky").rocketHasBeenShot = false
#	if body.is_in_group("anything"):
#		body.queue_free()
	queue_free()

func setDir(d):
	dir = d.normalized()
	
func setRot(forwardVec):
	transform.x = forwardVec
	transform = transform.orthonormalized()
	transform.x *= 2
	transform.y *= 2
