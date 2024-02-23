extends Node2D

@onready var key_item : Inv_Item = preload("res://scenes/items/inventory/inv_items/key.tres")

func _on_area_2d_body_entered(body):
	if not body.has_method("player"):
		return
	if Globals.inv.contains(key_item):
		# consume the key
		Globals.inv.remove_item(key_item, 1)
		# go to next level
		Globals.lvl_end.emit()
		get_tree().change_scene_to_file("res://scenes/menus/power_up_screen.tscn")
