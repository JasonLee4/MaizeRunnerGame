extends Control

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if(not get_tree().paused):
			pause()
		else:
			unpause()

func pause():
	visible = true
	get_tree().paused = true
	
func unpause():
	visible = false
	get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_continue_button_pressed():
	unpause()

func _on_return_button_pressed():
	unpause()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_save_button_pressed():
	save_data()

func save_data():
	var gameData = GameData.new()
	gameData.update_playerMaxHealth(Globals.max_health)
	gameData.update_playerHealth(Globals.health)
	gameData.update_currentLevel(Globals.cur_lvl)
	gameData.update_playerSpeed(Globals.pig_speed)
	gameData.update_playerInventory(Globals.inv)
	ResourceSaver.save(gameData, Globals.save_file_path + Globals.save_file_name)
	print("Game data saved...")
	print("size of saved inventory = ", gameData.playerInventory.size())
