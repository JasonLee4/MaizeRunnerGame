extends CharacterBody2D


var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
var torch_scene = preload("res://scenes/items/torch.tscn")

@onready var state_machine = get_node("player_state_machine")
@onready var fire_place = get_tree().current_scene.get_node("FirePlace")
#@onready var hotbar = get_tree().current_scene.get_node("UI").get_node("HotBar")

var dashDirection = Vector2(1,0)
var dashready = true

var shootready = true

var punchready = true

@export var enemies_pig_can_attack = []
var invulnerable = false
var pig_alive = true
 
var can_basic_attack = true

var basic_damage = 50

var equipped = false
var curr_bullet_sprite

var flashlight = true
var torch_hold_time = 2.0
var torch_speed = 0

#@export var inv: Inventory


func _ready():

	#inv.update.connect(hotbar.update_slots)

	Globals.pig = $"."
	
	print("pig inst")
	#if fire_place:
		#fire_place.craft_torch.connect(craft)

	
#func craft():
	#if inv.slots[0].amount >= 2:	
		#print("crafting... using wood...")
		#inv.remove_item(inv.slots[0].item, 2)	
		#print(inv.slots[0].amount)
		#collect(fire_place.inv_item)
		
	#print("crafting... using coal and wood...")
	#inv.remove_item2(["Wood", "Coal"], [2,1])	
		
	


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
			$Tool_Sprite.rotation = abs($Tool_Sprite.rotation)
			
			$Roll.flip_h = true
			$Marker2D.position.x = abs($Marker2D.position.x)
			
		else:
			$Sprite2D.flip_h = false
			$weapon_sprite.flip_h = false
			$Tool_Sprite.rotation = -1*abs($Tool_Sprite.rotation)
			$Roll.flip_h = false			
			$Marker2D.position.x = abs($Marker2D.position.x)
		
			
	else:
		$AnimationPlayer.stop()
	
		
		
	
	move_and_slide()
	shoot()
	
	if Globals.health <= 0:
		pig_alive = false
		print("Pig is dead")
		get_tree().change_scene_to_file("res://scenes/menus/end_screen.tscn")
		self.queue_free()

	tool_scroll()

	toggle_flashlight()
	
	flash()
	if !flashlight:
		throw_torch(delta)



func _on_dash_cooldown_timeout():
	print("dash is ready")
	dashready = true

func equip_weapon(weaponsprite, bulletsprite):
	equipped = true
	$weapon_sprite.texture = load(weaponsprite)
	$weapon_sprite.visible = true
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






func player():
	pass

func _on_pig_hitbox_body_entered(body):
	if body.has_method("enemy"):
		print(body)
		body.can_attack_player = true
		
		

func _on_pig_hitbox_body_exited(body):
	if body.has_method("enemy"):
		body.can_attack_player = false
		

func receive_damage(damage):
	if not invulnerable:
		Globals.health = Globals.health - damage
		invulnerable = true
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		
		$dmg_iframe_cooldown.start()
		
		
	
	

func set_invincible(time):
	$dmg_iframe_cooldown.wait_time = time
	$dmg_iframe_cooldown.start()
	
	invulnerable = true



func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false




func _on_piglightarea_body_exited(body):
	if body.has_method("light_unfreeze"):
		body.light_unfreeze()

	
func throw_torch(delta):
	if Globals.inv.contains("Torch"):	
		#if Globals.inv.slots[1].amount > 0:
			print("has torch ", Globals.inv.contains("Torch"))
			if Input.is_action_pressed("punch"):
				if torch_hold_time > 2 and torch_speed < 100:
					torch_speed += 5
				torch_hold_time += delta
			elif Input.is_action_just_released("punch"):
				Globals.inv.remove_item("Torch", 1)
				var tr = torch_scene.instantiate()			
				#hold button for at least x=3 seconds
				if torch_hold_time < 2:
					torch_speed = 0
					tr.placed = true		
				torch_hold_time = 0.0
				
				tr.global_position = $Marker2D2.global_position
				var dir = (get_global_mouse_position() - tr.global_position).normalized()
				tr.linear_velocity.x = dir.x*torch_speed
				tr.linear_velocity.y = dir.y*torch_speed
				
				get_tree().current_scene.add_child(tr)
				
				torch_speed = 0
		#else:
			#$Tool_Sprite.visible = false
	else:
		$Tool_Sprite.visible = false
			
func toggle_flashlight():
	if Input.is_action_just_pressed("shoot"):
		flashlight = !flashlight
		print("toggle flashlight ", flashlight)
	
			
func flash():
	$piglight.visible = flashlight
	if flashlight:
		$piglight/piglightarea/CollisionPolygon2D.disabled = false
		
		for body in $piglight/piglightarea.get_overlapping_bodies():
			if body.has_method("light_freeze"):
				body.light_freeze()
	else:
		$piglight/piglightarea/CollisionPolygon2D.disabled = true
		for body in $piglight/piglightarea.get_overlapping_bodies():
			if body.has_method("light_unfreeze"):
				body.light_unfreeze()

	
func tool_scroll():
	
	if !flashlight:
		if Input.is_action_just_pressed("scroll_up"):
			flashlight = true
			print("toggle flash")
			$Tool_Sprite.visible = false
			
	else:	
		if Input.is_action_just_pressed("scroll_down"):
			flashlight = false
			print("toggle torch")
			$Tool_Sprite.visible = true
			
		


