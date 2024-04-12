extends enemy
class_name albinorat

@onready var state_machine = get_node("State Machine")

func on_fire():
	$Burning.visible = true

func special_animation():	
		
	#Eye animation flipping
	if $Base.flip_h == true:
		$RedEyes.flip_h = true
		#$YellowEyes.flip_h = true
	else:
		$RedEyes.flip_h = false
		#$YellowEyes.flip_h = false
		
func process_sound():
	if state_machine.get_current_state().name == "EnemyFollow" and !$run.playing:
		#print("playing run")
		$run.play()
	elif state_machine.get_current_state().name != "EnemyFollow" and $run.playing:
		#print("stopping run")
		$run.stop()

func light_unfreeze():
	#print("Rat can move")
	var currentState = state_machine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyIdle")

func light_freeze():
	#print("Rat shined on")
	var currentState = state_machine.get_current_state()
	if(currentState.get_name() != "EnemyFollow" && currentState.get_name() != "EnemyAttack"):
		currentState.transitioned.emit(currentState, "EnemyFollow")
		
func rat():
	pass
