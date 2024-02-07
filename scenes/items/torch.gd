extends RigidBody2D

@export var item: Inv_Item
#@export var speed = 100
#@export var damage = 20
#var direction = Vector2.LEFT
	
#func _ready():
	#$SelfdestructTimer.start()
	
var placed = false	
#
func _physics_process(delta):
	#translate(direction*speed*delta)
	#linear_velocity.x *= 0.9
	#linear_velocity.y *= 0.9
	$AnimatedSprite2D.play()
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0.01
		linear_velocity.y *= 0.01
	if linear_velocity.length() < 2:
		placed = true
	torch()


func torch():
	for body in $PointLight2D/Torch_Light_Area.get_overlapping_bodies():
		if body.has_method("light_freeze"):
			body.light_freeze()
			pass



func _on_torch_light_area_body_exited(body):
	if body.has_method("light_unfreeze"):
		print(body.name, " left torch light area")
		body.light_unfreeze()


func _on_torch_hitbox_body_entered(body):
	if body.has_method("enemy") and !placed:
		body.take_damage(body.MAX_HEALTH/2)
		#body.queue_free()
		#queue_free()
