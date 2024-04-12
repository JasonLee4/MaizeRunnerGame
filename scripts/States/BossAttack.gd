extends EnemyAttack
class_name BossAttack

@onready var pig = 	Globals.pig

func enter():
	print("enter attack")

func update(delta: float):
	if enemy.health <=0:
		transitioned.emit(self, "BossDead")
	elif enemy.can_attack and enemy.can_attack_player:
		flip()
		enemy.deal_damage()
		enemy.get_node("AnimationPlayer").play("attack")
		#print("swiping")
	elif enemy.can_attack and !enemy.can_attack_player:
		transitioned.emit(self, "BossFollow")

func flip(): 
	if pig.global_position.x > enemy.global_position.x:
		enemy.get_node("Base").flip_h = false
	elif pig.global_position.x < enemy.global_position.x:
		enemy.get_node("Base").flip_h = true
