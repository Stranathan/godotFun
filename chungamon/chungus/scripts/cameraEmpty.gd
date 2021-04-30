extends Node2D

export var maxDistApart = 300
export var minDistApart = 100

var thePlayer
var theChungamon
var relPosVec
var midpointPos

func _ready():
	thePlayer = get_parent().get_node("thePlayer")
	theChungamon = get_parent().get_node("theChungamon") 

	
func _physics_process(delta):
	var playerPos = thePlayer.get_global_position()
	var chungaPos = theChungamon.get_global_position()
	relPosVec = playerPos - chungaPos
	position = chungaPos + relPosVec / 2.0

	# if the length apart is greater than minDistApart^2
	var distApartSquared = relPosVec.length_squared()
	if distApartSquared > minDistApart * minDistApart and  distApartSquared < maxDistApart * maxDistApart:
		var distApart = relPosVec.length()
		var interpolatingVal = distApart / maxDistApart
		# lerp through 1 to 2
		var zoomFactor = (1 - interpolatingVal)* 0.5 + interpolatingVal*1.5
		$Camera2D.zoom.x = zoomFactor
		$Camera2D.zoom.y = zoomFactor
