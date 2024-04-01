extends Control

#@export var item: Inv_Item
var powerTextArr = [["Extra Hungry"],["Light Hooves"],["Scavenge"]]
var itemArr = ["Torch", "wood", "Apple"]
var item
# Called when the node enters the scene tree for the first time.
func _ready():
	$Yay.play()
	$Sign.text = "Level " + str(Globals.cur_lvl) + " Complete"
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.grab_focus()
	var item_name = itemArr.pick_random()
	item = ResourceLoader.load("res://scenes/items/inventory/inv_items/" + item_name + ".tres")
	$VBoxContainer/HBoxContainer/VBoxContainer3/Power3.text = "+2 " + item_name
	$AnimatedSprite2D.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_level():
	Globals.go_next_lvl()
	if Globals.cur_lvl in [5, 10]:
		get_tree().change_scene_to_file("res://scenes/levels/boss_level.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")

func _on_get_power_1_pressed():
	$Button.play()
	await $Button.finished
	Globals.max_health = Globals.max_health+1
	Globals.health = Globals.health+1
	next_level()


func _on_get_power_1_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text+"[/shake]"

func _on_get_power_1_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = powerTextArr[0][0]

func _on_icon_button_1_pressed():
	_on_get_power_1_pressed()

func _on_icon_button_1_mouse_entered():
	_on_get_power_1_mouse_entered()
	
func _on_icon_button_1_mouse_exited():
	_on_get_power_1_mouse_exited()
	

func _on_get_power_2_pressed():
	$Button.play()
	await $Button.finished
	# increase pig speed by 10 percent
	Globals.increase_pig_speed(.1)
	next_level()

func _on_get_power_2_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text+"[/shake]"


func _on_get_power_2_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = powerTextArr[1][0]

func _on_icon_button_2_pressed():
	_on_get_power_2_pressed()

func _on_icon_button_2_mouse_entered():
	_on_get_power_2_mouse_entered()
	
func _on_icon_button_2_mouse_exited():
	_on_get_power_2_mouse_exited()
	
func _on_get_power_3_pressed():
	$Button.play()
	await $Button.finished
	Globals.inv.insert(item)
	Globals.inv.insert(item)
	next_level()
	
func _on_get_power_3_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text+"[/shake]"


func _on_get_power_3_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text = powerTextArr[2][0]

func _on_icon_button_3_pressed():
	_on_get_power_3_pressed()

func _on_icon_button_3_mouse_entered():
	_on_get_power_3_mouse_entered()
	
func _on_icon_button_3_mouse_exited():
	_on_get_power_3_mouse_exited()








