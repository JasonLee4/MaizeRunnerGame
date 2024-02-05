extends CharacterBody2D

var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")

@onready var state_machine = get_node("player_state_machine")
@onready var fire_place = get_tree().current_scene.get_node("FirePlace")

#Dash variable
var dashDirection = Vector2(1,0)
var dashready = true

var shootready = true

var punchready = true

@export var enemies_pig_can_attack = []
var invulnerable = false
var pig_alive = true
 
var can_basic_attack = true
#@export var speed = 150

var basic_damage = 50

var equipped = false
var curr_bullet_sprite

@export var inv: Inventory

#func on_item_picked_up(item_name: String):
	#inventory.add_item(item_name)
	#print(inventory.get_items())
#
func _ready():
	if fire_place:
		fire_place.craft_torch.connect(craft)
	
func craft():
	if inv.slots[0].amount >= 2:	
		print("crafting... using wood...")
		inv.remove_item(inv.slots[0].item, 2)	
		print(inv.slots[0].amount)
		pass


func _physics_process(delta):
	# run through states
	state_machine.process_states(delta)
	$piglight.look_at(get_global_mouse_position())
	
	if velocity != Vector2(0,0):
		if state_machine.selected_state.name == "state_rolling":
			$Sprite2D.visible = false
			$Roll.visible = true
			
			$AnimationPlayer.play("pigroll")
			
		elif state_machine.selected_state.name == "state_moving":
			$Sprite2D.visible = true
			$Roll.visible = false
			$AnimationPlayer.play("pigwalk")
		if velocity.x < 0:
			$Sprite2D.flip_h = true
			$weapon_sprite.flip_h = true
			$Roll.flip_h = true
			$Marker2D.position.x = -1 * abs($Marker2D.position.x)
			
		else:
			$Sprite2D.flip_h = false
			$weapon_sprite.flip_h = false
			$Roll.flip_h = false			
			$Marker2D.position.x = abs($Marker2D.position.x)
		
			
	else:
		$AnimationPlayer.stop()
	
		
		
	#get_input()
	
	move_and_slide()
	shoot()
	
	if Globals.health <= 0:
		pig_alive = false
		#Add end screen/respawn screen
		print("Pig is dead")
		self.queue_free()

#func dash(dashDirection) :
	#if Input.is_action_just_pressed("dash") and dashready:
		#velocity = dashDirection.normalized()*1200
		#dashready = false
		#$dash_cooldown.start()

func _on_dash_cooldown_timeout():
	print("dash is ready")
	dashready = true

func equip_weapon(weaponsprite, bulletsprite):
	#add_child(cannon_instance)	
	equipped = true
	$weapon_sprite.texture = load(weaponsprite)
	curr_bullet_sprite = load(bulletsprite)
	pass
	
	
	
#ranged ability
func shoot():
	if Input.is_action_just_pressed("shoot") and shootready and equipped:
		shootready = false
		var pb = pigbullet_scene.instantiate()
		pb.get_node("Sprite2D").texture = curr_bullet_sprite
		get_parent().add_child(pb)
		pb.global_position = $Marker2D.global_position
		var dir = (get_global_mouse_position() - pb.global_position).normalized()
		#pb.global_rotation = dir.angle() + PI / 2.0
		pb.direction = dir
		
		$shoot_cooldown.start()


func _on_shoot_cooldown_timeout():
	shootready = true



func _on_punch_hurtbox_area_entered(area):
	#print("punching area " + area.name)
	#if area.get_parent().has_method("enemy"):
		#print("testing punch...")
		#
		#area.get_parent().take_damage(basic_damage)
	pass

		


func _on_punch_cooldown_timeout():
	punchready = true


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

func receive_damage(damage):
	if not invulnerable:
		Globals.health = Globals.health - damage
		invulnerable = true
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		
		$dmg_iframe_cooldown.start()
		
		
		#print("player took ",damage," damage")
	
	

func set_invincible(time):
	$dmg_iframe_cooldown.wait_time = time
	$dmg_iframe_cooldown.start()
	
	invulnerable = true



func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false



func _on_piglightarea_body_entered(body):
	# weeping angel /freeze in place behavior
	if body.has_method("enemy"):
		body.freeze = true
	

func collect(item):
	print("collected ", item.name)
	inv.insert(item)
	print(inv.slots[0].item.name, inv.slots[0].amount)
	

	
