extends RigidBody2D

@export var item: Inv_Item
@export var light_radius = 1.0
@export var expires  = true
@onready var light = $PointLight2D
	
var placed = false
var abt_to_expire = false
var decreasing = true


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
	
	if abt_to_expire:
		flicker()


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
		body.take_damage(100)
		$GPUParticles2D.global_position = body.global_position
		$GPUParticles2D.emitting = true
		#body.queue_free()
		#queue_free()


func _on_torch_timer_timeout():
	if not expires:
		return
	$PointLight2D/Torch_Light_Area/CollisionShape2D.disabled = true
	queue_free()


func _on_shrink_timer_timeout():
	if not expires:
		return
	abt_to_expire = true

func flicker():
	if decreasing:
		if light.energy >= .2:
			light.energy -= .02
		else:
			decreasing = false
	else:
		if light.energy <= .5:
			light.energy += .02
		else:
			decreasing = true

