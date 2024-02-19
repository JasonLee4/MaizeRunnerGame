extends RigidBody2D


@export var item: Inv_Item
@export var speed = 70
var pickup = true
#func _ready():
	#$Area2D/CollisionShape2D.disabled = true

func effect(delta):
	if Input.is_action_just_pressed("primary_action"):
		
		if Globals.health < 5:
			Globals.inv.remove_item(item, 1)
			
			Globals.health += 1

	
	
func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		if contact_monitor:
			pickup = true
	if linear_velocity.length() < 1:
		pickup = true
	
	pass





func _on_area_2d_body_entered(body):
	if body.has_method("player") and pickup:
		#body.collect(item)
		Globals.inv.insert(item)
		queue_free()
	elif body.has_method("enemy"):
		body.take_damage(0)
