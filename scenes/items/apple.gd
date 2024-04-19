extends RigidBody2D


@export var item: Inv_Item
@export var speed = 70
@export var thrown = false
var pickup = true

func _ready():
	await get_tree().create_timer(2).timeout
	pickup = true
	

func effect(delta):
	if Input.is_action_just_pressed("primary_action"):
		
		if Globals.health > 0  and Globals.health < Globals.max_health:
			
			Globals.pig.get_node("Eat").play()
			
			Globals.inv.remove_item(item, 1)
			
			Globals.health += 1
			Globals.pig.get_node("Sprite2D").visible = false	
			Globals.pig.get_node("Eating").visible = true
			
			Globals.pig.get_node("AnimationPlayer").play("eating_apple")
			await Globals.pig.get_tree().create_timer(0.7).timeout
			Globals.pig.get_node("Sprite2D").visible = true	
			Globals.pig.get_node("Eating").visible = false

	
	
func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		if contact_monitor:
			pickup = true
			angular_velocity *= -2
			linear_velocity *= 0.6
	
	if linear_velocity.length() < 30:
		pickup = true
	

	pass





func _on_area_2d_body_entered(body):
	if body.has_method("player") and pickup:
		#body.collect(item)
		Globals.inv.insert(item)
		pickup = false
		$Pickup.play()
		visible = false
		await $Pickup.finished
		queue_free()
	elif body.has_method("enemy") and thrown:
		body.take_damage(Globals.apple_damage)
		if Globals.apple_poison:
			print("enemy taking poison")
			body.take_poison()
