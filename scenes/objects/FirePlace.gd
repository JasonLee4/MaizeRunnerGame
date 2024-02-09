extends StaticBody2D

class_name FirePlace

@export var torch_item: Inv_Item
var crafting_available
#signal craft_torch

#may change how this works for future recipes
var req_resource : Inv_Item = preload("res://scenes/items/inventory/inv_items/wood.tres")

func _physics_process(delta):
	$AnimatedSprite2D.play()
	if Input.is_action_just_pressed("interact") and crafting_available:
		# get crafting ready
		#craft_torch.emit()
		if Globals.inv.contains(req_resource):
			if Globals.inv.get_amount(req_resource) >= 2:	
				Globals.inv.remove_item(req_resource, 2)
				print("crafting... ", torch_item.name)	
				Globals.inv.insert(torch_item)
		
		await get_tree().create_timer(1).timeout


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		crafting_available = true
		


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		crafting_available = false

