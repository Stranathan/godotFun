extends Node


onready var resourceManager = get_node("../../")

export var zoom = 2

onready var grid = $NinePatchRect
onready var playerIcon = $NinePatchRect/player
onready var enemyIcon = $NinePatchRect/enemy

# dictionary map
onready var icons = {"anotherClicky": enemyIcon}

var enemiesMadeSwitch = false
var player
var grid_scale
var iconsOnRadar = {}

func _ready():
	playerIcon.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport().size * zoom)
	
func _process(delta):
	if !player:
		return
	playerIcon.rotation = player.rotation
	
	if enemiesMadeSwitch:
		for icon in iconsOnRadar:
			var objPos = (icon.position - player.position) * grid_scale + grid.rect_size / 2
			iconsOnRadar[icon].position = objPos
			if grid.get_rect().has_point(objPos + grid.rect_position):
				iconsOnRadar[icon].show()
			else:
				iconsOnRadar[icon].hide()
	
func clickyReady():
	player = resourceManager.get_node("aClicky")

func enemyReady():
	var radarObjects = get_tree().get_nodes_in_group("enemies")
	for radarObj in radarObjects:
		var newRadarIcon = icons[radarObj.radarIcon].duplicate()
		grid.add_child(newRadarIcon)
		newRadarIcon.show()
		iconsOnRadar[radarObj] = newRadarIcon

	enemiesMadeSwitch = true
