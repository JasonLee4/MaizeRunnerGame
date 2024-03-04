extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/ContinueButton.grab_focus()

func _process(delta):
	$Label.text = "Level " + str(Globals.cur_lvl) + " completed in "  + str(Globals.lvl_time)


func _on_continue_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/menus/power_up_screen.tscn")

func _on_quit_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().quit()

func _on_main_menu_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
