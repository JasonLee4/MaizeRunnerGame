extends RigidBody2D

@export var item: Inv_Item
@export var speed = 50
@export var light_on = true

@onready var timer = $Timer
@onready var light = $FlashlightLight

const max_brightness = .7
const min_brightness = .4

var pickup = true


	
	
func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0.01
		linear_velocity.y *= 0.01
		if contact_monitor:
			pickup = true
	if linear_velocity.length() < 1:
		pickup = true
	
	
		
	for body in $FlashlightArea.get_overlapping_bodies():
		if body.has_method("light_freeze"):
			body.light_freeze()





func _on_area_2d_body_entered(body):
	if body.has_method("player") and pickup:
		#body.collect(item)
		Globals.inv.insert(item)
		Globals.pig.change_tool(Globals.pig.curr_hb_num)
		queue_free()
	elif body.has_method("enemy"):
		body.take_damage(0)
		
		
		
	

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
