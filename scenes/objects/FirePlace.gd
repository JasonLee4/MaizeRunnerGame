extends StaticBody2D

class_name FirePlace

var crafting_available
signal craft_torch

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and crafting_available:
		# get crafting ready
		craft_torch.emit()
		await get_tree().create_timer(1).timeout


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		crafting_available = true
		


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		crafting_available = false

