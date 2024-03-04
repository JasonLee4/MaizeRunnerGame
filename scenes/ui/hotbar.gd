extends Control

var is_open = true
@onready var hb_slots = $GridContainer.get_children()

signal hotbar_select

var curr_idx : int:
	set(value):
		curr_idx = value
		reset_focus()
		set_focus()

func _ready():
	#print("connection to update")
	#Globals.inv.update.connect(update_slots)
	curr_idx = 0
	update_slots()
	open()
	
	

func _process(delta):
	for i in [1,2,3]:
		if Input.is_action_just_pressed(str(i)):
			print("hotbar select : ", i)
			curr_idx = i-1
			# choose tool send to pig
			#hotbar_select.emit(curr_idx)
			
			hotbar_select.emit(curr_idx)
	pass


func update_slots():
	if not Globals.inv:
		print("No inventory")
		return
	for i in range(min(Globals.inv.hb_slots.size(), hb_slots.size())):
		if Globals.inv.hb_slots[i]:
			hb_slots[i].update(Globals.inv.hb_slots[i])




func set_focus():
	$GridContainer.get_child(curr_idx).grab_focus()
	$GridContainer.get_child(curr_idx).set_process_input(false)
	
func reset_focus():
	for slot in hb_slots:
		slot.set_process_input(false)

func open():
	self.visible = true
	is_open = true

func close():
	visible = false
	is_open = false
