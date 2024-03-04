extends State
class_name EnemyIdle

@onready var pig = Globals.pig

@export var enemy: CharacterBody2D
@export var move_speed := 20
@export var max_wander_time := 5
@export var min_wander_time := 1
@export var max_wait_time := 5
@export var min_wait_time := 1

var move_direction : Vector2
var wander_time : float
var wait_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(min_wander_time, max_wander_time)
	wait_time = randf_range(min_wait_time, max_wait_time)
	
func enter():
	#print("enemy wandering")
	assert(pig != null)
	randomize_wander()

func update(delta: float):
	if enemy.health <=0:
		transitioned.emit(self, "EnemyDead")
	elif "detection_radius" in enemy and enemy.global_position.distance_to(pig.global_position) <= enemy.detection_radius:
		transitioned.emit(self, "EnemyFollow")
	elif enemy.can_attack and enemy.can_attack_player:
		print("idle -> attack")
		transitioned.emit(self, "EnemyAttack")
	elif wander_time > 0:
		wander_time -= delta
	elif wait_time > 0:
		wait_time -= delta
	else:
		randomize_wander()
		
func physics_update(delta: float):
	if enemy:
		if wander_time > 0:
			enemy.velocity = Vector2(move_direction * move_speed)
			enemy.move_and_slide()
		elif wait_time > 0:
			enemy.velocity = Vector2(0,0)
