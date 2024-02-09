extends Resource

class_name Inventory

signal update

var hb_slots: Array[Inventory_Slot] = []

var bp_slots: Array[Inventory_Slot] = []

func insert(item: Inv_Item):
	
	var slots
	if item.tool:
		slots = hb_slots
	else: 
		slots = bp_slots
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		print("stacking item : ", item.name)
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot) : return slot.item == null)
		if !emptyslots.is_empty():
			print("new item : ", item.name)
			
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			#print(slots[0].item.name)
	update.emit()
	pass

func remove_item(item, amount):
	print("removing item...")
	var slots
	if item.tool:
		slots = hb_slots
	else: 
		slots = bp_slots
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount -= amount
		if itemslots[0].amount == 0:
			itemslots[0].item = null
		update.emit()

func contains(item):
	for sl1 in hb_slots.filter(func(hb_slot) : return hb_slot.item == item):
		if sl1.amount > 0:
			return true
	for sl2 in bp_slots.filter(func(bp_slot) : return bp_slot.item == item):
		if sl2.amount > 0:
			return true
	return false		
	
func get_amount(item):
	var total = 0
	for sl1 in hb_slots.filter(func(hb_slot) : return hb_slot.item == item):
		total += sl1.amount
		
	for sl2 in bp_slots.filter(func(bp_slot) : return bp_slot.item == item):
		total += sl2.amount
	
	return total
