extends EnemyAttack
class_name BossAttack

func update(delta: float):
	if enemy.health <=0:
		transitioned.emit(self, "BossDead")
	elif enemy.can_attack and enemy.can_attack_player:
		print("swiping")
		enemy.deal_damage()
		enemy.get_node("AnimationPlayer").play("swipe")
	elif enemy.can_attack and !enemy.can_attack_player:
		transitioned.emit(self, "BossFollow")
