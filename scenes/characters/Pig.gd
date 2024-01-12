extends CharacterBody2D

var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
#Dash variable
var dashDirection = Vector2(1,0)

#var enemy_inattack_range = false
@export var enemies_pig_can_attack = []
var invulnerable = false
var pig_alive = true
 
var can_basic_attack = true
@export var speed = 400

var basic_damage = 50

func get_input():
	var input_direction = Input.get_vector("left","right" , "up", "down")
	velocity = input_direction * speed
	dash(input_direction)
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	attack()
	shoot()
	
	if Globals.health <= 0:
		pig_alive = false
		#Add end screen/respawn screen
		print("Pig is dead")
		self.queue_free()

func dash(dashDirection) :
	if Input.is_action_pressed("space"):
		velocity = dashDirection.normalized()*2000

func player():
	pass

func _on_pig_hitbox_body_entered(body):
	if body.has_method("enemy"):
		body.can_attack_player = true
		#enemy_inattack_range = true

func _on_pig_hitbox_body_exited(body):
	if body.has_method("enemy"):
		body.can_attack_player = false
		#enemy_inattack_range = false

func recieve_damage(damage):
	if not invulnerable:
		#Globals.health = Globals.health - damage
		invulnerable = true
		$dmg_iframe_cooldown.start()
		print("player took damage")
	pass

func _on_basic_attack_cooldown_timeout():
	$basic_attack_cooldown.stop()
	can_basic_attack = true
	
func attack():
	if Input.is_action_just_pressed("space"):
		$basic_attack_cooldown.start()
		can_basic_attack = false
		for enemy in enemies_pig_can_attack:
			enemy.recieve_damage(basic_damage)

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var pb = pigbullet_scene.instantiate()
		get_parent().add_child(pb)
		print("Pig shoot")		
		pb.global_position = $Marker2D.global_position
		var dir = (get_global_mouse_position() - pb.global_position).normalized()
		print("shooting pig's bullet")
		pb.global_rotation = dir.angle() + PI / 2.0
		pb.direction = dir


func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false
