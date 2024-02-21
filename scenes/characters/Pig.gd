extends CharacterBody2D


var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
var torch_scene = preload("res://scenes/items/torch.tscn")
var torch_resource = preload("res://scenes/items/inventory/inv_items/Torch.tres")
var flashlight_scene = preload("res://scenes/items/Flashlight.tscn")
var flashlight_resource = preload("res://scenes/items/inventory/inv_items/Flashlight.tres")

@onready var traj_line = $trajectory_line
@onready var state_machine = get_node("player_state_machine")
@onready var hotbar = get_tree().current_scene.get_node("UI").get_node("HotBar")
@onready var flashlight = $Flashlight


var dashready = true



var invulnerable = false
var pig_alive = true
 



var flashlight_equipped = false

var torch_equipped = false
var torch_hold_time = 0.0
var torch_speed = 10

var current_tool
var curr_hb_num

var consumable_equipped = false
var temp_speed = 0
var hold_time = 0.0
#@export var inv: Inventory
signal camera_shake


func _ready():

	Globals.pig = $"."
	print("pig inst")
	hotbar.connect("hotbar_select", change_tool)
	$Sprite2D.frame = 3
	change_tool(0)
	traj_line.clear_points()
	
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
	traj_line.look_at(get_global_mouse_position())
	
	if velocity != Vector2(0,0):
		if state_machine.selected_state.name == "state_rolling":
			$Sprite2D.visible = false
			$Roll.visible = true
			
			$AnimationPlayer.play("pigroll")
		elif state_machine.selected_state.name == "state_moving":
			$Sprite2D.visible = true
			$Roll.visible = false
			if flashlight_equipped or torch_equipped:
				$AnimationPlayer.play("pigwalk_equip")
			else:
				$AnimationPlayer.play("pigwalk")
				
		elif state_machine.selected_state.name == "state_idle":
			$Sprite2D.visible = true
			$Roll.visible = false
			$AnimationPlayer.stop()
			
		if velocity.x < 0:
			$Sprite2D.flip_h = true
			$weapon_sprite.flip_h = true
			$Torch.rotation = abs($Torch.rotation)
			
			$Roll.flip_h = true
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
			$weapon_sprite.flip_h = false
			$Torch.rotation = -1*abs($Torch.rotation)
			$Roll.flip_h = false			
		
	else:
		$AnimationPlayer.stop()
	
	
	move_and_slide()
	#shoot()
	
	if Globals.health <= 0:
		pig_alive = false
		print("Pig is dead")
		Globals.lvl_end.emit()
		get_tree().change_scene_to_file("res://scenes/menus/end_screen.tscn")
		self.queue_free()

	if flashlight_equipped:	
		flashlight.visible = true
		toggle_flashlight(delta)
	
	if !flashlight_equipped and torch_equipped:
		use_torch(delta)
	
	if consumable_equipped:
		consumable_use(delta)


func _on_dash_cooldown_timeout():
	print("dash is ready")
	dashready = true

#func equip_weapon(weaponsprite, bulletsprite):
	#equipped = true
	#$weapon_sprite.texture = load(weaponsprite)
	#$weapon_sprite.visible = true
	#curr_bullet_sprite = load(bulletsprite)
	#pass
	#

	
#ranged ability
#func shoot():
	#if Input.is_action_just_pressed("primary_action") and shootready and equipped:
		#shootready = false
		#var pb = pigbullet_scene.instantiate()
		#pb.get_node("Sprite2D").texture = curr_bullet_sprite
		#get_parent().add_child(pb)
		#pb.global_position = $Marker2D.global_position
		#var dir = (get_global_mouse_position() - pb.global_position).normalized()
		##pb.global_rotation = dir.angle() + PI / 2.0
		#pb.direction = dir
		#
		#$shoot_cooldown.start()

#
#func _on_shoot_cooldown_timeout():
	#shootready = true


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
		Globals.health -= damage
		camera_shake.emit()
		invulnerable = true
		# flash red when talking damage
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		
		$dmg_iframe_cooldown.start()
		#camera_shake.emit()
	

func set_invincible(time):
	$dmg_iframe_cooldown.wait_time = time
	$dmg_iframe_cooldown.start()
	
	invulnerable = true



func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false

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
					traj_line.show()
					update_trajectory(torch_speed)
				torch_hold_time += delta
			elif Input.is_action_just_released("secondary_action"):
				traj_line.hide()
				traj_line.clear_points()
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
		$Torch.visible = false
			
func toggle_flashlight(delta):
	if Globals.inv.contains(flashlight_resource):
		var flashlight_instance = flashlight_scene.instantiate()
		if Input.is_action_just_pressed("primary_action"):
			flashlight.light_on = not flashlight.light_on
			print("light on")
			print(flashlight.light_on)
		
		elif Input.is_action_pressed("secondary_action"):
			if temp_speed < flashlight_instance.speed:
				temp_speed += 5
				traj_line.show()
				update_trajectory(temp_speed)
			hold_time += delta
		elif Input.is_action_just_released("secondary_action"):
			traj_line.hide()
			traj_line.clear_points()		
			Globals.inv.remove_item(current_tool.item, 1)
			#var temp_apple = load("res://scenes/items/apple.tscn").instantiate()
			
			hold_time = 0.0
			
			flashlight_instance.global_position = $Marker2D2.global_position
			var dir = (get_global_mouse_position() - flashlight_instance.global_position).normalized()
			flashlight_instance.linear_velocity.x = dir.x*temp_speed
			flashlight_instance.linear_velocity.y = dir.y*temp_speed
			flashlight_instance.angular_velocity = 10
			flashlight_instance.pickup = false
			
			Globals.pig.get_tree().current_scene.add_child(flashlight_instance)
			temp_speed = 0
		
	else:
		flashlight.visible = false



func change_tool(hb_num):
	curr_hb_num = hb_num
	current_tool = Globals.inv.hb_slots[hb_num]
	if current_tool.item != null:
		flashlight_equipped = (current_tool.item.name == "Flashlight")
		flashlight.light_on = (current_tool.item.name == "Flashlight")
		flashlight.equipped = (current_tool.item.name == "Flashlight")
		print("change tool")
		torch_equipped = (current_tool.item.name == "Torch")
		consumable_equipped = !(flashlight_equipped or torch_equipped)
	else:
		torch_equipped = false
		flashlight_equipped = false
		flashlight.light_on = false
		flashlight.equipped = false
		consumable_equipped = false
	return toggle_tool_sprites()
	
func toggle_tool_sprites():
	$Torch.visible = torch_equipped
	if torch_equipped or flashlight_equipped:
		$Sprite2D.frame = 9
		$AnimationPlayer.play("torch")
	else:
		$Sprite2D.frame = 3
	return 0

func consumable_use(delta):
	var toolString = current_tool.item.useScript
	var consScript = ResourceLoader.load(toolString)
	var cons = consScript.instantiate()
	cons.effect(delta)
	
	#assuming all consumables have speed
	#temp_speed = cons.speed
	if Input.is_action_pressed("secondary_action"):
		if temp_speed < cons.speed:
			temp_speed += 5
			traj_line.show()
			update_trajectory(temp_speed)
		hold_time += delta
	elif Input.is_action_just_released("secondary_action"):
		traj_line.hide()
		traj_line.clear_points()		
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

func update_trajectory(spd_val):
	var pos = global_position
	
	var vel = (get_global_mouse_position()-global_position).normalized() * spd_val
	
	pos += vel
	
	traj_line.add_point(traj_line.to_local(pos))
	pass
