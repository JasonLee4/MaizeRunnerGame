extends EnemyFollow
class_name BossFollow

@export var totalTime = 5
var time : float

func enter():
	time = 0

func update(delta: float):
	if enemy.health <= 0:
		transitioned.emit(self, "BossDead")
	elif time < totalTime:
		time += delta
	elif enemy.can_attack and enemy.can_attack_player:
		print("follow -> attack")
		transitioned.emit(self, "BossAttack")
	else:
		transitioned.emit(self, "BossSpawnMinions")
