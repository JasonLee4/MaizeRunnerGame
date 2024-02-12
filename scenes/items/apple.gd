extends Node2D


@export var item: Inv_Item

func effect():
	if Input.is_action_just_pressed("primary_action"):
		
		if Globals.health < 5:
			Globals.inv.remove_item(item, 1)
			
			Globals.health += 1






func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		#body.collect(item)
		Globals.inv.insert(item)
		queue_free()
