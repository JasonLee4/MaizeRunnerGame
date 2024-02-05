extends State
class_name EnemyAttack

@export var enemy: enemy
@export var ranged: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage(ranged)
	elif not enemy.can_attack_player:
		transitioned.emit(self, "EnemyIdle")
