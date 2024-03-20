extends State
class_name BossSpawnMinions

@export var totalMinions = 3
@export var spawnTime = 0.5

var spawnCooldown : float
var minionsSpawned : int

@export var boss : CharacterBody2D

@export var minionSpawnDistance = 50
@export var minion_scene : Resource

func enter():
	print("spawning minions")
	spawnCooldown = spawnTime
	minionsSpawned = 0
	spawn_minion()
	
func spawn_minion():
	var minion = minion_scene.instantiate()
	boss.get_parent().add_child(minion)
	minion.global_position = boss.global_position+Vector2(randf()*minionSpawnDistance, randf()*minionSpawnDistance)
	minionsSpawned += 1
	
func update(delta: float):
	if spawnCooldown > 0:
		spawnCooldown -= delta
	elif minionsSpawned < totalMinions:
		spawn_minion()
		spawnCooldown = spawnTime
	else:
		print("finished spawning")
		transitioned.emit(self, "BossDash")
	
