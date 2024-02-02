extends Control

var is_open = false
@onready var inventory = preload("res://scenes/items/inventory/piginv.tres")
@onready var slots = $GridContainer.get_children()



func _ready():
	inventory.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	print("updating slots")
	for i in range(min(inventory.slots.size(), slots.size())):
		print(i)
		slots[i].update(inventory.slots[i])

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
