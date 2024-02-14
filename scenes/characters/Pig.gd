extends CharacterBody2D


var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
var torch_scene = preload("res://scenes/items/torch.tscn")
var torch_resource = preload("res://scenes/items/inventory/inv_items/Torch.tres")

@onready var state_machine = get_node("player_state_machine")
#@onready var fire_place = get_tree().current_scene.get_node("FirePlace")
@onready var hotbar = get_tree().current_scene.get_node("UI").get_node("HotBar")

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

var flashlight = false
var flashlight_equipped = false

var torch_equipped = false
var torch_hold_time = 0.0
var torch_speed = 10

var current_tool
var consumable_equipped = false
var temp_speed
var hold_time = 0.0
#@export var inv: Inventory


func _ready():

	#inv.update.connect(hotbar.update_slots)

	Globals.pig = $"."
	print("pig inst")
	hotbar.connect("hotbar_select", change_tool)
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
	$piglight_shadows.look_at(get_global_mouse_position())
	
	
	
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
			$Torch_Sprite.rotation = abs($Torch_Sprite.rotation)
			
			$Roll.flip_h = true
			$Marker2D.position.x = abs($Marker2D.position.x)
			
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
			$weapon_sprite.flip_h = false
			$Torch_Sprite.rotation = -1*abs($Torch_Sprite.rotation)
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

	if flashlight_equipped:	
		toggle_flashlight()

	flash()
	if !flashlight_equipped and torch_equipped:
		use_torch(delta)
	
	if consumable_equipped:
		consumable_use(delta)


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
	if Input.is_action_just_pressed("primary_action") and shootready and equipped:
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
	
	
func use_torch(delta):
	if Globals.inv.contains(torch_resource):
		#if Globals.inv.slots[1].amount > 0:
			if Input.is_action_just_pressed("primary_action"):
				torch_hold_time = 0.0
				
				
				Globals.inv.remove_item(torch_resource, 1)
				var tr = torch_scene.instantiate()			
				tr.placed = true
				
				tr.global_position = $Marker2D2.global_position
				tr.linear_velocity = Vector2(0,0)
				
				get_tree().current_scene.add_child(tr)
				
				torch_speed = 0
			elif Input.is_action_pressed("secondary_action"):
				if torch_speed < 100:
					torch_speed += 5
				torch_hold_time += delta
			elif Input.is_action_just_released("secondary_action"):
				Globals.inv.remove_item(torch_resource, 1)
				var tr = torch_scene.instantiate()			
				
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
		$Torch_Sprite.visible = false
			
func toggle_flashlight():
	if Input.is_action_just_pressed("primary_action"):
		flashlight = !flashlight
		
		
	
			
func flash():
	$piglight.visible = flashlight
	$piglight_shadows.visible = flashlight
	$piglight/piglightarea/CollisionPolygon2D.disabled = !flashlight
	
	if flashlight:
		#$piglight/piglightarea/CollisionPolygon2D.disabled = false
		
		for body in $piglight/piglightarea.get_overlapping_bodies():
			if body.has_method("light_freeze"):
				body.light_freeze()
	else:
		#$piglight/piglightarea/CollisionPolygon2D.disabled = true
		
		for body in $piglight/piglightarea.get_overlapping_bodies():
			if body.has_method("light_unfreeze"):
				body.light_unfreeze()


func change_tool(hb_num):
	
	current_tool = Globals.inv.hb_slots[hb_num]
	if current_tool.item != null:
		flashlight_equipped = (current_tool.item.name == "Flashlight")
		flashlight = (current_tool.item.name == "Flashlight")
		torch_equipped = (current_tool.item.name == "Torch")
		consumable_equipped = !(flashlight_equipped or torch_equipped)
	else:
		torch_equipped = false
		flashlight_equipped = false
		flashlight = false
	return toggle_tool_sprites()
	
func toggle_tool_sprites():
	$Torch_Sprite.visible = torch_equipped
	$Flashlight_Sprite.visible = flashlight_equipped
	return 0

func consumable_use(delta):
	var toolString = current_tool.item.useScript
	var consScript = ResourceLoader.load(toolString)
	var cons = consScript.instantiate()
	cons.effect(delta)
	
	#assuming all consumables have speed
	temp_speed = cons.speed
	if Input.is_action_pressed("secondary_action"):
		if temp_speed < 100:
			temp_speed += 5
		hold_time += delta
	elif Input.is_action_just_released("secondary_action"):
		Globals.inv.remove_item(current_tool.item, 1)
		#var temp_apple = load("res://scenes/items/apple.tscn").instantiate()
		
		hold_time = 0.0
		
		cons.global_position = $Marker2D2.global_position
		var dir = (get_global_mouse_position() - cons.global_position).normalized()
		cons.linear_velocity.x = dir.x*temp_speed
		cons.linear_velocity.y = dir.y*temp_speed
		
		cons.pickup = false
		
		Globals.pig.get_tree().current_scene.add_child(cons)
		temp_speed = 0
	if current_tool.amount == 0:		
		consumable_equipped = false
	
