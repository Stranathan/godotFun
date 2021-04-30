extends KinematicBody2D

# -------- Global constants and states --------
const constants = preload("res://scripts/utilsAndConstants/gameObjectConstants.gd")

# -------- Inspector Variables --------
export var MAX_START_ACCL = 4

# -------- Member Variables Declaration --------
var directionInput = Vector2.ZERO
var animationStateMachine
var acclModifier # Just being used to give curve to movement

# -------- Shader member vars
var attackTimer 

var MAX_SPEED

func _ready():
	MAX_SPEED = constants.PLAYER_AND_CHUNGAMON_MAX_SPEED
	$attackSprite.visible = false
	$attackSprite/Area2D/CollisionShape2D.disabled = true
	animationStateMachine = $AnimationTree["parameters/playback"]
	directionInput = Vector2.ZERO
	acclModifier = 0
	attackTimer = 0
	
func _physics_process(delta):
	
	# -------- Get Direction Input --------
	#-- Joystick input not working correctly
#	directionInput.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
#	directionInput.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
	
	#--  using d-pad
	directionInput.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	directionInput.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	directionInput = directionInput.normalized();
	
	# -------- Input Update --------
	if Input.is_action_just_pressed("player_attack"):
		attack();
	
	# -------- Update uniforms and shaders --------
	attackTimer += delta
	$attackSprite.material.set_shader_param("attackTimer", attackTimer)
	
	# -------- Update Position --------
	var collision = move_and_collide(delta * MAX_SPEED * directionInput)
#	if collision:
#		var collision2 = move_and_collide(0.1 * MAX_SPEED * -directionInput)
#		if collision2:
#			var collision3 = move_and_collide(0.01 * MAX_SPEED * -directionInput)
			
func attack():
	$attackSprite.visible = true
	$AnimationTree.set("parameters/Attack/blend_position", Vector2(directionInput.x, -directionInput.y))
	attackTimer = 0;
	$attackSprite/Area2D/CollisionShape2D.disabled = false
	animationStateMachine.travel("Attack")

# -------- Animation Cued Functions --------
func attackFinished():
	$attackSprite.visible = false
	animationStateMachine.travel("Idle")
	$attackSprite/Area2D/CollisionShape2D.disabled = true
