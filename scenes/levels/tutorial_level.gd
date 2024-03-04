extends Node2D

var ui_scene = preload("res://scenes/ui/ui.tscn")
var player_scene = preload("res://scenes/characters/pig.tscn")
var rat_enemy = preload("res://scenes/enemies/rat.tscn")
var ui
@onready var key_item : Inv_Item = preload("res://scenes/items/inventory/inv_items/key.tres")

func _ready():
	Globals.restart_game()
	
	# add ui
	print("Loading UI...")
	ui = ui_scene.instantiate()
	add_child(ui)
	
	# spawn pig
	var player = player_scene.instantiate()
	$Player.add_child(player)
	Globals.pig = player
	player.position = $Player/Marker2D.global_position
	
	# spawn rats
	for rat_pos in $Enemies.get_children():
		var rat = rat_enemy.instantiate()
		rat.global_position = rat_pos.global_position
		$Enemies.add_child(rat)
	
	$Objects/FirePlace.set_key_guide($Items/Key.global_position)
	$Objects/FirePlace.set_exit_guide($Objects/Exit.global_position)
	
	# make sure starting torches don't expire
	for torch in $Objects/Torches.get_children():
		torch.expires = false
	


func _on_finish_body_entered(body):
	if Globals.inv.contains(key_item):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
