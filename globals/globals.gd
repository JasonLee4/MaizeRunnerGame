extends Node

var save_file_path = "res://saves/"
var save_file_name = "GameSave.tres"
var gameData
var new_game

var torch_item : Inv_Item  = preload("res://scenes/items/inventory/inv_items/Torch.tres")
var flash_item : Inv_Item = preload("res://scenes/items/inventory/inv_items/Flashlight.tres")
var apple_item : Inv_Item = preload("res://scenes/items/inventory/inv_items/Apple.tres")

var pig
var pig_speed = 100

### Health ###
signal health_change

var max_health = 5:
	get:
		return max_health
	set(value):
		max_health = value

var health = 5:
	get:
		return health
	set(value):
		health = value
		health_change.emit()

signal laser_energy_change
var laser_energy = 100:
	get:
		return laser_energy
	set(value):
		if value > 100:
			laser_energy = 100
		elif value < 0:
			laser_energy = 0
		else:
			laser_energy = value
		laser_energy_change.emit()

### Dungeon ###
signal dungeon_created

### Tooltip ###
signal tooltip_update
signal monologue(text)

### Inventory ###
signal inv_update

var hb_size = 3
var bp_size = 8
var inv :
	get:
		return inv
	set(value):
		print("size of new inventory = ", value.size())
		if value.size() == 0:
			print("reseting inv")
			for hb in hb_size:
				value.hb_slots.append(Inventory_Slot.new())
			for bp in bp_size:
				value.bp_slots.append(Inventory_Slot.new())
		inv = value
		inv.update.emit()


### Game/Level Stats ###
var cur_lvl = 1

signal lvl_start
signal lvl_end

var game_start_time = 0
var game_end_time:
	set(ts):
		game_end_time = format_ts_to_str(ts + game_start_time)

var lvl_start_time = null
var lvl_end_time = null
var lvl_time:
	get:
		var cur_time = Time.get_ticks_msec()
		if not lvl_start_time:
			return "00:00"
		if lvl_end_time:
			return format_ts_to_str(lvl_end_time - lvl_start_time)
		return format_ts_to_str(cur_time - lvl_start_time)

func go_next_lvl():
	lvl_start_time = null
	lvl_end_time = null
	cur_lvl += 1
	
func restart_game():
	health = 5
	laser_energy = 0
	lvl_start_time = null
	lvl_end_time = null
	#cur_lvl = 1
	if Globals.new_game:
		cur_lvl = 1
	# give player 10 torches and 5 apples to start
	inv = Inventory.new()
	if new_game:
		inv.insert(flash_item)
		for _i in range(10):
			inv.insert(torch_item)
		for _i in range(5):
			inv.insert(apple_item)
	
	
	

### Helper functions ###
func format_ts_to_str(timestamp):
	# probably a better way to do this but wtv
	var time_str = ""
	var mins = timestamp / 1000 / 60
	var secs = timestamp / 1000 % 60
	if mins >= 10:
		time_str += str(mins)
	else:
		time_str += "0" + str(mins)
	time_str += ":"
	if secs >= 10:
		time_str += str(secs)
	else:
		time_str += "0" + str(secs)
	
	return time_str

func increase_pig_speed(pct_increase):
	pig_speed *= (1.0 + pct_increase)

func verify_save_directory(path):
	DirAccess.make_dir_absolute(path)


func load_data():
	gameData = ResourceLoader.load(Globals.save_file_path + Globals.save_file_name)
	print("Game data loaded...")
	Globals.max_health = gameData.playerMaxHealth
	Globals.health = gameData.playerHealth
	Globals.laser_energy = gameData.laserEnergy
	#pig.position = Vector2(0,0)
	Globals.cur_lvl = gameData.currentLevel
	Globals.pig_speed = gameData.playerSpeed
	
	Globals.inv.transfer(gameData.playerInventory)
	print("Loaded new inventory size: ", Globals.inv.size())

	Globals.game_start_time = gameData.elapsedTime
