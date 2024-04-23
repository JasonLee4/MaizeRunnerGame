extends Control

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if(not get_tree().paused):
			pause()
		else:
			unpause()

func pause():
	$Saved_Button_Sprite.visible = false	
	visible = true
	$OptionsScreen.visible = false
	$MenuConfirm.visible = false
	$ExitConfirm.visible = false
	get_tree().paused = true
	$SaveButton/RichTextLabel.text = "Save Game"
	
func unpause():
	$Saved_Button_Sprite.visible = false	
	visible = false
	get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_continue_button_pressed():
	$Button.play()
	await $Button.finished
	unpause()

func _on_return_button_pressed():
	$Button.play()
	await $Button.finished
	$MenuConfirm.visible = true


func _on_save_button_pressed():
	$Button.play()
	await $Button.finished
	save_data()

func save_data():
	var gameData = Globals.gameData
	gameData.update_playerMaxHealth(Globals.max_health)
	gameData.update_playerHealth(Globals.health)
	gameData.update_laserEnergy(Globals.laser_energy)
	gameData.update_currentLevel(Globals.cur_lvl)
	gameData.update_playerSpeed(Globals.pig_speed)
	gameData.update_playerInventory(Globals.inv)
	gameData.update_elapsedTime(Time.get_ticks_msec())
	
	gameData.update_onetimePower(Globals.onetime_power)
	
	ResourceSaver.save(gameData, Globals.save_file_path + Globals.save_file_name)
	#$SaveButton/RichTextLabel.text = "Saved!"
	#$SaveButton.size = Vector2(120, 40)
	$Saved_Button_Sprite.visible = true
	
	print("Game data saved...")
	print("size of saved inventory = ", gameData.playerInventory.size())


func _on_exit_button_pressed():
	#get_tree().quit()
	$Button.play()
	await $Button.finished
	$ExitConfirm.visible = true




func _on_yes_button_pressed():
	$Button.play()	
	await $Button.finished	
	get_tree().quit()
	


func _on_nope_button_pressed():
	$Button.play()	
	await $Button.finished	
	$ExitConfirm.visible = false
	
func _on_return_to_menu_button_pressed():
	$Button.play()
	await $Button.finished
	unpause()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_stay_button_pressed():
	$Button.play()	
	await $Button.finished	
	$MenuConfirm.visible = false




func _on_option_button_pressed():
	$Button.play()
	await $Button.finished
	$OptionsScreen.visible = true
