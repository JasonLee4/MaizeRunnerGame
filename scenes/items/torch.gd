extends RigidBody2D

@export var item: Inv_Item
@export var light_radius = 1.0
#@export var speed = 100
#@export var damage = 20
#var direction = Vector2.LEFT
	
#func _ready():
	#$SelfdestructTimer.start()
	
var placed = false	


func _ready():
	$Torch_Timer.start()
	$PointLight2D.scale = 3 * Vector2(light_radius, light_radius)
	
func _physics_process(delta):
	#translate(direction*speed*delta)
	#linear_velocity.x *= 0.9
	#linear_velocity.y *= 0.9
	$AnimatedSprite2D.play()
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity *= 0.01
		angular_velocity = -1
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
		body.take_damage(body.MAX_HEALTH)
		$GPUParticles2D.emitting = true
		#body.queue_free()
		#queue_free()


func _on_torch_timer_timeout():
	$PointLight2D/Torch_Light_Area/CollisionShape2D.disabled = true
	queue_free()


func _on_shrink_timer_timeout():
	$PointLight2D.scale *= 0.8
	$Torch_light_shadow.scale *= 0.8
	$PointLight2D/Torch_Light_Area/CollisionShape2D.scale *= 0.8
	
	
