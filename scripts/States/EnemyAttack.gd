extends State
class_name EnemyAttack

@export var enemy: enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter():
	print("enemy attacking")
	enemy.deal_damage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy.can_attack:
		enemy.deal_damage()
	elif not enemy.can_attack_player and enemy.can_attack:
		transitioned.emit(self, "EnemyIdle")
