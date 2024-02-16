extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/RestartButton.grab_focus()

func _process(delta):
	$Label.text = "Level " + str(Globals.cur_lvl) + " completed in "  + str(Globals.lvl_time)


func _on_restart_button_pressed():
	Globals.go_next_lvl()
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	


func _on_quit_button_pressed():
	get_tree().quit()



func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
