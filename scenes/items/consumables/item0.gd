extends RigidBody2D

class_name consumable

func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0.9
		linear_velocity.y *= 0.9

func effect(body):
	pass

func _on_area_2d_body_entered(body):
	
	effect(body)	
	#$RichTextLabel.visible = true
		

func _on_area_2d_body_exited(body):
	#if body.has_method("player"):
		#$RichTextLabel.visible = false
	pass
