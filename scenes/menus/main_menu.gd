extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Buttons/VBoxContainer/StartButton.grab_focus()
	$FullScreenSwitch.button_pressed = false
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("idle")

	#$Creepy.play_rand_sound()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	$Button.play()
	await $Button.finished
	#get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	get_tree().change_scene_to_file("res://scenes/menus/save_data.tscn")
	
	#Globals.restart_game()


func _on_quit_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().quit()



func _on_options_button_pressed():
	# tutorial button
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")


func _on_debug_screen_change_toggled(toggled_on):
	
	if $FullScreenSwitch.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		


func _on_timer_timeout():
	$RichTextLabel.visible = !$RichTextLabel.visible

func _on_skip_to_boss_button_pressed():
	Globals.new_game = true
	Globals.restart_game()
	Globals.cur_lvl = 5
	get_tree().change_scene_to_file("res://scenes/levels/boss_level.tscn")

func _on_skip_to_final_boss_button_pressed():
	Globals.new_game = true
	Globals.restart_game()
	Globals.cur_lvl = 10
	get_tree().change_scene_to_file("res://scenes/levels/boss_level.tscn")
