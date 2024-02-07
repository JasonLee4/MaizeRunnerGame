extends Node2D

@export var item: Inv_Item

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		Globals.inv.insert(item)
		queue_free()
		print("GOT KEY INSIDE")
	print("GOT KEY")
	Globals.lvl_end.emit()
