extends enemy
class_name rat

@onready var state_machine = get_node("State Machine")

@export var detection_radius : float

func _ready():
	$squeak_cooldown.start(randf_range(1, 5))

func on_fire():
	$Burning.visible = true
	
func on_blue_fire():
	$BlueBurning.visible = true

func special_animation():
		
	#Eye animation flipping
	if $Base.flip_h == true:
		$RedEyes.flip_h = true
		$YellowEyes.flip_h = true
	else:
		$RedEyes.flip_h = false
		$YellowEyes.flip_h = false
		
	#Eye animation color
	if state_machine.get_current_state().name == "EnemyThrown":
		$RedEyes.hide()
		$YellowEyes.hide()
	elif state_machine.get_current_state().name != "EnemyFollow" and state_machine.get_current_state().name != "EnemyAttack":
		$RedEyes.hide()
		$YellowEyes.show()
	else:
		$RedEyes.show()
		$YellowEyes.hide()

func reset_animation():
	$Base.visible = true
	$Base.position = Vector2(0,0)
	$Ball.visible = false
	$YellowEyes.position = Vector2(0,0)
	
func process_sound():
	if state_machine.get_current_state().name == "EnemyFollow" and !$run.playing:
		#print("playing run")
		$run.play()
	elif state_machine.get_current_state().name != "EnemyFollow" and $run.playing:
		#print("stopping run")a
		$run.stop()
		
func deal_damage():
	$bite.play()
	super.deal_damage()

func light_unfreeze():
	#print("Rat can move")
	var currentState = state_machine.get_current_state()
	if currentState.name != "EnemyTossed":
		currentState.transitioned.emit(currentState, "EnemyIdle")

func light_freeze():
	#print("Rat shined on")
	var currentState = state_machine.get_current_state()
	if currentState.name != "EnemyTossed":
		currentState.transitioned.emit(currentState, "EnemyFreeze")

func _on_squeak_cooldown_timeout():
	$squeak_cooldown.stop()
	$squeak.play()

func _on_audio_stream_player_2d_finished():
	$squeak_cooldown.start(randf_range(1, 5))
	
func rat():
	pass
