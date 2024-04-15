extends State
class_name BossSpawnMinions

@export var totalMinions = 3
@export var spawnTime = 0.5

@export var acceleration = 50
@export var min_minion_speed = 100
@export var max_minion_speed = 150

var spawnCooldown : float
var minionsSpawned : int

@export var enemy : CharacterBody2D

@export var minionSpawnDistance = 50
@export var minion_scene : Resource

func enter():
	print("spawning minions")
	spawnCooldown = spawnTime
	minionsSpawned = 0
	enemy.get_node("AnimationPlayer").play("swing_rat")
	enemy.get_node("spin").play()
	spawn_minion()
	
func spawn_minion():
	var minion = minion_scene.instantiate()
	enemy.get_parent().add_child(minion)
	
	var speed = randf_range(min_minion_speed, max_minion_speed)
	var spawn_direction = Vector2(randf_range(-1, 1),randf_range(-1, 0))
	
	minion.get_node("State Machine/EnemyTossed").set_values(speed, acceleration, spawn_direction)
	minion.get_node("State Machine").set_current_state("EnemyTossed")
	
	minion.detection_radius = 500
	minion.global_position = enemy.global_position+Vector2(0, -100)
	minionsSpawned += 1
	
func update(delta: float):
	if enemy.health <= 0:
		transitioned.emit(self, "BossRunAway")
	elif spawnCooldown > 0:
		spawnCooldown -= delta
	elif minionsSpawned < totalMinions:
		spawn_minion()
		spawnCooldown = spawnTime
	else:
		print("finished spawning")
		enemy.get_node("spin").stop()
		enemy.get_node("roar").play_rand_sound()
		transitioned.emit(self, "BossFollow")
	
