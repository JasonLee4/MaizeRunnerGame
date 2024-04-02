extends Node

var itemArr = ["Torch", "wood", "Apple"]

var item_name = itemArr.pick_random()
var item = ResourceLoader.load("res://scenes/items/inventory/inv_items/" + item_name + ".tres")
	
func power_up():
	Globals.inv.insert(item)
	Globals.inv.insert(item)
	
func get_item_name():
	return item_name
