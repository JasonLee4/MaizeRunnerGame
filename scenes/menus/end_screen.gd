extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/RestartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_level.tscn")


func _on_quit_button_pressed():
	get_tree().quit()



func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
