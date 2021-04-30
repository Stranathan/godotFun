extends KinematicBody2D

var MAX_SPEED = 170
const utils = preload("res://scripts/utils.gd")
var directionInput3D
var animationStateMachine
var state

func _ready():
	state = utils.StateEnums.MOVE
	directionInput3D = Vector3.ZERO
	animationStateMachine = $AnimationTree["parameters/playback"]
	$SwordAttackArea/AttackCollider.disabled = true
func _physics_process(delta):
	match state:
		utils.StateEnums.MOVE:
			moveState(delta)
		utils.StateEnums.ROLL:
			rollState(delta)
		utils.StateEnums.SWORD_ATTACK:
			swordAttackState(delta)
			
func moveState(delta):
	directionInput3D.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	directionInput3D.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	directionInput3D = directionInput3D.normalized()
	
	if directionInput3D != Vector3.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position", Vector2(directionInput3D.x, -directionInput3D.y))
		$AnimationTree.set("parameters/Walk/blend_position", Vector2(directionInput3D.x, -directionInput3D.y))
		$AnimationTree.set("parameters/SwordAttack/blend_position", Vector2(directionInput3D.x, -directionInput3D.y))
		animationStateMachine.travel("Walk")
	else:
		animationStateMachine.travel("Idle")
	
	# ----
	if Input.is_action_just_pressed("playerSwordAttack"):
		state = utils.StateEnums.SWORD_ATTACK
	# ----
	
	move_and_collide(delta * MAX_SPEED * Vector2(directionInput3D.x, directionInput3D.y))

func rollState(delta):
	pass
	
func swordAttackState(delta):
	animationStateMachine.travel("SwordAttack")
	$SwordAttackArea/AttackCollider.disabled = false
	
# if member velocity is with a certain threshold return to walking
# else return to running
func swordAttackAnimationFinished():
	state = utils.StateEnums.MOVE
	$SwordAttackArea/AttackCollider.disabled = true
