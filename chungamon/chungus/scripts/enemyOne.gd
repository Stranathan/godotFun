extends KinematicBody2D

#---- Inspector exposed variables
export var ENEMY_MAX_SPEED = 80
export var ENEMY_IDLE_SPEED = 25
export var MAX_LIFE = 100
export var seekThreshold = 150
export var MAX_STEERING = 80
export var MAX_SPEED = 100
export var KNOCKBACK_COEFF = 0.08

#----
const constants = preload("res://scripts/utilsAndConstants/gameObjectConstants.gd")

#----
var thePlayer
var theChungamon
var theCam

var state
var life
var enemyRng
var justHit

#----
var aggroNum
var col

#----
var vel
var accl
var relPosToTarget
var target


# state uniforms
var idleCol
var idleAggroNum
var seekingCol
var seekingAggroNum
var hitCol
var hitAggroNum
var deadCol

func _ready():
	state = constants.enemyStates.IDLE
	life = MAX_LIFE
	enemyRng = RandomNumberGenerator.new() # should be a class static 
	justHit = false
	
	vel = Vector2.ZERO
	accl = Vector2.ZERO

	thePlayer = get_parent().get_node("thePlayer")
	theChungamon = get_parent().get_node("theChungamon")
	theCam = get_parent().get_node("emptyCamHolder")

	idleCol  = Vector3(0.1, 0.2, 1.0)
	seekingCol = Vector3(0.9, 0.3, 0.8)
	hitCol = Vector3(1.0, 0.0, 0.0)
	deadCol = Vector3(0.0, 0.0, 0.0)
	idleAggroNum = 2.0
	seekingAggroNum = 6.0
	hitAggroNum = 55.0
	
func _physics_process(delta):
	match state:
		constants.enemyStates.IDLE:
			idle(delta)
		constants.enemyStates.SEEK:
			seek(delta)
			
func updateUniforms():
	var screen_coord = get_viewport_transform() * (get_global_position())
	var theCamScreenPos = get_viewport_transform() * (theCam.get_global_position())
	$Sprite.material.set_shader_param("myPos", screen_coord)
	$Sprite.material.set_shader_param("camPos", theCamScreenPos)
	
	if state == constants.enemyStates.IDLE and justHit == false:
		$Sprite.material.set_shader_param("aggroCol", idleCol)
		$Sprite.material.set_shader_param("aggroNum", idleAggroNum)
	elif state == constants.enemyStates.SEEK  and justHit == false:
		$Sprite.material.set_shader_param("aggroCol", seekingCol)
		$Sprite.material.set_shader_param("aggroNum", seekingAggroNum)
	elif (state == constants.enemyStates.SEEK or state == constants.enemyStates.IDLE) and justHit == true:
		$Sprite.material.set_shader_param("aggroCol", hitCol)
		$Sprite.material.set_shader_param("aggroNum", hitAggroNum)
	elif state == constants.enemyStates.DEAD and justHit == false:
		$Sprite.material.set_shader_param("aggroCol", deadCol)
		$Sprite.material.set_shader_param("aggroNum", hitAggroNum)
		
func idle(delta):
	
	updateUniforms()
	# --- Selecting based on who is closest
	target = thePlayer.position
	if (thePlayer.position - position).length_squared() > (theChungamon.position - position).length_squared():
		target = theChungamon.position

	relPosToTarget = target - position

	if relPosToTarget.length_squared() < seekThreshold * seekThreshold:
		state = constants.enemyStates.SEEK

	#-- move in a jittery circle
	else:
		var timeElapsed = OS.get_ticks_msec() / 1000.0
		var xx = enemyRng.randf_range(-2, 2)
		var yy = enemyRng.randf_range(-2, 2)
		var tmpTarget = Vector2(50.0 * sin(timeElapsed) + xx, 50.0 * cos(timeElapsed) + yy)
		var vel = (tmpTarget - position).normalized() * ENEMY_IDLE_SPEED
		move_and_collide(delta * vel)

func seek(delta):
	
	updateUniforms()
	knockback(delta)
	target = thePlayer.position
	if (thePlayer.position - position).length_squared() > (theChungamon.position - position).length_squared():
		target = theChungamon.position
	relPosToTarget = target - position
	var desired = relPosToTarget.normalized() * MAX_STEERING
	var steering = desired - vel

	accl += steering
	vel += accl
	vel = vel.clamped(MAX_SPEED)
	
	move_and_collide(delta * vel)
	
func knockback(delta):
	if justHit == true:
		move_and_collide(delta * KNOCKBACK_COEFF * MAX_SPEED * -relPosToTarget.normalized())
	else:
		pass

func die():
	$randomParticleEffect.emitParticles()
	yield(get_tree().create_timer(1.5), "timeout")
	#play some death animation here
	queue_free()
	
func _on_hitbox_area_entered(area):
	
	if area.is_in_group("attackableByPlayerChungamon"):
		justHit = true
		updateUniforms()
		life -= 25
		$HealthDisplay.updateHealthbar(life)
		if(life <= 0):
			state = constants.enemyStates.DEAD
			die()
		yield(get_tree().create_timer(0.15), "timeout")
		justHit = false
		
		
		

