extends KinematicBody2D

#Nutrient lives in a nutrient manager
var rng = RandomNumberGenerator.new()

var SPEED = GameplaySettings.NUTRIENT_SPEED
var desiredVel = GameplaySettings.DESIRED_VEL
var distToAttract = GameplaySettings.DIST_TO_ATTRACT 

onready var theGameUtils = get_node("../../gameUtils")
onready var teleportRightSwitch = false
onready var teleportLeftSwitch = true

onready var vel
onready var accl
onready var target
onready var listOfTargets = []
onready var consumedFlag = false
onready var seekPauseTimer = 0

func _ready():
	setRndVel()
	
	var t1 = get_node("../../aClicky")
	listOfTargets.append(t1)

func _physics_process(delta):

	if target == null && seekPauseTimer <= 0:
		var colli = move_and_collide(vel * SPEED * delta)
		look()
	elif target == null && seekPauseTimer > 0:
		seekPauseTimer -= delta
		var colli = move_and_collide(vel * SPEED * delta)
	else:
		seek()
		var colli = move_and_collide(vel * SPEED * delta)
		if colli:
			if colli.collider.name == "aClicky" && target.state == "absorbing":
				target = null
				setRndVel()
				consumedFlag = true
				theGameUtils.updateScore()
				
			elif colli.collider.name == "aClicky" && target.state == "nonabsorbing":
				vel *= -1
				seekPauseTimer = GameplaySettings.PAUSE_TIME
				target = null
			elif colli.collider.name == "aNutrient":
				vel *= -1
	# --------------- Right teleport
	if position.x >= theGameUtils.boardWidth.x and teleportRightSwitch == false:
		position = Vector2(GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		teleportRightSwitch = true
		teleportLeftSwitch = false
		
	if position.x < (GameplaySettings.B_X_POS - theGameUtils.boardWidth.x) and teleportRightSwitch == true:
		position = Vector2(theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		teleportRightSwitch = false	
		teleportLeftSwitch = true
	
	# --------------- Left teleport
	if position.x <= -theGameUtils.boardWidth.x and teleportLeftSwitch == true:
		position = Vector2(GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		teleportRightSwitch = true
		teleportLeftSwitch = false
	
	if position.x >= GameplaySettings.B_X_POS + theGameUtils.boardWidth.x and teleportLeftSwitch == false:
		position = Vector2(-theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		teleportRightSwitch = false
		teleportLeftSwitch = true
	
	# --------------- Top && Bottom wrap
	if position.y >= theGameUtils.boardHeight.y:
		position.y = -theGameUtils.boardHeight.y + $CollisionShape2D.shape.radius
	if position.y < -theGameUtils.boardHeight.y:
		position.y = theGameUtils.boardHeight.y - $CollisionShape2D.shape.radius
		
func look():
	
	for t in listOfTargets:
		if((t.position - position).length_squared() < distToAttract * distToAttract):
			target = t;
		else:
			target = null;
			
func seek():
	accl = Vector2.ZERO
	var desired = (target.position - position).normalized() * desiredVel
	accl += (desired - vel)
	vel += accl
	
func setRndVel():
	rng.randomize()
	var x = rng.randf_range(-20.0, 20.0)
	rng.randomize()
	var y = rng.randf_range(-20.0, 20.0)
	vel = Vector2(x, y)
