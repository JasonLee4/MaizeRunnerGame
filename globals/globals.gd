extends Node
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



### Dungeon ###
signal dungeon_created

### Tooltip ###
signal tooltip_update

### Inventory ###
signal inv_update

var hb_size = 3
var bp_size = 8
var inv :
	get:
		return inv
	set(value):
		print("reseting inv")
		for hb in hb_size:
			value.hb_slots.append(Inventory_Slot.new())
		for bp in bp_size:
			value.bp_slots.append(Inventory_Slot.new())
		inv = value
		


### Game/Level Stats ###
var cur_lvl = 1

signal lvl_start
signal lvl_end

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
	
	lvl_start_time = null
	lvl_end_time = null
	cur_lvl = 1
	
	# give player 10 torches and 5 apples to start
	inv = Inventory.new()
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

func increase_pig_speed():
	pig_speed += 50
