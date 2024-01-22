extends State
class_name BossSpawnMinions

const totalMinions = 10
const spawnTime = 0.5

var spawnCooldown : float
var minionsSpawned : int

@export var boss : CharacterBody2D

const minionSpawnDistance = 50
@onready var minion_scene = preload("res://scenes/enemies/followingEnemy.tscn")

#TODO delete after deubgging
var exited = false

func enter():
	spawnCooldown = spawnTime
	minionsSpawned = 0
	#print(boss.global_position)
	spawn_minion()
	
func spawn_minion():
	var minion = minion_scene.instantiate()
	boss.get_parent().add_child(minion)
	minion.global_position = boss.global_position+Vector2(randf()*minionSpawnDistance, randf()*minionSpawnDistance)
	#print(get_parent().get_parent().get_parent())
	print("Spawning minion at ", minion.global_position)
	
func update(delta: float):
	if spawnCooldown > 0:
		spawnCooldown -= delta
	elif minionsSpawned < totalMinions:
		spawn_minion()
		spawnCooldown = spawnTime
		minionsSpawned += 1
	else:
		transitioned.emit(self, "follow")
	
