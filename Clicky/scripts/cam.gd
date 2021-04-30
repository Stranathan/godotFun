extends Camera2D


var boardWidth
var boardHeight
onready var theGameUtils = get_node("../../gameUtils")

var edgeSwitch = false
var clickyParent

func _ready():

	boardWidth = theGameUtils.boardWidth.x
	boardHeight = theGameUtils.boardHeight.y
	
	clickyParent = get_node("../")
	limit_left = -boardWidth
	limit_right = boardWidth
	limit_top = -boardHeight
	limit_bottom = boardHeight
	
func _physics_process(delta):
	if (clickyParent.get("teleportRightSwitch") and clickyParent.get("teleportLeftSwitch") == false):
		limit_left = GameplaySettings.B_X_POS - boardWidth
		limit_right = GameplaySettings.B_X_POS + boardWidth
	elif (clickyParent.get("teleportRightSwitch") == false and clickyParent.get("teleportLeftSwitch")):
		limit_left = -boardWidth
		limit_right = boardWidth

