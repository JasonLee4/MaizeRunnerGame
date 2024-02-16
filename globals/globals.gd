extends Node

var pig

### Health ###
signal health_change

var health = 5:
	get:
		return health
	set(value):
		health = value
		health_change.emit()



### Dungeon ###
signal dungeon_created


### Inventory ###
signal inv_update

var hb_size = 3
var bp_size = 8
var inv :
	get:
		return inv
	set(value):
		#value.slots.resize(3)
		#value.slots.fill(Inventory_Slot.new())
		for hb in hb_size:
			value.hb_slots.append(Inventory_Slot.new())
			
			###GIVING PLAYER 5 TORCHES INITIALLY
			if hb == 0:
				for i in range(0,5):
					var temp_torch : Inv_Item  = preload("res://scenes/items/inventory/inv_items/Torch.tres")
					value.insert(temp_torch)
			###GIVING PLAYER 5 TORCHES INITIALLY
			if hb == 1:
				var temp_flash : Inv_Item = preload("res://scenes/items/inventory/inv_items/Flashlight.tres")
				value.insert(temp_flash)
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
	inv = Inventory.new()
	lvl_start_time = null
	lvl_end_time = null
	cur_lvl = 1
	
	

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
