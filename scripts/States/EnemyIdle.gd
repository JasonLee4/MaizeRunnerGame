extends State
class_name EnemyIdle

@onready var pig = Globals.pig

@export var enemy: CharacterBody2D
@export var move_speed := 20
@export var max_wander_time := 5
@export var min_wander_time := 1

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(min_wander_time, max_wander_time)
	
func enter():
	#print("enemy wandering")
	#if get_tree() != null:
		#pig = get_tree().get_current_scene().get_node("Pig")
	assert(pig != null)
	randomize_wander()

func update(delta: float):
	if "detectionRadius" in enemy and enemy.global_position.distance_to(pig.global_position) <= enemy.detectionRadius:
		transitioned.emit(self, "EnemyFollow")
	elif wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func physics_update(delta: float):
	if enemy:
		enemy.velocity = Vector2(move_direction * move_speed)
		enemy.move_and_slide()
