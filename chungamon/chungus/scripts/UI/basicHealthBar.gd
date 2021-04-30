extends Node2D

var bar_red = preload("res://sprites/UI/barHorizontal_red.png")
var bar_green = preload("res://sprites/UI/barHorizontal_green.png")
var bar_yellow = preload("res://sprites/UI/barHorizontal_yellow.png")

#-- Texture Progress Node
onready var healthbar = $HealthBar

func _ready():
	hide()
	if get_parent() and get_parent().get("MAX_LIFE"):
		healthbar.max_value = get_parent().MAX_LIFE

# this is to prevent inheriting rotation from parent object
func _process(delta):
	global_rotation = 0

#-- Feed in a member variable for health
func updateHealthbar(value):
	healthbar.texture_progress = bar_green
	
	if value < healthbar.max_value:
		show()
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	
	healthbar.value = value
