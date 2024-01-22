extends StaticBody2D

var canopen = false
var opened = false
var apple = preload("res://scenes/items/consumables/apple.tscn")

func _process(delta):
	if !opened:
		$AnimatedSprite2D.stop()
		
	
	if Input.is_action_pressed("interact") and canopen and !opened:
		print("opened chest")
		$AnimatedSprite2D.play("chestanimation")
		
		opened = true
		await get_tree().create_timer(0.5).timeout
		var treasure0 = apple.instantiate()
		get_parent().add_child(treasure0)
		treasure0.global_position = $Marker2D.global_position
		#hop out
		treasure0.hop()
	
		
		

func _on_area_2d_area_entered(area):
	print(area.name)
	if area.name == "pig_hitbox":
		canopen = true	



func _on_area_2d_area_exited(area):
	if area.name == "pig_hitbox":
		canopen = false
