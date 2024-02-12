extends Node2D

@onready var key_scene = preload("res://scenes/items/key.tscn")


func _on_area_2d_body_entered(body):
	if not body.has_method("player"):
		return
	if Globals.inv.contains(key_scene.instantiate().item):
		Globals.lvl_end.emit()
		get_tree().change_scene_to_file("res://scenes/menus/you_won_screen.tscn")
