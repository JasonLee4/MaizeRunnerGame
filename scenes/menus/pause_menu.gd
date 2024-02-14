extends CanvasLayer

@onready var is_paused = false;

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_is_paused(!is_paused)

func set_is_paused(value : bool):
	print("setting is paused to "+str(value))
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _ready():
	visible = false

func _on_resume_button_pressed():
	print("button pressed")
	set_is_paused(false)

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
