extends Node2D

@export var light_on = false

func _physics_process(_delta):
	flash()

func flash():
	$".".look_at(get_global_mouse_position())	
	$".".visible = light_on
	#$FlashlightLightShadows.visible = light_on
	$FlashlightArea/CollisionPolygon2D.disabled = !light_on
	
	if light_on:		
		for body in $FlashlightArea.get_overlapping_bodies():
			if body.has_method("light_freeze"):
				body.light_freeze()
	else:
		for body in $FlashlightArea.get_overlapping_bodies():
			if body.has_method("light_unfreeze"):
				body.light_unfreeze()

func _on_flashlight_area_body_exited(body):
	if body.has_method("light_unfreeze"):
		body.light_unfreeze()
