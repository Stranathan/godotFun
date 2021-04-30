extends KinematicBody2D

const utils = preload("res://scripts/utils.gd")
var state

func _ready():
	state = utils.StateEnums.MOVE

func _physics_process(delta):
	match state:
		utils.StateEnums.MOVE:
			moveState(delta)

func moveState(delta):
	pass

func _on_AttackableArea_area_entered(area):
	if area.is_in_group("SWORD_ATTACK_GROUP"):
		state = utils.StateEnums.DEAD # unnessecary right now
		$defaultSprite.visible = false
		$AnimationPlayer.play("poof")
			
func removedKilled():
	queue_free()
