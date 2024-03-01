extends enemy

@onready var state_machine = get_node("State Machine")

@export var detection_radius : float

func _ready():
	$squeak_cooldown.start(randf_range(1, 5))

func choose_animation():
	#Movement animation
	super.choose_animation()
	
	if health <=0 :
		return 0
	
	if velocity.x == 0 and velocity.y == 0:
		#$AnimatedSprite2D.play("tail_wag")
		$AnimationPlayer.play("tail_wag")
		
	#Eye animation flipping
	if $Base.flip_h == true:
		$RedEyes.flip_h = true
		$YellowEyes.flip_h = true
	else:
		$RedEyes.flip_h = false
		$YellowEyes.flip_h = false
		
	#Eye animation color
	if state_machine.get_current_state().name != "EnemyFollow" and state_machine.get_current_state().name != "EnemyAttack":
		$RedEyes.hide()
		$YellowEyes.show()
		#$Eyes.play("yellow")
	else:
		$RedEyes.show()
		$YellowEyes.hide()
		#$Eyes.play("red")
		
func process_sound():
	if state_machine.get_current_state().name == "EnemyFollow" and !$run.playing:
		#print("playing run")
		$run.play()
	elif state_machine.get_current_state().name != "EnemyFollow" and $run.playing:
		#print("stopping run")a
		$run.stop()

func light_unfreeze():
	#print("Rat can move")
	var currentState = state_machine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyIdle")

func light_freeze():
	#print("Rat shined on")
	var currentState = state_machine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyFreeze")

func _on_squeak_cooldown_timeout():
	$squeak_cooldown.stop()
	$squeak.play();

func _on_audio_stream_player_2d_finished():
	$squeak_cooldown.start(randf_range(1, 5));
