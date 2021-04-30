extends Node


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(name)
			print("I've been clicked D:")
			
