extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/RestartButton.grab_focus()

func _process(delta):
	$VBoxContainer/Label.text = "You survived until level " + str(Globals.cur_lvl) + "..."
	$VBoxContainer/Label2.text = "Time: " + str(Globals.lvl_time)


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/save_data.tscn")
	Globals.restart_game()


func _on_quit_button_pressed():
	get_tree().quit()



func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
