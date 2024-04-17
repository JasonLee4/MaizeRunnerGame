extends EnemyFollow
class_name BossFollow

@export var totalTime = 5
var time : float

func enter():
	time = 0

func update(delta: float):
	#print(str(enemy.can_attack)+" "+str(enemy.can_attack_player))
	if enemy.health <= 0:
		if Globals.cur_lvl == 5:
			transitioned.emit(self, "BossRunAway")
		elif Globals.cur_lvl == 10:
			transitioned.emit(self, "BossDead")
	elif time < totalTime:
		time += delta
	else:
		enemy.get_node("roar").play_rand_sound()
		transitioned.emit(self, "BossDashAndStomp")
	
	if enemy.can_attack and enemy.can_attack_player:
		print("follow -> attack")
		transitioned.emit(self, "BossAttack")

func physics_update(delta: float):
	super.physics_update(delta)
	flip()

func flip(): 
	if pig.global_position.x > enemy.global_position.x:
		enemy.get_node("Base").flip_h = false
	elif pig.global_position.x < enemy.global_position.x:
		enemy.get_node("Base").flip_h = true
