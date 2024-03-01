extends Control

#@export var item: Inv_Item

var itemArr = ["Torch", "wood", "Apple"]
var item
# Called when the node enters the scene tree for the first time.
func _ready():
	$Yay.play()
	$Sign.text = "Level " + str(Globals.cur_lvl) + " Complete"
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.grab_focus()
	var item_name = itemArr.pick_random()
	item = ResourceLoader.load("res://scenes/items/inventory/inv_items/" + item_name + ".tres")
	$VBoxContainer/HBoxContainer/VBoxContainer3/Power3.text = "\n+2 " + item_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_level():
	Globals.go_next_lvl()
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")

func _on_power_1_pressed():
	$Button.play()
	await $Button.finished
	Globals.max_health = Globals.max_health+1
	Globals.health = Globals.health+1
	next_level()


func _on_power_2_pressed():
	$Button.play()
	await $Button.finished
	# increase pig speed by 10 percent
	Globals.increase_pig_speed(.1)
	next_level()

func _on_power_3_pressed():
	$Button.play()
	await $Button.finished
	Globals.inv.insert(item)
	Globals.inv.insert(item)
	next_level()
	
