extends enemy

@onready var stateMachine = get_node("State Machine")
@onready var pigLight = Globals.pig.get_node("piglight/piglightarea")

@export var detectionRadius : float

func _ready():
	##var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	##$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	#
	set_health()
	pass
	
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
		
