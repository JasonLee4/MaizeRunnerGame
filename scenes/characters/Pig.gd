extends CharacterBody2D


var pigbullet_scene = preload("res://scenes/projectiles/pigbullet.tscn")
var torch_scene = preload("res://scenes/items/torch.tscn")
var torch_resource = preload("res://scenes/items/inventory/inv_items/Torch.tres")
var flashlight_scene = preload("res://scenes/items/Flashlight_item.tscn")
var flashlight_resource = preload("res://scenes/items/inventory/inv_items/Flashlight.tres")

@onready var traj_line = $trajectory_line
@onready var state_machine = get_node("player_state_machine")
@onready var hotbar = get_tree().current_scene.get_node("UI").get_node("HotBar")
@onready var flashlight = $Flashlight

@export var lookright : bool
@export var flashlight_equipped = false

@export var curr_hb_num = 0
var dashready = true
var invulnerable = false
@export var pig_alive = true


var torch_equipped = false
var torch_hold_time = 0.0
var torch_speed = 10

var current_tool
var consumable_equipped = false

var temp_speed = 0
var hold_time = 0.0
signal camera_shake

# true = facing right, false = facing left
var pigfacing = true

func _ready():

	#verify_save_directory(Globals.save_file_path)
	
	
	
	Globals.pig = $"."
	print("pig inst")
	hotbar.connect("hotbar_select", change_tool)
	change_tool(0)
	flashlight.light_on = true
	traj_line.clear_points()
	$Torch.play()
	

	
func _physics_process(delta):
	# run through states
	state_machine.process_states(delta)
	traj_line.look_at(get_global_mouse_position())
	if pig_alive:
		#use keying instead in anim player
		#if ($Sprite2D.frame == 6 or 
			#$Sprite2D.frame == 8 or 
			#$Sprite2D.frame == 10 or 
			#$Sprite2D.frame == 12 or
			#$Sprite2D.frame == 14 or
			#$Sprite2D.frame == 16) and velocity != Vector2(0,0) and $Steps.playing == false:
			#$Steps.play_rand_sound()
			
		#$Sprite2D.flip_h = !lookright
		if flashlight_equipped:
			lookright = ((get_global_mouse_position().x - global_position.x) >= 0)
			if lookright:
				flashlight.position.x = abs(flashlight.position.x)
				$Torch.position.x = abs($Torch.position.x)
				$Sprite2D.flip_h = false
				
			else:
				flashlight.position.x = -1 * abs(flashlight.position.x)
				$Torch.position.x = -1 * abs($Torch.position.x)
				$Sprite2D.flip_h = true
			
		if velocity != Vector2(0,0):
			if state_machine.selected_state.name == "state_rolling":
				$Sprite2D.visible = false
				$Roll.visible = true
				if(!$Dash.is_playing()):
					$Dash.play()
				
				$AnimationPlayer.play("pigroll")
			elif state_machine.selected_state.name == "state_moving":
				$Sprite2D.visible = true
				$Roll.visible = false
				#if velocity.x < 0:
						#pigfacing = false
						##$Sprite2D.flip_h = true
						#$Roll.flip_h = true					
						#
				#elif velocity.x > 0:
						#pigfacing = true
						##$Sprite2D.flip_h = false
						#$Roll.flip_h = false					
						
					
				if flashlight_equipped:				
					
					#$Sprite2D.flip_h = !lookright
					#if lookright:
						#flashlight.position.x = abs(flashlight.position.x)
						#$Torch.position.x = abs($Torch.position.x)
						#
					#else:
						#flashlight.position.x = -1 * abs(flashlight.position.x)
						#$Torch.position.x = -1 * abs($Torch.position.x)
					
					$AnimationPlayer.play("pigwalk_equip_right")
					#else:
						#$AnimationPlayer.play("pigwalk_equip_left")
				else:
					if velocity.x < 0:
						#pigfacing = false
						$Torch.position.x = -1 * abs($Torch.position.x)
						
						$Sprite2D.flip_h = true
						$Roll.flip_h = true					
						
					elif velocity.x > 0:
						#pigfacing = true
						$Torch.position.x = abs($Torch.position.x)
						
						$Sprite2D.flip_h = false
						$Roll.flip_h = false	
					if torch_equipped:
						$AnimationPlayer.play("pigwalk_equip_right")
						
					else:
						
						$AnimationPlayer.play("pigwalk")
					
				
				
			
		else:
			$AnimationPlayer.stop(true)
			#if pigfacing:
				#$Torch.position.x = abs($Torch.position.x)
				#flashlight.position.x = abs(flashlight.position.x)
				#
			#else:
				#$Torch.position.x = -1 * abs($Torch.position.x)
				#flashlight.position.x = -1 * abs(flashlight.position.x)
				
				
			if state_machine.selected_state.name == "state_idle":
				$Sprite2D.visible = true
				if flashlight_equipped:
					$Sprite2D.flip_h = !lookright
					
				$Roll.visible = false
					
				
				
		
		
		move_and_slide()

		#
		if Globals.health <= 0:
			pig_alive = false
			print("Pig is dead")
			Globals.lvl_end.emit()
			Globals.game_end_time = Time.get_ticks_msec()
			Globals.monologue.emit("")
			#$AnimationPlayer.play("pigdeath")
			#
			#await get_tree().create_timer(1.5).timeout
			#get_tree().change_scene_to_file("res://scenes/menus/end_screen.tscn")
			#self.queue_free()

		if flashlight_equipped:	
			flashlight.visible = true
			toggle_flashlight(delta)
		
		if !flashlight_equipped and torch_equipped:
			use_torch(delta)
		
		if consumable_equipped:
			consumable_use(delta)
	
	else:
		velocity = Vector2(0,0)
		flashlight.visible = false
		flashlight.light_on = false
		$Torch.visible = false
		



