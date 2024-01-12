extends CharacterBody2D

var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
#Dash variable
var dashDirection = Vector2(1,0)

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var pig_alive = true

@export var pig_current_attack = false

@export var speed = 400
func get_input():
	var input_direction = Input.get_vector("left","right" , "up", "down")
	velocity = input_direction * speed
	dash(input_direction)
	
func _physics_process(delta):
	enemy_attack()
	attack()
	get_input()
	move_and_slide()
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
		enemy_inattack_range = true

func _on_pig_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		#Globals.health = Globals.health - 1
		enemy_attack_cooldown = false
		$enemy_attack_cooldown.start()
		print("player took damage")
	pass
 
func _on_enemy_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_basic_attack_cooldown_timeout():
	$basic_attack_cooldown.stop()
	pig_current_attack = false
	
func attack():
	if Input.is_action_just_pressed("space"):
		$basic_attack_cooldown.start()
		pig_current_attack = true

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var pb = pigbullet_scene.instantiate()
		get_parent().get_node("spawnedobjects").add_child(pb)
		print("Pig shoot")		
		pb.global_position = $Marker2D.global_position
		var dir = (get_global_mouse_position() - pb.global_position).normalized()
		print("shooting pig's bullet")
		pb.global_rotation = dir.angle() + PI / 2.0
		pb.direction = dir
