extends KinematicBody2D

onready var teleportRightSwitch = false
onready var teleportLeftSwitch = true

onready var inControl = true
onready var moving = false
onready var speed = 0
onready var accl = 0
onready var rocketHasBeenShot = false
onready var shootingRocket = false
onready var tweenNode = get_node("Tween")
onready var theRocketScene = preload("res://scenes/rocket.tscn")
onready var theGameUtils = get_node("../gameUtils")
onready var resourceManager = get_node("../")

onready var moveTarget = position

var decayTimer = 0 
var stateClock = 0
var state = "nonabsorbing"

var lastDir = Vector2.ZERO
var dir = Vector2.ZERO

onready var turnSwitch = false
onready var readySwitch = false

var ff

func _ready():
	ff = 2 * $CollisionShape2D.shape.radius # fudge factor to wrap movement
	
func _process(_delta):
	if !readySwitch:
		resourceManager.get_node("hud/radar").clickyReady()
		readySwitch = true
		
func _physics_process(delta):

	updateState(delta)
	movementLoop(delta)
	manageCam()
	
func manageCam():
	# --------------- Right teleport
	if position.x >= theGameUtils.boardWidth.x - ff and teleportRightSwitch == false:
#		position = Vector2(GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		position = Vector2(GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + 1.3 * ff, position.y)
		teleportRightSwitch = true
		teleportLeftSwitch = false
		moving = false
		
	if position.x < (GameplaySettings.B_X_POS - theGameUtils.boardWidth.x + ff) and teleportRightSwitch == true:
#		position = Vector2(theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		position = Vector2(theGameUtils.boardWidth.x - 1.3 * ff, position.y)
		teleportRightSwitch = false	
		teleportLeftSwitch = true
		moving = false
		
	# --------------- Left teleport
	if position.x <= -theGameUtils.boardWidth.x + ff and teleportLeftSwitch == true:
#		position = Vector2(GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - $CollisionShape2D.shape.radius, position.y)
		position = Vector2(GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - 1.3 * ff, position.y)		
		teleportRightSwitch = true
		teleportLeftSwitch = false
		moving = false
	
	if position.x >= GameplaySettings.B_X_POS + theGameUtils.boardWidth.x - ff and teleportLeftSwitch == false:
#		position = Vector2(-theGameUtils.boardWidth.x + $CollisionShape2D.shape.radius, position.y)
		position = Vector2(-theGameUtils.boardWidth.x + 1.3 * ff, position.y)
		teleportRightSwitch = false
		teleportLeftSwitch = true
	
	# --------------- Top && Bottom wrap
	if position.y >= theGameUtils.boardHeight.y - ff:
		position.y = -theGameUtils.boardHeight.y + 1.3 * ff
		moving = false
	if position.y < -theGameUtils.boardHeight.y + ff:
		position.y = theGameUtils.boardHeight.y - 1.3 * ff
		moving = false
		
func updateState(delta):
	if(state == "absorbing"):
		setMembraneState()
		stateClock -= 0.5 * delta 
		
	if stateClock <= 0:
		state = "nonabsorbing"
		stateClock = 0
		
func setMembraneState():
	$Sprite.get_material().set_shader_param("stateClock", stateClock)

func _unhandled_input(event):
	
#	Beware, magic numbers be here
	if event.is_action_pressed("leftClick") and inControl and  position.distance_to(get_global_mouse_position()) <= 2 * $CollisionShape2D.shape.radius:
		stateClock = 1
		state = "absorbing"
	elif event.is_action_pressed("leftClick") and inControl and  position.distance_to(get_global_mouse_position()) > $CollisionShape2D.shape.radius:
		moving = true
		decayTimer = 0;
		moveTarget = get_global_mouse_position()
#		look_at(moveTarget)
		var forward = position.direction_to(moveTarget)
		tweenNode.interpolate_method(self, 'setRot', transform.x, forward, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tweenNode.start()
		
	if event.is_action_pressed ("shootRocket") and !rocketHasBeenShot and inControl:
		var shootTarget = get_global_mouse_position()
		dir = position.direction_to(shootTarget)
		var forward = position.direction_to(shootTarget)
		shootingRocket = true
		tweenNode.interpolate_method(self, 'setRot', transform.x, forward, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tweenNode.start()
		
func movementLoop(delta):
	if moving == false:
		speed = 0
	else:
		speed = GameplaySettings.CLICKY_SPEED;
#		speed += GameplaySettings.CLICKY_ACCL
		clamp(speed, 0, GameplaySettings.CLICKY_SPEED)
	
	dir = position.direction_to(moveTarget) * speed
	
	if position.distance_squared_to(moveTarget) > 5:
		move_and_slide(delta * speed * dir)
	else:
		moving = false

func setRot(forwardVec):
	transform.x = forwardVec
	transform = transform.orthonormalized()
	transform.x *= 2
	transform.y *= 2

func _on_Tween_tween_all_completed():
	if shootingRocket:
		var aRocket = theRocketScene.instance()
		aRocket.teleportRightSwitch = teleportRightSwitch
		aRocket.teleportLeftSwitch = teleportLeftSwitch
		aRocket.set_name("rocket")
		resourceManager.add_child(aRocket)
		aRocket.transform = $rocketPos.global_transform
		aRocket.setDir(transform.x)
		rocketHasBeenShot = true
		shootingRocket = false
