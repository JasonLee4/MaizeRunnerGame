extends Node2D

signal enter_north
signal enter_east
signal enter_west
signal enter_south

@export var explored = false
@onready var player: CharacterBody2D

func _on_entrance_n_player_moved_rooms():
	enter_north.emit()

func _on_entrance_e_player_moved_rooms():
	enter_east.emit()
	
func _on_entrance_s_player_moved_rooms():
	enter_south.emit()
	
func _on_entrance_w_player_moved_rooms():
	enter_west.emit()

func spawn_player(player_scene: PackedScene, location: CONST.Dir):
	player = player_scene.instantiate()
	print("spawned pig")
	if location == CONST.Dir.North:
		player.position = $EntranceN.position + Vector2(0, 100)
	if location == CONST.Dir.East:
		player.position = $EntranceE.position + Vector2(-100, 0)
	if location == CONST.Dir.South:
		player.position = $EntranceS.position + Vector2(0, -100)
	if location == CONST.Dir.West:
		player.position = $EntranceW.position + Vector2(100, 0)
	$".".add_child(player)

func despawn_player():
	player.queue_free()

func set_entrances(north: bool, east: bool, south: bool, west: bool):
	$EntranceN.visible = north
	$EntranceE.visible = east
	$EntranceS.visible = south
	$EntranceW.visible = west
