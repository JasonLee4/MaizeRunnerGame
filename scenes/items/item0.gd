extends RigidBody2D

func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0.9
		linear_velocity.y *= 0.9


func _on_area_2d_body_entered(body):
	if body.has_method("player") and Globals.health < 5:
		print("WANT APPLE")
		queue_free()
		Globals.health += 1
		
		
		
	$RichTextLabel.visible = true
		

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		$RichTextLabel.visible = false
