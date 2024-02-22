extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/VBoxContainer/Load_Save1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_quit_button_pressed():
	get_tree().quit()


func _on_load_save_1_pressed():
	Globals.new_game = false
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	Globals.restart_game()
	

func _on_create_save_pressed():
	Globals.new_game = true
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	Globals.restart_game()
	
	

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


