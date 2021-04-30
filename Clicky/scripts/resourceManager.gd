extends Node

onready var gameUtilsScene = preload("res://scenes/gameUtils.tscn")
onready var boardAScene = preload("res://scenes/A.tscn")
onready var boardBScene = preload("res://scenes/B.tscn")
onready var aClickyScene = preload("res://scenes/clicky.tscn")
onready var nutrientManagerScene = preload("res://scenes/nutrientManager.tscn")
onready var hudScene = preload("res://scenes/UI/HUD.tscn")
onready var cameraManagerScene = preload("res://scenes/cameraManager.tscn")
onready var fowScene = preload("res://scenes/FOW.tscn")
onready var testEnemyScene = preload("res://scenes/testing/testEnemy.tscn")
# start and stop subsystems according to dependencies

func _ready():
	
	# instance GUI
	var hudSceneInstance = hudScene.instance()
	hudSceneInstance.set_name("hud")
	add_child(hudSceneInstance)
	
	#instance the board
	var boardAInstance = boardAScene.instance()
	boardAInstance.set_name("A")
	add_child(boardAInstance)
	
	#instance the board
	var boardBInstance = boardBScene.instance()
	boardBInstance.set_name("B")
	add_child(boardBInstance)
	
	#instance the utils
	var gameUtilsInstance = gameUtilsScene.instance()
	gameUtilsInstance.set_name("gameUtils")
	add_child(gameUtilsInstance)
	
	#instance the clicky
	var clickyInstance = aClickyScene.instance()
	clickyInstance.set_name("aClicky")
	add_child(clickyInstance)
	
	#instance the nutrient manager
	var nutrientManagerInstance = nutrientManagerScene.instance()
	nutrientManagerInstance.set_name("nutrientManager")
	add_child(nutrientManagerInstance)
	
	#instance the nutrient manager
	var cameraManagerInstance = cameraManagerScene.instance()
	cameraManagerInstance.set_name("cameraManager")
	add_child(cameraManagerInstance)
	
	var testEnemySceneInstance = testEnemyScene.instance()
	testEnemySceneInstance.set_name("testEnemy")
	add_child(testEnemySceneInstance)
	
	var fowSceneInstance = fowScene.instance()
	fowSceneInstance.set_name("fow")
	add_child(fowSceneInstance)
	
	
