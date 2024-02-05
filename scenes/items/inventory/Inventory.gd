extends Resource

class_name Inventory

signal update

@export var slots: Array[Inventory_Slot]

func insert(item: Inv_Item):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		print("stacking item")
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot) : return slot.item ==  null)
		if !emptyslots.is_empty():
			print("new item")
			print(item.name)
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			#print(slots[0].item.name)
	update.emit()
	pass

func remove_item(item: Inv_Item, amount):
	print("removing item...")
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount -= amount
		update.emit()
#func add_item(item):
	#if _content.has(item):
		#_content[item] += 1
		#
	#else:
		#_content[item] = 4
		#
#
#func remove_item(item):
	#
	#if _content.has(item) and _content[item] > 0:
		#_content[item] -= 1
	#
#func get_items():
	#return _content
