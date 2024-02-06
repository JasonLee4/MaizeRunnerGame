extends Control

var is_open = false
#@onready var inventory: Inventory = preload("res://scenes/items/inventory/piginv.tres")
@onready var slots = $GridContainer.get_children()

#var inventory = Globals.inv

func _ready():
	#print("connection to update")
	#inventory.update.connect(update_slots)
	Globals.inv = Inventory.new()
	
	update_slots()
	close()

func update_slots():
	for i in range(min(Globals.inv.slots.size(), slots.size())):
		if Globals.inv.slots[i]:
			slots[i].update(Globals.inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("q"):
		if is_open:
			close()
		else:
			open()

func open():
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false
