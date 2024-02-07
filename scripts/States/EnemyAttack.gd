extends State
class_name EnemyAttack

@export var enemy: enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter():
	print("enemy attacking")

func update(delta):
	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()
	elif enemy.can_attack and !enemy.can_attack_player:
		print("attack -> idle")
		transitioned.emit(self, "EnemyIdle")
