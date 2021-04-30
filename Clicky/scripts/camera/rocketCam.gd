extends Camera2D


var boardWidth
var boardHeight
onready var theGameUtils = get_node("../../gameUtils")

var edgeSwitch = false
var rocketParent

func _ready():

	boardWidth = theGameUtils.boardWidth.x
	boardHeight = theGameUtils.boardHeight.y
	
	rocketParent = get_node("../")
	limit_left = -boardWidth
	limit_right = boardWidth
	limit_top = -boardHeight
	limit_bottom = boardHeight
	
func _physics_process(delta):
	if (rocketParent.get("teleportRightSwitch") and rocketParent.get("teleportLeftSwitch") == false):
		limit_left = GameplaySettings.B_X_POS - boardWidth
		limit_right = GameplaySettings.B_X_POS + boardWidth
	elif (rocketParent.get("teleportRightSwitch") == false and rocketParent.get("teleportLeftSwitch")):
		limit_left = -boardWidth
		limit_right = boardWidth

