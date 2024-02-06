extends Node

signal health_change

var health = 5:
	get:
		return health
	set(value):
		health = value
		health_change.emit()

var pig

signal dungeon_created

var inv_size = 3
var inv:
	get:
		return inv
	set(value):
		#value.slots.resize(3)
		#value.slots.fill(Inventory_Slot.new())
		for sl in inv_size:
			value.slots.append(Inventory_Slot.new())
		
		inv = value

signal inv_update
