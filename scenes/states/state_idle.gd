extends PlayerState

@onready var animation_player :AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")
var move

func _enter(args := []) -> void:
	print("Entered player idle state...")
	animation_player.stop()
	$IdleCooldown.start()


# execute game logic here
func _game_logic(delta) -> void:
	# get movement inputs
	
	player.velocity = Vector2(0,0)
	move = Vector2(int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")), int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")))



# virtual method for running transition logic
# this in
func _transition_logic(existing_states: Array):
	
	if move.length() > 0:
		#if Input.is_action_just_pressed("dash"):
			## transition to rolling
			#machine.change_state("state_rolling", [move], [])
		#else:
		machine.change_state("state_moving")
		

func _on_idle_cooldown_timeout():
	print("playing idle animation [idle state]")
	#var randii = randi()%2
	#print(randii)
	#if randii == 0:
	animation_player.play("pigidle")
	#else:
		#player.get_node("Wave").visible = true
		#player.get_node("Sprite2D").visible = false
		#animation_player.play("pigwave")
	
	