func _process(delta):
	
	#change_tool(curr_hb_num)
	pass



func _on_dash_cooldown_timeout():
	print("dash is ready")
	dashready = true




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
	if not invulnerable && pig_alive:
		Globals.health -= damage
		$PigHit.play_rand_sound()
		camera_shake.emit()
		invulnerable = true
		# flash red when talking damage
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		
		$dmg_iframe_cooldown.start()
		var roll = randf()
		var mono = ""
		if roll < .15:
			mono = "My granny's dentures bite harder than this!"
		elif  roll < .3:
			mono = "You call that a bite? I've had worse from a day-old apple!"	
		elif roll < .5:
			mono = "Ah shucks..."
		Globals.monologue.emit(mono)
	if Globals.health <= 0:
		invulnerable = true
		

	

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
				
				$LightThrow.play()
				
				
				var tr = torch_scene.instantiate()			
				
				torch_hold_time = 0.0
				
				tr.global_position = $Marker2D2.global_position
				var dir = (get_global_mouse_position() - tr.global_position).normalized()
				tr.linear_velocity.x = dir.x*torch_speed
				tr.linear_velocity.y = dir.y*torch_speed
				tr.angular_velocity = 10
				get_tree().current_scene.add_child(tr)
				
				torch_speed = 0
				if !Globals.inv.contains(torch_resource):
					torch_equipped = false
					$Torch.visible = false
					
	else:
		$Torch.visible = false
			
func toggle_flashlight(delta):
	if Globals.inv.contains(flashlight_resource):
		var flashlight_instance = flashlight_scene.instantiate()
		if Input.is_action_just_pressed("primary_action"):
			$FlashlightSound.play()
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
			
			flashlight.equipped = false
			
			traj_line.hide()
			traj_line.clear_points()		
			Globals.inv.remove_item(current_tool.item, 1)
			
			$LightThrow.play()
			
			flashlight_equipped = false
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
		#print("change tool")
		torch_equipped = (current_tool.item.name == "Torch")
		consumable_equipped = !(flashlight_equipped or torch_equipped)
	else:
		torch_equipped = false
		flashlight_equipped = false
		flashlight.light_on = false
		flashlight.equipped = false
		consumable_equipped = false
	toggle_tool_sprites()
	
func toggle_tool_sprites():
	$Torch.visible = torch_equipped
	
	if torch_equipped or flashlight_equipped:	
		if $Sprite2D.frame not in range(23,28):
			$Sprite2D.frame = 23
	else:
		if $Sprite2D.frame not in range(17,22):
			$Sprite2D.frame = 17
		
	

func consumable_use(delta):
	var toolString = current_tool.item.useScript
	var consScript = ResourceLoader.load(toolString)
	var cons = consScript.instantiate()
	cons.effect(delta)
	
	
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
		
		$LightThrow.play()
		
		
		hold_time = 0.0
		
		cons.global_position = $Marker2D2.global_position
		var dir = (get_global_mouse_position() - cons.global_position).normalized()
		cons.linear_velocity.x = dir.x*temp_speed
		cons.linear_velocity.y = dir.y*temp_speed
		cons.angular_velocity = 20
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
