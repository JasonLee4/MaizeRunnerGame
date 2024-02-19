extends Control

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if(not get_tree().paused):
			pause()
		else:
			unpause()

func pause():
	visible = true
	get_tree().paused = true
	
func unpause():
	visible = false
	get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_continue_button_pressed():
	unpause()

func _on_return_button_pressed():
	unpause()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
