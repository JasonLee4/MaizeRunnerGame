extends enemy

@onready var stateMachine = get_node("State Machine")

@export var detectionRadius : float
var cooldown : float

func _ready():
	##var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	##$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	#
	#set_health()
	print("ready")
	$squeak_cooldown.start(randf_range(1, 5))
	
func choose_animation():
	super.choose_animation()
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("tail_wag")

func light_unfreeze():
	#print("Rat can move")
	var currentState = stateMachine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyIdle")

func light_freeze():
	#print("Rat shined on")
	var currentState = stateMachine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyFreeze")
		


func _on_squeak_cooldown_timeout():
	print("Playing squeak");
	$squeak_cooldown.stop()
	$squeak.play();


func _on_audio_stream_player_2d_finished():
	$squeak_cooldown.start(randf_range(20, 60));
