extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Defeat.play()
	#$MarginContainer/RestartButton.grab_focus()

func _process(delta):
	$VBoxContainer/Label.text = "You survived until level " + str(Globals.cur_lvl) + "..."
	$VBoxContainer/Label2.text = "Time: " + str(Globals.game_end_time)


func _on_restart_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/menus/save_data.tscn")
	Globals.restart_game()


func _on_quit_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().quit()



func _on_main_menu_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_restart_button_mouse_entered():
	$Restart_TextLabel.text = "[shake rate=15 level=15]"+ $Restart_TextLabel.text +"[/shake]"

func _on_restart_button_mouse_exited():
	$Restart_TextLabel.text = "Restart"
	
	
func _on_main_menu_button_mouse_entered():
	$Main_Menu_TextLabel.text = "[shake rate=15 level=15]"+ $Main_Menu_TextLabel.text +"[/shake]"

func _on_main_menu_button_mouse_exited():
	$Main_Menu_TextLabel.text = "Main Menu"


func _on_quit_button_mouse_entered():
	$Quit_TextLabel.text = "[shake rate=15 level=15]"+ $Quit_TextLabel.text +"[/shake]"

func _on_quit_button_mouse_exited():
	$Quit_TextLabel.text = "Quit"
