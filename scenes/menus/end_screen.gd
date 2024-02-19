extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/RestartButton.grab_focus()

func _process(delta):
	$Label.text = "Time: " + str(Globals.lvl_time)


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/level_screen.tscn")
	Globals.restart_game()


func _on_quit_button_pressed():
	get_tree().quit()



func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
