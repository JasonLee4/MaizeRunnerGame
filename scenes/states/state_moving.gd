extends PlayerState


@export var accspd = 1500
var max_spd = Globals.pig_speed
var can_roll = true
var move = Vector2.ZERO


func _game_logic(delta):
	
	
	# get movement inputs
	move = Vector2(int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")), int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")))
	
	# if inputs have been pressed
	if move.length() > 0:
		# accelerate
		move = move.normalized()
		
		# get the distance
		var distance = player.velocity.length()
		distance += (accspd * delta)
		
		if distance > max_spd:
			distance = max_spd
		
		if Globals.pig.flashlight_equipped and ((move.x > 0 and !Globals.pig.lookright) or (move.x < 0 and Globals.pig.lookright)):
			#print("walking backwards")
			distance *= 0.75
		# set the velocity
		player.velocity = move * distance
	else:
		
		# check if snapping to 0 is neccessary
		accspd = 1500
		if player.velocity.length() <= (accspd * delta):
			player.velocity = Vector2(0, 0)
		else:
			# otherwise, just decelerate
			var angle = player.velocity.angle()
			var new_length = player.velocity.length() - (accspd * delta)
			
			player.velocity = Vector2(new_length, 0).rotated(angle)


func _transition_logic(existing_states):
	if not Globals.pig.pig_alive:
		machine.change_state("state_dead") 
	
	elif can_roll and Input.is_action_just_pressed("dash"):
		# transition to rolling
		can_roll = false
		$RollCooldown.start()
		machine.change_state("state_rolling", [move], [])
	elif move.length() == 0:
		machine.change_state("state_idle")
		


func _enter(args := []):
	# start the roll cooldown timer
	#can_roll = true
	#$RollCooldown.start()
	pass


func _on_roll_cooldown_timeout():
	print("can roll!!")
	can_roll = true
