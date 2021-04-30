extends Node

var boardWidth
var boardHeight

var score = 0;
onready var resourceManager = get_node("../")
# Dependencies:
# A (board) --> a board needs to be instanced before this script runs

func _ready():
	
	# weird bug, even when just calling the x member, it's returning a vec2
	# and there's no way to mult two vec2s, so
	var boardSprite = get_node("../A")
	boardWidth = boardSprite.texture.get_size().x * boardSprite.get_transform().x / 2
	boardHeight = boardSprite.texture.get_size().y * boardSprite.get_transform().y / 2
#	print("boardWidth is:")
#	print(boardWidth.x)
#	print("boardHeight is:")
#	print(boardHeight.y)
#	print("------------------")

func updateScore():
	score += 1;
	writeScore()
	
func writeScore():
	var label = resourceManager.get_node("hud/resources/counter/theLabel")
	label.text = str(score) 
