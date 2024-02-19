extends Control

@export var item: Inv_Item

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/VBoxContainer2/Power1.grab_focus()

func _process(delta):
	pass


func _on_power_1_pressed():
	Globals.health = Globals.health+1
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	pass # Replace with function body.


func _on_power_2_pressed():
	Globals.pig.speed = Globals.pig.speed+10
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	pass # Replace with function body.


func _on_power_3_pressed():
	Globals.inv.insert(item)
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	pass # Replace with function body.
