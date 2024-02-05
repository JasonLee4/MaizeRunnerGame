extends enemy

@onready var stateMachine = get_node("State Machine")
@onready var pigLight = owner.get_node("Pig/piglight/piglightarea")

@export var detectionRadius : float

func _ready():
	MAX_HEALTH = 100
	health = 100
	damage = 1
	
	#var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	#$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$Healthbar.max_value = MAX_HEALTH
	set_health()

func light_unfreeze():
	print("Rat can move")
	var currentState = stateMachine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyIdle")

func light_freeze():
	print("Rat shined on")
	var currentState = stateMachine.get_current_state()
	currentState.transitioned.emit(currentState, "EnemyFreeze")
		
