extends Control

@export var item: Inv_Item

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_power_1_pressed():
	Globals.health = Globals.health+1
	Globals.go_next_lvl()
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")


func _on_power_2_pressed():
	Globals.pig.get_node("player_state_machine").get_node("state_moving").max_spd = Globals.pig.get_node("player_state_machine").get_node("state_moving").max_spd+100
	Globals.go_next_lvl()
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")


func _on_power_3_pressed():
	Globals.inv.insert(item)
	Globals.go_next_lvl()
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
