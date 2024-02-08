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

var inv_size = 3
var inv :
	get:
		return inv
	set(value):
		#value.slots.resize(3)
		#value.slots.fill(Inventory_Slot.new())
		for sl in inv_size:
			value.slots.append(Inventory_Slot.new())
		print(value)
		inv = value
		


### Game/Level Stats ###
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

func restart_game():
	health = 5
	inv = Inventory.new()
	lvl_start_time = null
	lvl_end_time = null
	
	

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
