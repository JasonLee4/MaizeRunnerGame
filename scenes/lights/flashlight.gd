extends Node2D

@export var light_on = false
@export var equipped = false
@onready var timer = $Timer
@onready var light = $FlashlightLight

const max_brightness = .7
const min_brightness = .4

func _physics_process(_delta):
	flash()

func flash():
	$".".look_at(get_global_mouse_position())	
	#$".".visible = light_on
	$FlashlightLight.visible = light_on
	$FlashlightLightShadows.visible = light_on
	$LightOccluder2D.visible = light_on
	$Sprite2D.visible = equipped
	if not equipped:
		$FlashlightLight.visible = false
		$FlashlightLightShadows.visible = false
		$LightOccluder2D.visible = false
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


func _on_timer_timeout():
	# add flashlight flicker
	var rand_amt = randf()
	if rand_amt > max_brightness:
		light.energy = max_brightness
		timer.start(1)
	elif rand_amt < min_brightness:
		light.energy = min_brightness
		timer.start(.1)
	else:
		light.energy = rand_amt
		timer.start(rand_amt/randf_range(1,20))
	
	
