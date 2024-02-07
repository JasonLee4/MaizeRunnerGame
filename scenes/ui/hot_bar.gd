extends Control

var is_open = true
@onready var slots = $GridContainer.get_children()

func _ready():
	#print("connection to update")
	#inventory.update.connect(update_slots)
	Globals.inv = Inventory.new()
	
	update_slots()
	open()

func update_slots():
	for i in range(min(Globals.inv.slots.size(), slots.size())):
		if Globals.inv.slots[i]:
			slots[i].update(Globals.inv.slots[i])

func _process(_delta):
	pass

func open():
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false
