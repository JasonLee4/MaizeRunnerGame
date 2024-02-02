extends Node2D

@export var item: Inv_Item

func _on_area_2d_body_entered(body):
	if body.has_method("collect"):
		body.collect(item)
		queue_free()
