extends StaticBody2D

var open = false


func __process(delta):
	if Input.is_action_pressed("interact") and open:
		print("opened chest")
		#$Sprite2D.texture = load()
		

func _on_area_2d_area_entered(area):
	print(area.name)
	if area.name == "pig_hitbox":
		open = true	
	
	



func _on_area_2d_area_exited(area):
	if area.name == "pig_hitbox":
		open = false
