extends Control

var is_open = true
@onready var backpack_slots = $GridContainer.get_children()

func _ready():
	#print("connection to update")
	#inventory.update.connect(update_slots)
	Globals.inv = Inventory.new()
	update_slots()
	#close()

func update_slots():
	for i in range(min(Globals.inv.bp_slots.size(), backpack_slots.size())):
		if Globals.inv.bp_slots[i]:
			backpack_slots[i].update(Globals.inv.bp_slots[i])

func _process(_delta):
	#if Input.is_action_pressed("open_inventory"):
		#open()
		pass
		
		
#func open():
	#self.visible = true
	#is_open = true
#
#func close():
	#self.visible = false
	#is_open = false
