extends Node2D

# The nutrient manager is just going to keep track of nutrient player interaction
# if there's a collision with the right conditions (macro mechanic)
# the nutrient manager moves the nutrient to a random location

var rng = RandomNumberGenerator.new()

onready var nutrientList = []
onready var aNutrientScene = preload("res://scenes/nutrient.tscn")

func _ready():
	
	for i in range(GameplaySettings.numNutrients):
		var nutrientNode = aNutrientScene.instance()
		nutrientNode.set_name("aNutrient")
		nutrientList.append(nutrientNode)
		add_child(nutrientNode)
	
func _physics_process(_delta):
	for nutrient in nutrientList:
		
		if(nutrient.get("consumedFlag") == true):
			nutrient.position = Vector2(
				rng.randf_range(-GameplaySettings.distToGenerate, GameplaySettings.distToGenerate),
				rng.randf_range(-GameplaySettings.distToGenerate, GameplaySettings.distToGenerate)
				)
			nutrient.consumedFlag = false

	
